// class Product {
//   int? id;
//   String? title;
//   String? bodyHtml;
//   String? vendor;
//   String? productType;
//   String? createdAt;
//   String? handle;
//   String? updatedAt;
//   String? publishedAt;
//   String? templateSuffix;
//   String? publishedScope;
//   String? tags;
//   String? status;
//   String? adminGraphqlApiId;
//   List<Variants>? variants;
//   List<Options>? options;
//   List<Images>? images;
//   Image? image;
//
//   Product(
//       {this.id,
//         this.title,
//         this.bodyHtml,
//         this.vendor,
//         this.productType,
//         this.createdAt,
//         this.handle,
//         this.updatedAt,
//         this.publishedAt,
//         this.templateSuffix,
//         this.publishedScope,
//         this.tags,
//         this.status,
//         this.adminGraphqlApiId,
//         this.variants,
//         this.options,
//         this.images,
//         this.image});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     // print("$json\n");
//     id = json['id'];
//     title = json['title'];
//     bodyHtml = json['body_html'];
//     vendor = json['vendor'];
//     productType = json['product_type'];
//     createdAt = json['created_at'];
//     handle = json['handle'];
//     updatedAt = json['updated_at'];
//     publishedAt = json['published_at'];
//     templateSuffix = json['template_suffix'];
//     publishedScope = json['published_scope'];
//     tags = json['tags'];
//     status = json['status'];
//     adminGraphqlApiId = json['admin_graphql_api_id'];
//     if (json['variants'] != null) {
//       variants = <Variants>[];
//       json['variants'].forEach((v) {
//         variants!.add(Variants.fromJson(v));
//       });
//     }
//     if (json['options'] != null) {
//       options = <Options>[];
//       json['options'].forEach((v) {
//         options!.add(Options.fromJson(v));
//       });
//     }
//     if (json['images'] != null) {
//       images = <Images>[];
//       json['images'].forEach((v) {
//         images!.add(Images.fromJson(v));
//       });
//     }
//     image = json['image'] != null ? Image.fromJson(json['image']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['body_html'] = bodyHtml;
//     data['vendor'] = vendor;
//     data['product_type'] = productType;
//     data['created_at'] = createdAt;
//     data['handle'] = handle;
//     data['updated_at'] = updatedAt;
//     data['published_at'] = publishedAt;
//     data['template_suffix'] = templateSuffix;
//     data['published_scope'] = publishedScope;
//     data['tags'] = tags;
//     data['status'] = status;
//     data['admin_graphql_api_id'] = adminGraphqlApiId;
//     if (variants != null) {
//       data['variants'] = variants!.map((v) => v.toJson()).toList();
//     }
//     if (options != null) {
//       data['options'] = options!.map((v) => v.toJson()).toList();
//     }
//     if (images != null) {
//       data['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     if (image != null) {
//       data['image'] = image!.toJson();
//     }
//     return data;
//   }
// }
//
// class Variants {
//   int? id;
//   int? productId;
//   String? title;
//   String? price;
//   String? sku;
//   int? position;
//   String? inventoryPolicy;
//   String? compareAtPrice;
//   String? fulfillmentService;
//   String? inventoryManagement;
//   String? option1;
//   String? option2;
//   String? option3;
//   String? createdAt;
//   String? updatedAt;
//   bool? taxable;
//   String? barcode;
//   String? harmonizedSystemCode;
//   int? grams;
//   int? imageId;
//   double? weight;
//   String? weightUnit;
//   int? inventoryItemId;
//   int? inventoryQuantity;
//   int? oldInventoryQuantity;
//   bool? requiresShipping;
//   String? adminGraphqlApiId;
//
//   Variants(
//       {this.id,
//         this.productId,
//         this.title,
//         this.price,
//         this.sku,
//         this.position,
//         this.inventoryPolicy,
//         this.compareAtPrice,
//         this.harmonizedSystemCode,
//         this.fulfillmentService,
//         this.inventoryManagement,
//         this.option1,
//         this.option2,
//         this.option3,
//         this.createdAt,
//         this.updatedAt,
//         this.taxable,
//         this.barcode,
//         this.grams,
//         this.imageId,
//         this.weight,
//         this.weightUnit,
//         this.inventoryItemId,
//         this.inventoryQuantity,
//         this.oldInventoryQuantity,
//         this.requiresShipping,
//         this.adminGraphqlApiId});
//
//   Variants.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     title = json['title'];
//     price = json['price'];
//     sku = json['sku'];
//     position = json['position'];
//     inventoryPolicy = json['inventory_policy'];
//     compareAtPrice = json['compare_at_price'];
//     fulfillmentService = json['fulfillment_service'];
//     inventoryManagement = json['inventory_management'];
//     option1 = json['option1'];
//     option2 = json['option2'];
//     option3 = json['option3'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     taxable = json['taxable'];
//     harmonizedSystemCode = json['harmonizedSystemCode'];
//     barcode = json['barcode'];
//     grams = json['grams'];
//     imageId = json['image_id'];
//     weight = json['weight'];
//     weightUnit = json['weight_unit'];
//     inventoryItemId = json['inventory_item_id'];
//     inventoryQuantity = json['inventory_quantity'];
//     oldInventoryQuantity = json['old_inventory_quantity'];
//     requiresShipping = json['requires_shipping'];
//     adminGraphqlApiId = json['admin_graphql_api_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['title'] = title;
//     data['price'] = price;
//     data['sku'] = sku;
//     data['position'] = position;
//     data['inventory_policy'] = inventoryPolicy;
//     data['compare_at_price'] = compareAtPrice;
//     data['fulfillment_service'] = fulfillmentService;
//     data['inventory_management'] = inventoryManagement;
//     data['option1'] = option1;
//     data['option2'] = option2;
//     data['option3'] = option3;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['taxable'] = taxable;
//     data['harmonizedSystemCode'] = harmonizedSystemCode;
//     data['barcode'] = barcode;
//     data['grams'] = grams;
//     data['image_id'] = imageId;
//     data['weight'] = weight;
//     data['weight_unit'] = weightUnit;
//     data['inventory_item_id'] = inventoryItemId;
//     data['inventory_quantity'] = inventoryQuantity;
//     data['old_inventory_quantity'] = oldInventoryQuantity;
//     data['requires_shipping'] = requiresShipping;
//     data['admin_graphql_api_id'] = adminGraphqlApiId;
//     return data;
//   }
// }
//
// class Options {
//   int? id;
//   int? productId;
//   String? name;
//   int? position;
//   List<String>? values;
//
//   Options({this.id, this.productId, this.name, this.position, this.values});
//
//   Options.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     name = json['name'];
//     position = json['position'];
//     values = json['values'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['name'] = name;
//     data['position'] = position;
//     data['values'] = values;
//     return data;
//   }
// }
//
// class Images {
//   String? id;
//   int? productId;
//   int? position;
//   String? createdAt;
//   String? updatedAt;
//   String? alt;
//   int? width;
//   int? height;
//   String? src;
//   List<int>? variantIds;
//   String? adminGraphqlApiId;
//
//   Images(
//       {this.id,
//         this.productId,
//         this.position,
//         this.createdAt,
//         this.updatedAt,
//         this.alt,
//         this.width,
//         this.height,
//         this.src,
//         this.variantIds,
//         this.adminGraphqlApiId});
//
//   Images.fromJson(Map<String, dynamic> json) {
//     print(json['url']);
//     id = json['id'];
//     productId = json['product_id'];
//     position = json['position'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     alt = json['alt'];
//     width = json['width'];
//     height = json['height'];
//     src = json['url'];
//     variantIds = json['variant_ids'] == null ? null : json['variant_ids'].cast<int>();
//     adminGraphqlApiId = json['admin_graphql_api_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['position'] = position;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['alt'] = alt;
//     data['width'] = width;
//     data['height'] = height;
//     data['url'] = src;
//     data['variant_ids'] = variantIds;
//     data['admin_graphql_api_id'] = adminGraphqlApiId;
//     return data;
//   }
// }
//
// class Image {
//   String? id;
//   int? productId;
//   int? position;
//   String? createdAt;
//   String? updatedAt;
//   String? alt;
//   int? width;
//   int? height;
//   String? src;
//   List<int>? variantIds;
//   String? adminGraphqlApiId;
//
//   Image(
//       {this.id,
//         this.productId,
//         this.position,
//         this.createdAt,
//         this.updatedAt,
//         this.alt,
//         this.width,
//         this.height,
//         this.src,
//         this.variantIds,
//         this.adminGraphqlApiId});
//
//   Image.fromJson(Map<String, dynamic> json) {
//     // print(json['node']['url']);
//     id = json['id'];
//     productId = json['product_id'];
//     position = json['position'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     alt = json['alt'];
//     width = json['width'];
//     height = json['height'];
//     src = json['url'];
//     if (json['variant_ids'] != null) {
//       variantIds = <int>[];
//       json['variant_ids'].forEach((v) {
//         variantIds!.add(v);
//       });
//     }
//     adminGraphqlApiId = json['admin_graphql_api_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['position'] = position;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['alt'] = alt;
//     data['width'] = width;
//     data['height'] = height;
//     data['url'] = src;
//     if (variantIds != null) {
//       data['variant_ids'] = variantIds!.map((v) => v.toString()).toList();
//     }
//     data['admin_graphql_api_id'] = adminGraphqlApiId;
//     return data;
//   }
// }

class ProductsData {
  int? page;
  int? limit;
  int? pages;
  int? total;

  ProductsData({this.page, this.limit, this.pages, this.total});

  ProductsData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    pages = json['pages'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['pages'] = pages;
    data['total'] = total;
    return data;
  }
}

class ProductItem {
  String? sId;
  Product? product;
  int? iV;
  String? createdAt;
  String? updatedAt;

  ProductItem({this.sId, this.product, this.iV, this.createdAt, this.updatedAt});

  ProductItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Product {
  int? id;
  String? title;
  // String? bodyHtml;
  String? vendor;
  String? productType;
  // String? createdAt;
  // String? handle;
  // String? updatedAt;
  // Null? publishedAt;
  // String? templateSuffix;
  // String? publishedScope;
  String? tags;
  // String? status;
  String? adminGraphqlApiId;
  List<Variants>? variants;
  List<Options>? options;
  // List<Images>? images;
  Images? image;

  Product(
      {this.id,
        this.title,
        // this.bodyHtml,
        // this.vendor,
        // this.productType,
        // this.tags,
        // this.status,
        // this.adminGraphqlApiId,
        // this.variants,
        // this.options,
        // this.images,
        this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    // bodyHtml = json['body_html'];
    // vendor = json['vendor'];
    // productType = json['product_type'];
    // tags = json['tags'];
    // status = json['status'];
    // adminGraphqlApiId = json['admin_graphql_api_id'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    // if (json['images'] != null) {
    //   images = <Images>[];
    //   json['images'].forEach((v) {
    //     images!.add(Images.fromJson(v));
    //   });
    // }
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    // data['body_html'] = bodyHtml;
    // data['vendor'] = vendor;
    // data['product_type'] = productType;
    // data['tags'] = tags;
    // data['status'] = status;
    // data['admin_graphql_api_id'] = adminGraphqlApiId;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    // if (images != null) {
    //   data['images'] = images!.map((v) => v.toJson()).toList();
    // }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Variants {
  int? id;
  double? priceWithoutTax;
  int? productId;
  String? title;
  double? price;
  String? sku;
  // int? position;
  // String? inventoryPolicy;
  // Null? compareAtPrice;
  // String? fulfillmentService;
  // String? inventoryManagement;
  // String? option1;
  // Null? option2;
  // Null? option3;
  // String? createdAt;
  // String? updatedAt;
  // bool? taxable;
  String? barcode;
  // int? grams;
  // String? imageId;
  // int? weight;
  // String? weightUnit;
  int? inventoryItemId;
  int? inventoryQuantity;
  // int? oldInventoryQuantity;
  // bool? requiresShipping;
  // String? adminGraphqlApiId;

  Variants(
      {this.id,
        this.productId,
        this.title,
        this.price,
        this.sku,
        this.priceWithoutTax,
        // this.position,
        // this.inventoryPolicy,
        // this.compareAtPrice,
        // this.fulfillmentService,
        // this.inventoryManagement,
        // this.option1,
        // this.option2,
        // this.option3,
        // this.createdAt,
        // this.updatedAt,
        // this.taxable,
        this.barcode,
        // this.grams,
        // this.imageId,
        // this.weight,
        // this.weightUnit,
        this.inventoryItemId,
        this.inventoryQuantity,
        // this.oldInventoryQuantity,
        // this.requiresShipping,
        // this.adminGraphqlApiId
      });

  Variants.fromJson(Map<String, dynamic> json) {

    // String priceAsString = (double.parse(json['price']) - (double.parse(json['price']) / 100) * 5).toStringAsFixed(0);

    // print('Variant Price As String: $priceAsString');

    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    price = double.parse(json['price']);
    // priceWithoutTax = double.parse(priceAsString);
    sku = json['sku'];
    // position = json['position'];
    // inventoryPolicy = json['inventory_policy'];
    // compareAtPrice = json['compare_at_price'];
    // fulfillmentService = json['fulfillment_service'];
    // inventoryManagement = json['inventory_management'];
    // option1 = json['option1'];
    // option2 = json['option2'];
    // option3 = json['option3'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // taxable = json['taxable'];
    barcode = json['barcode'];
    // grams = json['grams'];
    // imageId = json['image_id'];
    // print('Image ID');
    // weight = json['weight'];
    // weightUnit = json['weight_unit'];
    inventoryItemId = json['inventory_item_id'];
    inventoryQuantity = json['inventory_quantity'];
    // oldInventoryQuantity = json['old_inventory_quantity'];
    // requiresShipping = json['requires_shipping'];
    // adminGraphqlApiId = json['admin_graphql_api_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['title'] = title;
    data['price'] = price.toString();
    data['sku'] = sku;
    // data['position'] = position;
    // data['inventory_policy'] = inventoryPolicy;
    // data['compare_at_price'] = compareAtPrice;
    // data['fulfillment_service'] = fulfillmentService;
    // data['inventory_management'] = inventoryManagement;
    // data['option1'] = option1;
    // data['option2'] = option2;
    // data['option3'] = option3;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    // data['taxable'] = taxable;
    data['barcode'] = barcode;
    // data['grams'] = grams;
    // data['image_id'] = imageId;
    // data['weight'] = weight;
    // data['weight_unit'] = weightUnit;
    data['inventory_item_id'] = inventoryItemId;
    data['inventory_quantity'] = inventoryQuantity;
    // data['old_inventory_quantity'] = oldInventoryQuantity;
    // data['requires_shipping'] = requiresShipping;
    // data['admin_graphql_api_id'] = adminGraphqlApiId;
    return data;
  }
}

class Options {
  // int? id;
  // int? productId;
  String? name;
  // int? position;
  List<String>? values;

  Options({
    // this.id,
    // this.productId,
    this.name,
    // this.position,
    this.values
  });

  Options.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // productId = json['product_id'];
    name = json['name'];
    // position = json['position'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    // data['product_id'] = productId;
    data['name'] = name;
    // data['position'] = position;
    data['values'] = values;
    return data;
  }
}

class Images {
  // int? id;
  // Null? alt;
  // int? position;
  // int? productId;
  // String? createdAt;
  // String? updatedAt;
  // String? adminGraphqlApiId;
  // int? width;
  // int? height;
  String? src;
  // List<String>? variantIds;

  Images({
    // this.id,
        // this.alt,
        // this.position,
        // this.productId,
        // this.createdAt,
        // this.updatedAt,
        // this.adminGraphqlApiId,
        // this.width,
        // this.height,
        this.src,
        // this.variantIds
      });

  Images.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // alt = json['alt'];
    // position = json['position'];
    // productId = json['product_id'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // adminGraphqlApiId = json['admin_graphql_api_id'];
    // width = json['width'];
    // height = json['height'];
    src = json['src'];
    // if (json['variant_ids'] != null) {
    //   variantIds = <String>[];
    //   json['variant_ids'].forEach((v) {
    //     variantIds!.add(v);
    //   });
    // }
    // print('Variant ID');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    // data['alt'] = alt;
    // data['position'] = position;
    // data['product_id'] = productId;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    // data['admin_graphql_api_id'] = adminGraphqlApiId;
    // data['width'] = width;
    // data['height'] = height;
    data['src'] = src;
    // if (variantIds != null) {
    //   data['variant_ids'] = variantIds!.map((v) => v.toString()).toList();
    // }
    return data;
  }
}