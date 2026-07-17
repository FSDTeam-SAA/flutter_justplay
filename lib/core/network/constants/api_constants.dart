import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiConstants {
  /// [Base Configuration]
  static const String _baseDomainOverride = String.fromEnvironment(
    'BASE_DOMAIN',
    defaultValue: '',
  );

  static String get baseDomain {
    if (_baseDomainOverride.isNotEmpty) {
      return _baseDomainOverride.endsWith('/')
          ? _baseDomainOverride.substring(0, _baseDomainOverride.length - 1)
          : _baseDomainOverride;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:5001';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001';
    }

    return 'http://127.0.0.1:5001';
  }

   // static const String liveBaseDomain = 'https://backend-just-play.onrender.com'; // Live
  static String get baseUrl => '$baseDomain/api/v1';

  /// Socket.IO connects to the bare domain (not the /api/v1 REST prefix).
  static String get socketBaseUrl => baseDomain;

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups
  static AuthEndpoints get auth => AuthEndpoints();
  static ProfileEndpoints get profile => ProfileEndpoints();
  static HomeEndpoints get home => HomeEndpoints();
  static EventEndpoints get event => EventEndpoints();
  static BookingEndpoints get booking => BookingEndpoints();

}

/// [Authentication Endpoints]
class AuthEndpoints {
  static String get _base => '${ApiConstants.baseUrl}/auth';

  final String register = '$_base/register';
  final String login = '$_base/login';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyOtp = '$_base/verify-otp';
  final String resetPassword = '$_base/reset-password';

  final String updatePassword = '$_base/change-password';

  final String refreshToken = '$_base/refresh-token';
}

class ProfileEndpoints {
  static String get _base => ApiConstants.baseUrl;
  final String fetchProfile = '$_base/user/profile';
  final String updateProfile = '$_base/user/update-profile';
  final String registerDeviceToken = '$_base/user/device-token';
  final String removeDeviceToken = '$_base/user/device-token';

  String fetchFavorite(String userId) => '${ApiConstants.baseUrl}/favorites/$userId';
  final String fetchOngoing = '${ApiConstants.baseUrl}/orders/my?filter=ongoing';
  final String fetchDelivered = '${ApiConstants.baseUrl}/orders/my?filter=completed';
}

class HomeEndpoints {
  final String category = '${ApiConstants.baseUrl}/categories';
   String items(String categoryId) => '${ApiConstants.baseUrl}/items?category=$categoryId';
   String searchItem(String text) => '${ApiConstants.baseUrl}/items?search=$text';

   final String getCity = '${ApiConstants.baseUrl}/city/';
   final String getSport = '${ApiConstants.baseUrl}/sport/';
   final String getPitch = '${ApiConstants.baseUrl}/pitch/';
   final String issue = '${ApiConstants.baseUrl}/issue/';
   final String createBooking = '${ApiConstants.baseUrl}/booking/';
   final String reserveBooking = '${ApiConstants.baseUrl}/booking/reserve';
   String confirmReservedBooking(String reservationId) =>
       '${ApiConstants.baseUrl}/booking/$reservationId/confirm';
   final String availability = '${ApiConstants.baseUrl}/booking/availability';
   final String publicSettings = '${ApiConstants.baseUrl}/settings/public';
}

class EventEndpoints {
  final String fetchEvent = '${ApiConstants.baseUrl}/event/';
  String fetchOrder = '${ApiConstants.baseUrl}/orders/my';
  String placeOrder = '${ApiConstants.baseUrl}/orders';
}

class BookingEndpoints {
  final String fetchBooking = '${ApiConstants.baseUrl}/booking/';
  String cancleBooking(String bookingId) => '${ApiConstants.baseUrl}/booking/$bookingId';
  String placeOrder = '${ApiConstants.baseUrl}/orders';
}

