import 'dart:math';

class DummyData {
  static final Random _random = Random();

  static int totalSales = 1500;
  static double revenue = 125000.75;
  static int totalCustomers = 320;

  // Generate random transaction data dynamically
  static List<Map<String, dynamic>> getTransactions() {
    return List.generate(10, (index) {
      return {
        "customer": "Customer ${index + 1}",
        "amount": (50 + _random.nextInt(100)).toDouble(),
        "status": _random.nextBool() ? "Completed" : "Pending",
      };
    });
  }

  // Generate dynamic sales chart data
  static List<SalesData> getSalesChartData() {
    return [
      SalesData('Mon', _random.nextInt(1000).toDouble()),
      SalesData('Tue', _random.nextInt(1000).toDouble()),
      SalesData('Wed', _random.nextInt(1000).toDouble()),
      SalesData('Thu', _random.nextInt(1000).toDouble()),
      SalesData('Fri', _random.nextInt(1000).toDouble()),
      SalesData('Sat', _random.nextInt(1000).toDouble()),
      SalesData('Sun', _random.nextInt(1000).toDouble()),
    ];
  }

  // Simulate changes in total sales, revenue, and customers
  static void updateDummyData() {
    totalSales += _random.nextInt(10); // Increase sales by 0-10
    revenue =
        double.parse((revenue + _random.nextDouble() * 100).toStringAsFixed(2));
    totalCustomers += _random.nextInt(5); // Increase customers
  }
}

class SalesData {
  final String day;
  final double sales;
  SalesData(this.day, this.sales);
}
