import 'package:flutter_justplay/features/bookings/presentation/repositories/booking_repo.dart';
import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/response/get_all_booking_response_model.dart';


class BookRepoImpl implements BookingRepo{
  final ApiClient _apiClient;

  BookRepoImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetAllBookingResponseModel> fetchBooking(){
    return _apiClient.get(endpoint: ApiConstants.booking.fetchBooking,
      fromJsonT: (json) => GetAllBookingResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  NetworkResult<void> deleteBooking(String bookingId){
    return _apiClient.delete(
      endpoint: ApiConstants.booking.cancleBooking(bookingId),
      fromJsonT: (json) {},
    );
  }

// @override
// NetworkResult<FetchSportResponseModel> fetchSport(){
//   return _apiClient.get(endpoint: ApiConstants.home.getSport,
//     fromJsonT: (json) => FetchSportResponseModel.fromJson(json as Map<String, dynamic>),
//   );
// }@override
// NetworkResult<FetchPitchResponseModel> fetchPitch(){
//   return _apiClient.get(endpoint: ApiConstants.home.getPitch,
//     fromJsonT: (json) => FetchPitchResponseModel.fromJson(json as Map<String, dynamic>),
//   );
// }
//
// @override
// NetworkResult<IssueResponseModel> issue(IssueRequestModel request){
//   return _apiClient.post(
//     endpoint: ApiConstants.home.issue,
//     data: request.toJson(),
//     fromJsonT: (json) => IssueResponseModel.fromJson(json),
//   );
// }
//
// @override
// NetworkResult<BookingResponse> createBooking(BookingRequest request){
//   return _apiClient.post(
//     endpoint: ApiConstants.home.createBooking,
//     data: request.toJson(),
//     fromJsonT: (json) => BookingResponse.fromJson(json),
//   );
// }

}