class FetchSportResponseModel {
  final List<Sport> sports;

  FetchSportResponseModel({required this.sports});

  factory FetchSportResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchSportResponseModel(
      sports: (json['sports'] as List)
          .map((sportJson) => Sport.fromJson(sportJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sports': sports.map((sport) => sport.toJson()).toList(),
    };
  }
}

class Sport {
  final String id;
  final String name;
  final SportImage image;
  final String createdAt;
  final String updatedAt;

  Sport({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'],
      name: json['name'],
      image: SportImage.fromJson(json['image']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SportImage {
  final String url;
  final String publicId;

  SportImage({required this.url, required this.publicId});

  factory SportImage.fromJson(Map<String, dynamic> json) {
    return SportImage(
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
