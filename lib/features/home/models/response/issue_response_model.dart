class IssueResponseModel {
  final Issue issue;

  IssueResponseModel({required this.issue});

  factory IssueResponseModel.fromJson(Map<String, dynamic> json) {
    return IssueResponseModel(
      issue: Issue.fromJson(json['issue']),
    );
  }
}

class Issue {
  final String id;
  final String user;
  final String? booking;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;

  Issue({
    required this.id,
    required this.user,
    this.booking,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['_id'],
      user: json['user'],
      booking: json['booking'] as String?,
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
