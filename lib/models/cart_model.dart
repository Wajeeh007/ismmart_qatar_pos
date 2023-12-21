import 'order.dart';

class CartModel{

  String? name;
  double? price;
  // double? productTax;
  // double? priceWithoutTax;
  int? quantity;
  String? variantTitle;
  int? variantId;
  int? productId;
  String? imageSrc;
  String? sku;
  int? lineItemId;
  int? inventoryItemId;
  int? quantityInStock;
  int? harmonizedSystemCode;
  List<TaxLines>? taxLines;
  List<Properties>? properties;

  CartModel({
    this.name,
    this.price,
    this.variantTitle,
    this.quantity,
    this.lineItemId,
    // this.productTax,
    this.imageSrc,
    this.productId,
    this.variantId,
    this.sku,
    // this.priceWithoutTax,
    this.inventoryItemId,
    this.quantityInStock,
    this.harmonizedSystemCode,
    this.taxLines,
    this.properties,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    variantTitle = json['variant_title'];
    variantId = json['variant_id'];
    productId = json['product_id'];
    sku = json['sku'];
    lineItemId = json['line_item_id'];
    // priceWithoutTax = json['price_without_tax'];
    inventoryItemId = json['inventory_item_id'];
    quantityInStock = json['quantityInStock'];
    harmonizedSystemCode = json['harmonized_system_code'];
    if (json['tax_lines'] != null) {
      taxLines = <TaxLines>[];
      json['tax_lines'].forEach((v) { taxLines!.add(TaxLines.fromJson(v)); });
    }
    if (json['properties'] != null) {
      properties = <Properties>[];
      json['properties'].forEach((v) { properties!.add(Properties.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    // data['line_item_id'] = lineItemId;
    data['variant_title'] = variantTitle;
    data['variant_id'] = variantId;
    data['product_id'] = productId;
    data['sku'] = sku;
    data['inventory_item_id'] = inventoryItemId;
    data['quantityInStock'] = quantityInStock;
    data['harmonized_system_code'] = harmonizedSystemCode;
    // data['price_without_tax'] = priceWithoutTax;
    if (taxLines != null) {
      data['tax_lines'] = taxLines!.map((v) => v.toJson()).toList();
    }
    if (properties != null) {
    data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}