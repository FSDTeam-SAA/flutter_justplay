class ApiConstants {
  /// [Base Configuration]
  // static const String baseDomain = 'http://10.10.5.33:5001'; // eshita
  static const String baseDomain = 'https://backend-just-play.onrender.com'; // Live
  static const String baseUrl = '$baseDomain/api/v1';

  /// Dynamically generated WebSocket URL based on baseDomain
  // static String get webSocketUrl {
  //   if (baseDomain.startsWith('https://')) {
  //     return baseDomain.replaceFirst('https://', 'wss://');
  //   } else if (baseDomain.startsWith('http://')) {
  //     return baseDomain.replaceFirst('http://', 'ws://');
  //   }
  //   // Fallback for unexpected cases (e.g., no scheme)
  //   return 'ws://$baseDomain';
  // }

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
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String register = '$_base/register';
  final String login = '$_base/login';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyOtp = '$_base/verify-otp';
  final String resetPassword = '$_base/reset-password';

  final String updatePassword = '$_base/change-password';

  final String refreshToken = '$_base/refresh';
}

class ProfileEndpoints {
  static const String _base = ApiConstants.baseUrl;
  final String fetchProfile = '$_base/user/profile';
  final String updateProfile = '$_base/user/update-profile';

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

