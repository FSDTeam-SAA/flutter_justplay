import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../network/constants/api_constants.dart';

/// Wraps the backend's Socket.IO connection for the player app. Mirrors the
/// pitch-owner app's realtime service so the same real-time guarantees
/// (banned/unbanned, booking changes, pitch availability changes, mass
/// notifications, system lockdown) apply here without requiring a manual
/// refresh.
class PlayerRealtimeService {
  io.Socket? _socket;
  String? _currentUserId;

  final StreamController<bool> _accountBannedController =
      StreamController<bool>.broadcast();
  final StreamController<Map<String, dynamic>> _bookingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _bookingDeletedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _pitchChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _pitchDeletedController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _eventChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _eventDeletedController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _cityChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _cityDeletedController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _sportChangedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _sportDeletedController =
      StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _reminderController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _lockdownController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Emits `true`/`false` whenever an admin bans/unbans this account while
  /// the app is open.
  Stream<bool> get accountBannedUpdates => _accountBannedController.stream;

  /// Fires on booking creation/status-change/reservation for this user (or
  /// for a pitch this owner manages, on the owner app's side).
  Stream<Map<String, dynamic>> get bookingUpdates => _bookingController.stream;
  Stream<Map<String, dynamic>> get bookingDeletedUpdates =>
      _bookingDeletedController.stream;

  /// Fires when a pitch is created or updated anywhere on the platform, so
  /// the pitch-selection list can refresh without a manual pull-to-refresh.
  Stream<Map<String, dynamic>> get pitchChangedUpdates =>
      _pitchChangedController.stream;
  Stream<String> get pitchDeletedUpdates => _pitchDeletedController.stream;

  /// Fires when an admin creates/updates/deletes an event, so the Events
  /// screen can refresh live while a user is looking at it.
  Stream<Map<String, dynamic>> get eventChangedUpdates =>
      _eventChangedController.stream;
  Stream<String> get eventDeletedUpdates => _eventDeletedController.stream;

  /// Fires when an admin creates/updates/deletes a country (City model), so
  /// city pickers can refresh live while a user is looking at them.
  Stream<Map<String, dynamic>> get cityChangedUpdates =>
      _cityChangedController.stream;
  Stream<String> get cityDeletedUpdates => _cityDeletedController.stream;

  /// Fires when an admin creates/updates/deletes a sport, so sport pickers
  /// can refresh live while a user is looking at them.
  Stream<Map<String, dynamic>> get sportChangedUpdates =>
      _sportChangedController.stream;
  Stream<String> get sportDeletedUpdates => _sportDeletedController.stream;

  Stream<Map<String, dynamic>> get notifications =>
      _notificationController.stream;
  Stream<Map<String, dynamic>> get reminders => _reminderController.stream;
  Stream<Map<String, dynamic>> get lockdownUpdates =>
      _lockdownController.stream;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String userId) {
    if (userId.isEmpty) return;

    if (_currentUserId == userId && (_socket?.connected ?? false)) {
      return;
    }

    disconnect();

    final socket = io.io(
      ApiConstants.socketBaseUrl,
      io.OptionBuilder()
          .setTransports(<String>['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _socket = socket;
    _currentUserId = userId;

    socket.onConnect((_) {
      socket.emit('join', userId);
    });

    socket.on('account:status-updated', (dynamic data) {
      final payload = _asMap(data);
      if (payload.containsKey('isBanned')) {
        _accountBannedController.add(payload['isBanned'] == true);
      }
    });

    void handleBooking(dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _bookingController.add(payload);
      }
    }

    socket.on('booking:updated', handleBooking);
    socket.on('booking:created', handleBooking);
    socket.on('booking:reserved', handleBooking);

    socket.on('booking:deleted', (dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _bookingDeletedController.add(payload);
      }
    });

    void handlePitchChanged(dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _pitchChangedController.add(payload);
      }
    }

    socket.on('pitch:created', handlePitchChanged);
    socket.on('pitch:updated', handlePitchChanged);

    socket.on('pitch:deleted', (dynamic data) {
      final payload = _asMap(data);
      final id = '${payload['_id'] ?? ''}';
      if (id.isNotEmpty) {
        _pitchDeletedController.add(id);
      }
    });

    void handleEventChanged(dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _eventChangedController.add(payload);
      }
    }

    socket.on('event:created', handleEventChanged);
    socket.on('event:updated', handleEventChanged);

    socket.on('event:deleted', (dynamic data) {
      final payload = _asMap(data);
      final id = '${payload['_id'] ?? ''}';
      if (id.isNotEmpty) {
        _eventDeletedController.add(id);
      }
    });

    void handleCityChanged(dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _cityChangedController.add(payload);
      }
    }

    socket.on('city:created', handleCityChanged);
    socket.on('city:updated', handleCityChanged);

    socket.on('city:deleted', (dynamic data) {
      final payload = _asMap(data);
      final id = '${payload['_id'] ?? ''}';
      if (id.isNotEmpty) {
        _cityDeletedController.add(id);
      }
    });

    void handleSportChanged(dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _sportChangedController.add(payload);
      }
    }

    socket.on('sport:created', handleSportChanged);
    socket.on('sport:updated', handleSportChanged);

    socket.on('sport:deleted', (dynamic data) {
      final payload = _asMap(data);
      final id = '${payload['_id'] ?? ''}';
      if (id.isNotEmpty) {
        _sportDeletedController.add(id);
      }
    });

    socket.on('notification:new', (dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _notificationController.add(payload);
      }
    });

    socket.on('notification:mass', (dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _notificationController.add(payload);
      }
    });

    socket.on('booking:reminder', (dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _reminderController.add(payload);
      }
    });

    socket.on('system:lockdown-updated', (dynamic data) {
      final payload = _asMap(data);
      if (payload.isNotEmpty) {
        _lockdownController.add(payload);
      }
    });

    socket.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _currentUserId = null;
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return <String, dynamic>{};
  }
}
