import 'package:intl/intl.dart';

class IncidentModel {
  final int? id;
  final String employeeNo;
  final String title;
  final String reciever;
  final String description;
  final DateTime dateReported;
  final String status;
  late DateTime? dateResolved;
  late String? resolution;
  late String? resolutionBy;
  late String? organizationName;
  late String? facilityName;
  late String? employeeName;

  IncidentModel({
    this.id,
    required this.employeeNo,
    required this.title,
    required this.reciever,
    required this.description,
    required this.dateReported,
    required this.status,
    this.dateResolved,
    this.resolution,
    this.resolutionBy,
    this.organizationName,
    this.facilityName,
    this.employeeName,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'],
      employeeNo: json['employeeNo'],
      title: json['title'],
      reciever: json['reciever'],
      description: json['description'],
      dateReported: DateTime.parse(json['dateReported']),
      status: json['status'],
      dateResolved: json['dateResolved'] != null
          ? DateTime.parse(json['dateResolved'])
          : null,
      resolution: json['resolution'],
      resolutionBy: json['resolutionBy'],
      organizationName: json['organizationName'],
      facilityName: json['facilityName'],
      employeeName: json['employeeName'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'employeeNo': employeeNo,
      'title': title,
      'reciever': reciever,
      'description': description,
      'dateReported': formatter.format(dateReported),
      'status': status,
      'dateResolved':
          dateResolved != null ? formatter.format(dateResolved!) : null,
      'resolution': resolution,
      'resolutionBy': resolutionBy,
      'organizationName': organizationName,
      'facilityName': facilityName,
      'employeeName': employeeName,
    };
  }
}
