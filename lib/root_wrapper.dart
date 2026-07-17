// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'core/network/services/auth_storage_service.dart';
//
// class RootWrapper extends StatelessWidget {
//   RootWrapper({super.key});
//
//   final AuthStorageService _authStorageService = AuthStorageService();
//
//   Future<bool> _checkToken() async {
//     final token = await _authStorageService.getRefreshToken();
//     return token != null && token.isNotEmpty;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _checkToken(),
//       builder: (context, snapshot) {
//         // While checking token, show a loading screen
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         // Once we have the result, redirect using GoRouter
//         final isAuthenticated = snapshot.data ?? false;
//
//         if (isAuthenticated) {
//           // User is logged in → go to main app (home with bottom nav)
//           context.go('/home');
//         } else {
//           // User is not logged in → go to auth flow
//           context.go('/create-account');
//         }
//
//         // This widget is returned briefly during the redirect
//         // Show a blank screen or loader to avoid flashing wrong content
//         return const Scaffold(
//           //backgroundColor: Colors.white, // Optional: match your app's background
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }