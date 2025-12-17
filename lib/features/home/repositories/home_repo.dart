import 'package:flutter_justplay/features/home/models/request/booking_request_model.dart';
import 'package:flutter_justplay/features/home/models/request/issue_request_model.dart';
import 'package:flutter_justplay/features/home/models/response/booking%20_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_city_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_sport_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/issue_response_model.dart';
import '../../../core/network/network_result.dart';
import '../models/response/fetch_pitch_response_model.dart';


abstract class HomeRepo {
  NetworkResult<FetchCityResponseModel> fetchCity();
  NetworkResult<FetchSportResponseModel> fetchSport();
  NetworkResult<FetchPitchResponseModel> fetchPitch();

  // //profile update
  // NetworkResult<UpdateProfileResponseModel> updatePersonalInfo(FormData formData);
//
// //Change password
  NetworkResult<IssueResponseModel> issue(IssueRequestModel request);
  NetworkResult<BookingResponse> createBooking(BookingRequest request);
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
