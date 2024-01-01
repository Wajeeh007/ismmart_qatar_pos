class Urls {
  static String baseUrl = liveBaseUrl;
  static String token = liveToken;

  //test-----------
  static String testBaseUrl =
      'https://wehire007.myshopify.com/admin/api/2023-10/';
  static String testToken = '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';

  //live----------
  static String liveBaseUrl =
      'https://d1f5bf-2.myshopify.com/admin/api/2023-10/';
  static String liveToken = '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';

  static String liveCustomBaseUrl = 'https://shopify.ismmart.com/api/';

//end point--------
  static String getAllProducts = 'products.json';
  static String getProductsByLimit = 'products.json?limit=250&since_id=';
  static String getOrders =
      'orders.json?status=any&current_total_price,created_at,id,name,variant_title,first_name,status,refunds&limit=25&since_id=,location_id';
  static String getOrdersCount = 'orders/count.json?status=any';
  static String getLocationsFrmCustomApi =
      'pos/locations?sort=location[created_at][-1]&page=';
  static String getOrdersForShiftReport = "pos/orders?sort=order[created_at][-1]&fields[fulfillments][id]=1&fields[fulfillments][created_at]=1&fields[created_at]=1&fields[current_total_price]=1&fields[total_price]=1&limit=0&location=";
  static String getOrdersForSalesSummary = "pos/orders?sort=order[created_at][-1]&fields[note]=1&fields[current_total_price]=1&fields[total_price]=1&fields[fulfillments][location_id]=1&fields[created_at]=1fields[refunds][transactions][amount]=1&limit=0&location=";
  static String getProductsFrmCustomApi = 'pos/products?sort=product[created_at][1]&location=92841312553&fields[title]=1&fields[variants][fulfillment_service]=1&fields[variants][barcode]&fields[id]=1&fields[variants][sku]=1&fields[variants][price]=1&fields[variants][inventory_item_id]=1&fields[variants][inventory_quantity]=1&fields[options][name]=1&fields[options][values]=1&fields[images][src]=1&fields[variants][product_id]=1&fields[variants][id]=1&limit=0';
  static String getLocations = 'locations.json';
  static String getInventoryItemById = 'inventory_items.json?ids=';
  static String getInventoryLevels =
      'inventory_levels.json?limit=250&location_ids=';
  static String createOrder = 'orders.json';
  static String refundOrder = 'orders/5601286291730/refunds.json';
  static String refundDetail = 'orders/5606826082578/refunds.json';
  static String getProductsCount = 'products/count.json';

  // custom Api endpoints------
  static String login = "auth/login";
  static String profile = "auth/profile";
}
//orders.json?status=any&current_total_price
