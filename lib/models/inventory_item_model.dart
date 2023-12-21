class InventoryLevels {
  int? inventoryItemId;
  int? locationId;
  int? available;
  String? updatedAt;
  String? adminGraphqlApiId;

  InventoryLevels(
      {this.inventoryItemId,
        this.locationId,
        this.available,
        this.updatedAt,
        this.adminGraphqlApiId});

  InventoryLevels.fromJson(Map<String, dynamic> json) {
    inventoryItemId = json['inventory_item_id'];
    locationId = json['location_id'];
    available = json['available'];
    updatedAt = json['updated_at'];
    adminGraphqlApiId = "gid://shopify/InventoryItem/${json['inventory_item_id']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inventory_item_id'] = inventoryItemId;
    data['location_id'] = locationId;
    data['available'] = available;
    data['updated_at'] = updatedAt;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    return data;
  }
}