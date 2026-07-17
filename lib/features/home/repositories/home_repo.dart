import 'package:flutter_justplay/features/home/models/request/booking_request_model.dart';
import 'package:flutter_justplay/features/home/models/request/issue_request_model.dart';
import 'package:flutter_justplay/features/home/models/response/booking%20_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_city_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/fetch_sport_response_model.dart';
import 'package:flutter_justplay/features/home/models/response/issue_response_model.dart';
import '../../../core/network/network_result.dart';
import '../models/request/reserve_booking_request_model.dart';
import '../models/response/availability_response_model.dart';
import '../models/response/fetch_pitch_response_model.dart';
import '../models/response/public_settings_response_model.dart';


abstract class HomeRepo {
  NetworkResult<FetchCityResponseModel> fetchCity();
  NetworkResult<FetchSportResponseModel> fetchSport();
  NetworkResult<FetchPitchResponseModel> fetchPitch({
    String? cityId,
    String? sportId,
    double? minPrice,
    double? maxPrice,
    String? bookingAvailability,
    double? userLat,
    double? userLng,
    double? maxDistanceKm,
  });

  NetworkResult<IssueResponseModel> issue(IssueRequestModel request);
  NetworkResult<BookingResponse> createBooking(BookingRequest request);
  NetworkResult<BookingResponse> reserveBooking(ReserveBookingRequestModel request);
  NetworkResult<BookingResponse> confirmReservedBooking(String reservationId);
  NetworkResult<AvailabilityResponseModel> getAvailability({
    required String pitchId,
    required String date,
  });
  NetworkResult<PublicSettingsResponseModel> getPublicSettings();
}
