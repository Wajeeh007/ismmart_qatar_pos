
import 'order.dart';

class Orders {
  int? id;
  String? createdAt;
  String? name;
  String? note;
  String? currentTotalPrice;
  String? totalPrice;
  String? status;
  List<Fulfillments>? fulfillments;
  List<Refunds>? refunds;
  String? financialStatus;

  Orders({this.id, this.note, this.createdAt, this.name, this.totalPrice, this.status, this.fulfillments, this.refunds, this.financialStatus, this.currentTotalPrice});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['order']['id'];
    createdAt = json['order']['created_at'];
    name = json['order']['name'];
    note = json['order']['note'];
    currentTotalPrice = json['order']['current_total_price'];
    totalPrice = json['order']['total_price'];
    financialStatus = json['order']['financial_status'];
    if (json['order']['fulfillments'] != null) {
      fulfillments = <Fulfillments>[];
      json['order']['fulfillments'].forEach((v) {
        fulfillments!.add(Fulfillments.fromJson(v));
      });
    }
    if (json['order']['refunds'] != null) {
      refunds = <Refunds>[];
      json['order']['refunds'].forEach((v) {
        refunds!.add(Refunds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['current_total_price'] = currentTotalPrice;
    data['financial_status'] = financialStatus;
    data['total_price'] = totalPrice;
    if (fulfillments != null) {
      data['fulfillments'] = fulfillments!.map((v) => v.toJson()).toList();
    }
    if (refunds != null) {
      data['refunds'] = refunds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}