class FetchCityResponseModel {
  final List<City> cities;

  FetchCityResponseModel({required this.cities});

  factory FetchCityResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchCityResponseModel(
      cities: (json['cities'] as List)
          .map((cityJson) => City.fromJson(cityJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cities': cities.map((city) => city.toJson()).toList(),
    };
  }
}

class City {
  final String id;
  final String name;
  final String user;
  final CityImage image;
  final String createdAt;
  final String updatedAt;

  City({
    required this.id,
    required this.name,
    required this.user,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'],
      name: json['name'],
      user: json['user'],
      image: CityImage.fromJson(json['image']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'user': user,
      'image': image.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CityImage {
  final String url;
  final String publicId;

  CityImage({required this.url, required this.publicId});

  factory CityImage.fromJson(Map<String, dynamic> json) {
    return CityImage(
      url: json['url'],
      publicId: json['public_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'public_id': publicId,
    };
  }
}
