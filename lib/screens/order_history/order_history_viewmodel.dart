import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/global_variables.dart';
import '../../models/order.dart';
import '../../models/orders_model.dart';
import '../order_history_detail/order_history_detail_view.dart';

class OrderHistoryViewModel extends GetxController {
  RxList<Orders> ordersList = <Orders>[].obs;
  ScrollController scrollController = ScrollController();
  RxList<String> statusList = <String>[].obs;
  RxInt sinceOrderId = 0.obs;
  RxBool loadMore = false.obs;
  RxInt page = 0.obs;
  RxBool ordersListCheck = false.obs;

  @override
  void onReady() {
    scrollController.addListener(() {
      fetchOrders();
    });
    fetchOrders();
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    //  locationId.value = GetStorage().read('location_id');
    super.onInit();
  }

  // Method to fetch orders from a data source (e.g., API or database).
  Future<void> fetchOrders() async {
    if (page.value == 0 ? true : scrollController.hasClients &&
        scrollController.position.maxScrollExtent ==
            scrollController.offset) {
      loadMore(true);

      page.value++;

      ApiBaseHelper()
          .getMethodFrmCustomApi(
          url: "pos/orders?sort=order[created_at][-1]&page=${page.value}&fields[name]=1&fields[financial_status]=1&fields[id]=1&fields[customer][first_name]=1&fields[customer][last_name]&=1fields[fulfillments][location_id]=1&fields[created_at]=1&fields[current_total_price]=1&fields[total_price]=1&location=${GlobalVariables.locationId.value}&limit=10")
          .then((parsedJson) {
        loadMore(false);
        final data = parsedJson['data']['items'] as List;
        if (data.isNotEmpty) {
          ordersList.addAll(data.map((e) => Orders.fromJson(e)));
          ordersList.refresh();
        } else {
          scrollController.dispose();
          GlobalVariables.showLoader.value = false;
          ordersListCheck.value = true;
          // loadMore(false);
        }
      });
    }
  }

  //Order Details
  Order orderDetails = Order();
  Future<void> orderDetail(int orderId) async {
    await ApiBaseHelper()
        .getMethod(
            url:
                'orders/${orderId}.json?fields=order_number,created_at,customer,fulfillments,current_subtotal_price,total_price,total_discounts,phone,current_total_price,current_total_tax,refunds,phone')
        .then((parsedJson) {
      if (parsedJson['order'] != null) {
        orderDetails = Order.fromJson(parsedJson['order']);

        Get.to(() => OrderDetailScreen(),
            arguments: {'orderDetails': orderDetails});
      }
    });
  }

  @override
  void onClose() {
    GlobalVariables.showLoader.value = false;

    ordersList.clear();
    statusList.clear();

    super.onClose();
  }
}
