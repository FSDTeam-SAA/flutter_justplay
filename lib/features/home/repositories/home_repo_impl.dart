
import 'package:flutter_justplay/features/home/models/response/fetch_sport_response_model.dart';
import 'package:flutter_justplay/features/home/repositories/home_repo.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../models/request/booking_request_model.dart';
import '../models/request/issue_request_model.dart';
import '../models/request/reserve_booking_request_model.dart';
import '../models/response/availability_response_model.dart';
import '../models/response/booking _response_model.dart';
import '../models/response/fetch_city_response_model.dart';
import '../models/response/fetch_pitch_response_model.dart';
import '../models/response/issue_response_model.dart';
import '../models/response/public_settings_response_model.dart';



class HomeRepoImpl implements HomeRepo {
  final ApiClient _apiClient;

  HomeRepoImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  NetworkResult<FetchCityResponseModel> fetchCity(){
    return _apiClient.get(endpoint: ApiConstants.home.getCity,
      fromJsonT: (json) => FetchCityResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<FetchSportResponseModel> fetchSport(){
    return _apiClient.get(endpoint: ApiConstants.home.getSport,
      fromJsonT: (json) => FetchSportResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<FetchPitchResponseModel> fetchPitch({
    String? cityId,
    String? sportId,
    double? minPrice,
    double? maxPrice,
    String? bookingAvailability,
    double? userLat,
    double? userLng,
    double? maxDistanceKm,
  }) {
    final query = <String, dynamic>{
      if (cityId != null && cityId.isNotEmpty) 'city': cityId,
      if (sportId != null && sportId.isNotEmpty) 'sport': sportId,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (bookingAvailability != null && bookingAvailability.isNotEmpty)
        'bookingAvailability': bookingAvailability,
      if (userLat != null) 'userLat': userLat,
      if (userLng != null) 'userLng': userLng,
      if (maxDistanceKm != null) 'maxDistanceKm': maxDistanceKm,
    };

    return _apiClient.get(
      endpoint: ApiConstants.home.getPitch,
      queryParameters: query.isEmpty ? null : query,
      fromJsonT: (json) => FetchPitchResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<IssueResponseModel> issue(IssueRequestModel request){
    return _apiClient.post(
      endpoint: ApiConstants.home.issue,
      data: request.toJson(),
      fromJsonT: (json) => IssueResponseModel.fromJson(json),
    );
  }

     @override
     NetworkResult<BookingResponse> createBooking(BookingRequest request){
    return _apiClient.post(
      endpoint: ApiConstants.home.createBooking,
      data: request.toJson(),
      fromJsonT: (json) => BookingResponse.fromJson(json),
    );
  }

  @override
  NetworkResult<BookingResponse> reserveBooking(ReserveBookingRequestModel request) {
    return _apiClient.post(
      endpoint: ApiConstants.home.reserveBooking,
      data: request.toJson(),
      fromJsonT: (json) => BookingResponse.fromJson(json),
    );
  }

  @override
  NetworkResult<BookingResponse> confirmReservedBooking(String reservationId) {
    return _apiClient.post(
      endpoint: ApiConstants.home.confirmReservedBooking(reservationId),
      data: const {},
      fromJsonT: (json) => BookingResponse.fromJson(json),
    );
  }

  @override
  NetworkResult<AvailabilityResponseModel> getAvailability({
    required String pitchId,
    required String date,
  }) {
    return _apiClient.get(
      endpoint: ApiConstants.home.availability,
      queryParameters: {'pitchId': pitchId, 'date': date},
      fromJsonT: (json) => AvailabilityResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<PublicSettingsResponseModel> getPublicSettings() {
    return _apiClient.get(
      endpoint: ApiConstants.home.publicSettings,
      fromJsonT: (json) => PublicSettingsResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

}
