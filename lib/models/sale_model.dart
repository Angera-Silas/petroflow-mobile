import 'package:intl/intl.dart';

class SaleModel {
  final int? id;
  final DateTime dateTime;
  final int productId;
  final String employeeNo;
  final int sellPointId;
  final int shiftId;
  final double unitsSold;
  final double amountBilled;
  final double discount;
  final double amountPaid;
  final String paymentMethod;
  final String paymentStatus;
  final double? balance;
  final String status;
  late bool synced;
  final String? productName;
  final String? shiftType;
  final String? sellingPoints;

  SaleModel({
    this.id,
    required this.dateTime,
    required this.productId,
    required this.employeeNo,
    required this.sellPointId,
    required this.shiftId,
    required this.unitsSold,
    required this.amountBilled,
    required this.discount,
    required this.amountPaid,
    required this.paymentMethod,
    required this.paymentStatus,
    this.balance,
    required this.status,
    this.synced = false,
    this.productName,
    this.shiftType,
    this.sellingPoints,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      dateTime: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      productId: json['productId'] ?? 0,
      employeeNo: json['employeeNo'] ?? '',
      sellPointId: json['sellPointId'] ?? 0,
      shiftId: json['shiftId'] ?? 0,
      unitsSold: double.tryParse(json['unitsSold'].toString()) ?? 0.0,
      amountBilled: double.tryParse(json['amountBilled'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      amountPaid: double.tryParse(json['amountPaid'].toString()) ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? 'Unknown',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      balance: json['balance'] != null
          ? double.tryParse(json['balance'].toString())
          : null,
      status: json['status'] ?? 'Pending',
      synced: json['synced'] ?? true,
      productName: json['productName'],
      shiftType: json['shiftType'],
      sellingPoints: json['sellingPoints'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'dateTime': formatter.format(dateTime),
      'productId': productId,
      'employeeNo': employeeNo,
      'sellPointId': sellPointId,
      'shiftId': shiftId,
      'unitsSold': unitsSold,
      'amountBilled': amountBilled,
      'discount': discount,
      'amountPaid': amountPaid,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'balance': balance,
      'status': status,
      'synced': synced,
      'productName': productName,
      'shiftType': shiftType,
      'sellingPoints': sellingPoints,
    };
  }
}
