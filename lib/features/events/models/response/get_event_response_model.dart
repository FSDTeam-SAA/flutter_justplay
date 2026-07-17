class GetEventResponseModel {
  final Event event;

  GetEventResponseModel({required this.event});

  factory GetEventResponseModel.fromJson(Map<String, dynamic> json) {
    return GetEventResponseModel(
      event: Event.fromJson(json['event']),
    );
  }
}

class Event {
  final String id;
  final String name;
  final EventImage image;
  final City city;
  final Sport sport;
  final DateTime date;
  final String time;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.name,
    required this.image,
    required this.city,
    required this.sport,
    required this.date,
    required this.time,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      image: EventImage.fromJson(json['image']),
      city: City.fromJson(json['city']),
      sport: Sport.fromJson(json['sport']),
      date: DateTime.parse(json['date']),
      time: json['time'],
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class EventImage {
  final String url;
  final String publicId;

  EventImage({required this.url, required this.publicId});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      url: json['url'],
      publicId: json['public_id'],
    );
  }
}

class City {
  final String id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Sport {
  final String id;
  final String name;

  Sport({required this.id, required this.name});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'],
      name: json['name'],
    );
  }
}
