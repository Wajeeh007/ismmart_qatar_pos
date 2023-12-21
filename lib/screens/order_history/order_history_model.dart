class OrderHistoryModel {
  final String orderName;
  final String orderId;
  final String orderDate;
  final double totalAmount;

  OrderHistoryModel({
    required this.orderName,
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
  });
}
