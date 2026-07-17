class IssueRequestModel {
  final String title;
  final String description;
  final String? bookingId;

  IssueRequestModel({
    required this.title,
    required this.description,
    this.bookingId,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      if (bookingId != null && bookingId!.isNotEmpty) "bookingId": bookingId,
    };
  }
}
