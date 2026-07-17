import 'dart:convert';

import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import '../models/request/login_request_model.dart';
import '../models/request/register_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/register_response_model.dart';
import 'auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request){
    return _apiClient.post(
      endpoint: ApiConstants.auth.register,
      data: request.toJson(),
      fromJsonT: (json) => RegisterResponseModel.fromJson(json),
    );
  }
  //
  @override
  NetworkResult<LoginResponseModel> login(LoginRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => LoginResponseModel.fromJson(json),
    );
  }
  //
  // @override
  // NetworkResult<ForgotPasswordResponseModel> forgotPassword(
  //     ForgotPasswordRequestModel request) {
  //   return _apiClient.post(endpoint: ApiConstants.auth.forgotPassword,
  //       data: request.toJson(),
  //       fromJsonT: (json) => ForgotPasswordResponseModel.fromJson(json));
  // }
  //
  // @override
  // NetworkResult<void> verifyOtp(VerifyOtpRequestModel request) {
  //   return _apiClient.post(endpoint: ApiConstants.auth.verifyOtp,
  //       data: request.toJson(),
  //       fromJsonT: (json) {});
  // }
  //
  // @override
  // NetworkResult<void> createNewPassword(CreateNewPasswordRequestModel request) {
  //   return _apiClient.post(
  //       endpoint: ApiConstants.auth.resetPassword,
  //       data: request.toJson(),
  //       fromJsonT: (json) {});
  // }
  //
  // @override
  // NetworkResult<LoginResponseModel> refreshToken(
  //     RefreshTokenRequestModel request,) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.refreshToken,
  //     data: request.toJson(),
  //     fromJsonT: (json) => LoginResponseModel.fromJson(json),
  //   );
  // }
  //
  // @override
  // NetworkResult<RefreshTokenResponseModel> refreshTOken(
  //     RefreshTokenRequestModel request,) {
  //   return _apiClient.post(
  //     endpoint: ApiConstants.auth.refreshToken,
  //     data: request.toJson(),
  //     fromJsonT: (json) => RefreshTokenResponseModel.fromJson(json),
  //   );
  // }
}
