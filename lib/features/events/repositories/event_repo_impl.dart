import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';
import 'package:flutter_justplay/features/events/repositories/event_repo.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';


class EventRepoImpl implements EventRepo{
  final ApiClient _apiClient;

  EventRepoImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<GetEventListResponseModel> fetchEvent(){
    return _apiClient.get(endpoint: ApiConstants.event.fetchEvent,
      fromJsonT: (json) => GetEventListResponseModel.fromJson(json as Map<String, dynamic>),
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