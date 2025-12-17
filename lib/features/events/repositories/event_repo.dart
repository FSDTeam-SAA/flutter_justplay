import 'package:flutter_justplay/features/events/models/response/get_event_list_response_model.dart';
import '../../../core/network/network_result.dart';



abstract class EventRepo {
  NetworkResult<GetEventListResponseModel> fetchEvent();
}
