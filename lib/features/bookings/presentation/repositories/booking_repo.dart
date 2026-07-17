import 'package:flutter_justplay/features/bookings/presentation/models/response/get_all_booking_response_model.dart';
import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';

import '../../../../core/network/network_result.dart';



abstract class BookingRepo {
  NetworkResult<GetAllBookingResponseModel> fetchBooking();
  NetworkResult<void> deleteBooking(String bookingId);
}
