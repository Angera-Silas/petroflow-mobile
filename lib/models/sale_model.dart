class SaleModel {
  final int id;
  final int? employeeId;
  final int? facilityId;
  final int? orgId;
  final DateTime timestamp;
  final String product_name;
  final double units_sold;
  final double total_amount_billed;
  final double total_amount_paid;
  final String mode_of_payment;
  late final bool synced;

  SaleModel(
      {required this.id,
      this.orgId,
      this.facilityId,
      this.employeeId,
      required this.timestamp,
      required this.product_name,
      required this.units_sold,
      required this.mode_of_payment,
      required this.total_amount_billed,
      required this.total_amount_paid,
      this.synced = false});

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      orgId: json['orgId'],
      facilityId: json['facilityId'],
      employeeId: json['employeeId'],
      timestamp: DateTime.parse(json['timestamp']),
      product_name: json['product_name'],
      units_sold: json['units_sold'],
      mode_of_payment: json['mode_of_payment'],
      total_amount_billed: json['total_amount_billed'],
      total_amount_paid: json['total_amount_paid'],
      synced: json['synced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orgId': orgId,
      'facilityId': facilityId,
      'employeeId': employeeId,
      'timestamp': timestamp.toIso8601String(),
      'product_name': product_name,
      'units_sold': units_sold,
      'mode_of_payment': mode_of_payment,
      'total_amount_billed': total_amount_billed,
      'total_amount_paid': total_amount_paid,
      'synced': synced,
    };
  }
}
