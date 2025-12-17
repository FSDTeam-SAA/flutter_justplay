import 'package:dio/dio.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_profile_response_model.dart';
import '../../../core/network/network_result.dart';
import '../models/response/update_profile_response_model.dart';




abstract class ProfileRepository {
  NetworkResult<FetchProfileResponseModel> fetchProfile();

  //profile update
  NetworkResult<UpdateProfileResponseModel> updatePersonalInfo(FormData formData);
//
// //Change password
//   NetworkResult<void> changePass(UpdatePasswordRequestModel request);
//   NetworkResult<OngoingOrderResponseModel> fetchOngoingOrder();
//   NetworkResult<OngoingOrderResponseModel> fetchCompletedOrder();
//   NetworkResult<List<GetFavoriteItemsResponseModel>> fetchFavoriteItems(String userId);
// NetworkResult<Category> fetchCategory(String userId);
//
//   NetworkResult<UserResponse> uploadPhoto(FormData request);
//
//
//   NetworkResult<UserResponse> tradingInfo(FormData request);
}
