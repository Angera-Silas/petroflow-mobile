import 'package:intl/intl.dart';

class RequestModel {
  final int? id;
  final String employeeNo;
  final String title;
  final String description;
  final DateTime dateRequested;
  final String status;
  late DateTime? dateResolved;
  late String? resolvedBy;

  RequestModel({
    this.id,
    required this.employeeNo,
    required this.title,
    required this.description,
    required this.dateRequested,
    required this.status,
    this.dateResolved,
    this.resolvedBy,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      employeeNo: json['employeeNo'],
      title: json['title'],
      description: json['description'],
      dateRequested: DateTime.parse(json['dateRequested']),
      status: json['status'],
      dateResolved: json['dateResolved'] != null
          ? DateTime.parse(json['dateResolved'])
          : null,
      resolvedBy: json['resolvedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'employeeNo': employeeNo,
      'title': title,
      'description': description,
      'dateRequested': formatter.format(dateRequested),
      'status': status,
      'dateResolved':
          dateResolved != null ? formatter.format(dateResolved!) : null,
      'resolvedBy': resolvedBy,
    };
  }
}
