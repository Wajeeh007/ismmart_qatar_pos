import '../../models/order.dart';

class ShiftReportResponse {
  final List<Order>? orders;

  ShiftReportResponse({
    this.orders,
  });

  factory ShiftReportResponse.fromJson(Map<String, dynamic> json) => ShiftReportResponse(
    orders: json["orders"] == null ? [] : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": orders == null ? [] : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };

}

class ShiftReportOrder {
  final int? id;
  final DateTime? createdAt;
  final String? currency;
  final String? currentTotalDiscounts;
  final String? currentTotalTax;
  final String? financialStatus;
  final String? fulfillmentStatus;
  final String? currentTotalPrice;
  final String? totalDiscounts;
  final String? totalPrice;
  final String? totalTax;
  final List<Fulfillments>? fulfillments;
  final List<Refunds>? refunds;

  ShiftReportOrder({
    this.id,
    this.createdAt,
    this.currency,
    this.currentTotalDiscounts,
    this.currentTotalTax,
    this.financialStatus,
    this.fulfillmentStatus,
    this.currentTotalPrice,
    this.totalDiscounts,
    this.totalPrice,
    this.totalTax,
    this.fulfillments,
    this.refunds
  });

  factory ShiftReportOrder.fromJson(Map<String, dynamic> json) => ShiftReportOrder(
    id: json['order']["id"],
    createdAt: json['order']["created_at"] == null ? null : DateTime.parse(json['order']["created_at"]),
    currency: json['order']["currency"],
    currentTotalDiscounts: json['order']["current_total_discounts"],
    currentTotalTax: json['order']["current_total_tax"],
    financialStatus: json['order']["financial_status"],
    fulfillmentStatus: json['order']["fulfillment_status"],
    currentTotalPrice: json['order']["current_total_price"],
    totalDiscounts: json['order']["total_discounts"],
    totalPrice: json['order']["current_total_price"],
    totalTax: json['order']["total_tax"],
    fulfillments: json['order']["fulfillments"] == null ? [] : List<Fulfillments>.from(json['order']["fulfillments"]!.map((x) => Fulfillments.fromJson(x))),
    refunds: json['order']["refunds"] == null ? [] : List<Refunds>.from(json['order']["refunds"]!.map((x) => Refunds.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "currency": currency,
    "current_total_discounts": currentTotalDiscounts,
    "current_total_tax": currentTotalTax,
    "financial_status": financialStatus,
    "fulfillment_status": fulfillmentStatus,
    "subtotal_price": currentTotalPrice,
    "total_discounts": totalDiscounts,
    "total_price": totalPrice,
    "total_tax": totalTax,
  };

}


