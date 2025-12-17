class IssueRequestModel {
  final String title;
  final String description;
  final String bookingId;

  IssueRequestModel({
    required this.title,
    required this.description,
    required this.bookingId,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "bookingId": bookingId,
    };
  }
}
