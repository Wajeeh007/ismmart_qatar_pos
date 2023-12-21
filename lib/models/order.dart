class Order {
  String? createdAt;
  String? currentSubtotalPrice;
  int? orderNumber;
  String? phone;
  String? totalDiscounts;
  String? totalPrice;
  String? totalTax;
  Customer? customer;
  List<Refunds>? refunds;
  List<Fulfillments>? fulfillments;
  // List<LineItems>? lineItems;

  Order({
    this.createdAt,
    this.currentSubtotalPrice,
    this.orderNumber,
    this.phone,
    this.totalDiscounts,
    this.totalPrice,
    this.totalTax,
    this.customer,
    this.fulfillments,
    this.refunds,
    // this.lineItems
  });

  Order.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    currentSubtotalPrice = json['current_subtotal_price'];
    orderNumber = json['order_number'];
    phone = json['phone'];
    totalDiscounts = json['total_discounts'];
    totalPrice = json['current_total_price'];
    totalTax = json['current_total_tax'];
    customer =
    json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    if (json['fulfillments'] != null) {
      fulfillments = <Fulfillments>[];
      json['fulfillments'].forEach((v) {
        fulfillments!.add(Fulfillments.fromJson(v));
      });
    }
    if (json['refunds'] != null) {
      refunds = <Refunds>[];
      json['refunds'].forEach((v) {
        refunds!.add(Refunds.fromJson(v));
      });
    }
    // if (json['line_items'] != null) {
    //   lineItems = <LineItems>[];
    //   json['line_items'].forEach((v) { lineItems!.add(LineItems.fromJson(v)); });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['current_subtotal_price'] = currentSubtotalPrice;
    data['order_number'] = orderNumber;
    data['phone'] = phone;
    data['current_total_tax'] = totalTax;
    data['total_discounts'] = totalDiscounts;
    data['current_total_price'] = totalPrice;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (refunds != null) {
      data['refunds'] = refunds!.map((v) => v.toJson()).toList();
    }
    if (fulfillments != null) {
      data['fulfillments'] = fulfillments!.map((v) => v.toJson()).toList();
    }
    // if (lineItems != null) {
    //   data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Customer {
  int? id;
  String? email;
  bool? acceptsMarketing;
  String? createdAt;
  String? updatedAt;
  String? firstName;
  String? lastName;
  String? state;
  String? note;
  bool? verifiedEmail;
  bool? taxExempt;
  String? phone;
  String? tags;
  String? currency;
  String? acceptsMarketingUpdatedAt;

  Customer({
    this.id,
    this.email,
    this.acceptsMarketing,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.state,
    this.note,
    this.verifiedEmail,
    this.taxExempt,
    this.phone,
    this.tags,
    this.currency,
    this.acceptsMarketingUpdatedAt,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    acceptsMarketing = json['accepts_marketing'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    state = json['state'];
    note = json['note'];
    verifiedEmail = json['verified_email'];
    taxExempt = json['tax_exempt'];
    phone = json['phone'];
    tags = json['tags'];
    currency = json['currency'];
    acceptsMarketingUpdatedAt = json['accepts_marketing_updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['accepts_marketing'] = acceptsMarketing;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['state'] = state;
    data['note'] = note;
    data['verified_email'] = verifiedEmail;
    data['tax_exempt'] = taxExempt;
    data['phone'] = phone;
    data['tags'] = tags;
    data['currency'] = currency;
    data['accepts_marketing_updated_at'] = acceptsMarketingUpdatedAt;
    return data;
  }
}

class Fulfillments {
  int? id;
  String? createdAt;
  int? locationId;
  String? name;
  int? orderId;
  String? service;
  String? status;
  String? updatedAt;
  List<LineItems>? lineItems;
  List<Refunds>? refunds;

  Fulfillments(
      {this.id,
        this.createdAt,
        this.locationId,
        this.name,
        this.orderId,
        this.service,
        this.status,
        this.updatedAt,
        this.lineItems,
        this.refunds,
      });

  Fulfillments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    locationId = json['location_id'];
    name = json['name'];
    orderId = json['order_id'];
    service = json['service'];
    updatedAt = json['updated_at'];
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    if (json['refunds'] != null) {
      refunds = <Refunds>[];
      json['refunds'].forEach((v) { refunds!.add(Refunds.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['location_id'] = locationId;
    data['name'] = name;
    data['order_id'] = orderId;
    data['updated_at'] = updatedAt;
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    if (refunds != null) {
      data['refunds'] = refunds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Refunds {
  int? id;
  String? createdAt;
  int? orderId;
  List<RefundLineItems>? refundLineItems;

  Refunds({
    this.id,
    this.createdAt,
    this.orderId,
    this.refundLineItems,
  });

  Refunds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    orderId = json['order_id'];
    if (json['refund_line_items'] != null) {
      refundLineItems = <RefundLineItems>[];
      json['refund_line_items'].forEach((v) { refundLineItems!.add(RefundLineItems.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['order_id'] = orderId;
    if (refundLineItems != null) {
      data['refund_line_items'] = refundLineItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RefundLineItems {
  int? id;
  int? lineItemId;
  int? locationId;
  int? quantity;
  double? subTotal;
  double? totalTax;

  RefundLineItems({this.locationId, this.id, this.quantity, this.totalTax, this.subTotal, this.lineItemId});

  RefundLineItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lineItemId = json['line_item_id'];
    locationId = json['location_id'];
    quantity = json['quantity'];
    subTotal = json['subtotal'];
    totalTax = json['total_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['line_item_id'] = lineItemId;
    data['location_id'] = locationId;
    data['quantity'] = quantity;
    data['subtotal'] = subTotal;
    data['total_tax'] = totalTax;
    return data;
  }
}

class LineItems {
  int? id;
  String? adminGraphqlApiId;
  int? fulfillableQuantity;
  String? fulfillmentService;
  String? fulfillmentStatus;
  bool? giftCard;
  int? grams;
  String? name;
  String? price;
  PriceSet? priceSet;
  bool? productExists;
  int? productId;
  int? quantity;
  bool? requiresShipping;
  String? sku;
  bool? taxable;
  String? title;
  String? totalDiscount;
  int? variantId;
  String? variantTitle;
  String? vendor;
  List<TaxLines>? taxLines;
  List<Properties>? properties;

  LineItems({
    this.id,
    this.giftCard,
    this.grams,
    this.name,
    this.price,
    this.priceSet,
    this.productExists,
    this.productId,
    this.quantity,
    this.requiresShipping,
    this.sku,
    this.taxable,
    this.title,
    this.totalDiscount,
    this.variantId,
    this.variantTitle,
    this.vendor,
    this.taxLines,
    this.properties
  });

  LineItems.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    grams = json['grams'];
    name = json['name'];
    price = json['price'];
    priceSet =
    json['price_set'] != null ? PriceSet.fromJson(json['price_set']) : null;
    productExists = json['product_exists'];
    productId = json['product_id'];
    quantity = json['quantity'];
    requiresShipping = json['requires_shipping'];
    sku = json['sku'];
    taxable = json['taxable'];
    title = json['title'];
    totalDiscount = json['total_discount'];
    variantId = json['variant_id'];
    variantTitle = json['variant_title'];
    vendor = json['vendor'];
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
    data['id'] = id;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    data['fulfillable_quantity'] = fulfillableQuantity;
    data['fulfillment_service'] = fulfillmentService;
    data['fulfillment_status'] = fulfillmentStatus;
    data['gift_card'] = giftCard;
    data['grams'] = grams;
    data['name'] = name;
    data['price'] = price;
    if (priceSet != null) {
      data['price_set'] = priceSet!.toJson();
    }
    data['product_exists'] = productExists;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['requires_shipping'] = requiresShipping;
    data['sku'] = sku;
    data['taxable'] = taxable;
    data['title'] = title;
    data['total_discount'] = totalDiscount;
    data['variant_id'] = variantId;
    data['variant_title'] = variantTitle;
    data['vendor'] = vendor;
    if (taxLines != null) {
      data['tax_lines'] = taxLines!.map((v) => v.toJson()).toList();
    }
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties{

  String? name;
  int? value;

  Properties({this.name, this.value});

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }
}

class TaxLines {

  String? title;
  String? price;
  double? rate;

  TaxLines({
    this.title,
    this.price,
    this.rate
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['rate'] = rate;
    return data;
  }

  TaxLines.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    rate = json['rate'];
  }
}

class ShopMoney {
  String? amount;
  String? currencyCode;

  ShopMoney({this.amount, this.currencyCode});

  ShopMoney.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency_code'] = currencyCode;
    return data;
  }
}

class PriceSet {
  ShopMoney? shopMoney;
  ShopMoney? presentmentMoney;

  PriceSet({this.shopMoney, this.presentmentMoney});

  PriceSet.fromJson(Map<String, dynamic> json) {
    shopMoney = json['shop_money'] != null
        ? ShopMoney.fromJson(json['shop_money'])
        : null;
    presentmentMoney = json['presentment_money'] != null
        ? ShopMoney.fromJson(json['presentment_money'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shopMoney != null) {
      data['shop_money'] = shopMoney!.toJson();
    }
    if (presentmentMoney != null) {
      data['presentment_money'] = presentmentMoney!.toJson();
    }
    return data;
  }
}