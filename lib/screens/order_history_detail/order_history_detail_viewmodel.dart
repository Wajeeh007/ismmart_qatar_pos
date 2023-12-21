import 'package:get/get.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/constants.dart';
import '../../helper/global_variables.dart';
import '../../models/cart_model.dart';
import '../../models/order.dart';
import '../../models/refund_items_model.dart';
import '../home/home_viewmodel.dart';
import '../order_history/order_history_viewmodel.dart';

class OrderHistoryDetailViewModel extends GetxController {
  RxList<CartModel> productsInCart = <CartModel>[].obs;
  RxInt lineItemId = 0.obs;
  RxInt locationId = 0.obs;
  RxList refundItemlist = [].obs;
  Rx<Order> orderDetails = Order().obs;
  int transactionP_Id = 0;
  double refundablePrice = 0;
  RxBool isRefunded = false.obs;
  RxList<RefundItemsModel> refundItemsList = <RefundItemsModel>[].obs;
  RxDouble refundAmount = 0.0.obs;
  int? orderId;
  RxBool refundSelectedAllIs = false.obs;
  RxList selectedItemList = [].obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    orderDetails.value = Get.arguments['orderDetails'];
    super.onInit();
  }

  @override
  void onReady() {
    GlobalVariables.showLoader.value = true;
    final refundsList = orderDetails.value.refunds as List;
    if (refundsList.length ==
        orderDetails.value.fulfillments![0].lineItems?.length) {
      isRefunded.value = true;
    }
    super.onReady();
  }

  @override
  void onClose() {
    GlobalVariables.showLoader.value = false;
    super.onClose();
  }

  addItemsToRefundList() {
    refundItemsList.clear();
    orderDetails.value.fulfillments?[0].lineItems?.forEach(
      (element) async {
        if (orderDetails.value.refunds!.isNotEmpty) {
          orderDetails.value.refunds?.forEach((refundItem) {
            final index = refundItem.refundLineItems
                ?.indexWhere((item) => item.lineItemId == element.id);
            if (index == -1) {
              final splitted = element.name?.split(" - ");
              refundItemsList.add(RefundItemsModel(
                cartModel: CartModel(
                    name: splitted?.first.trim(),
                    price: double.parse(element.price!),
                    variantTitle: splitted?.last.trim(),
                    quantity: element.quantity,
                    // productTax: double.parse(element.taxLines![0].price!),
                    productId: element.productId,
                    variantId: element.variantId,
                    lineItemId: element.id,
                    sku: element.sku,
                    // harmonizedSystemCode: element.properties?[1].value,
                    quantityInStock: element.quantity,
                    properties: element.properties,
                    taxLines: element.taxLines,
                    inventoryItemId: element.properties?[0].value,
                    // priceWithoutTax: double.parse(element.price!) -
                    //     double.parse(element.taxLines![0].price!),
                ),
                isSelected: false,
              ));
              refundItemsList.refresh();
            }
          });
        } else {
          final splitted = element.name?.split(" - ");
          refundItemsList.add(
            RefundItemsModel(
              cartModel: CartModel(
                  name: splitted?.first.trim(),
                  price: double.parse(element.price!),
                  variantTitle: splitted?.last.trim(),
                  quantity: element.quantity,
                  // productTax: double.parse(element.taxLines![0].price!),
                  productId: element.productId,
                  variantId: element.variantId,
                  sku: element.sku,
                  lineItemId: element.id,
                  // harmonizedSystemCode: element.properties?[1].value,
                  quantityInStock: element.quantity,
                  properties: element.properties,
                  taxLines: element.taxLines,
                  inventoryItemId: element.properties?[0].value,
                  // priceWithoutTax: double.parse(element.price!) -
                  //     double.parse(element.taxLines![0].price!)
              ),
              isSelected: false,
            ),
          );
          refundItemsList.refresh();
        }
      },
    );
  }

  calculatePrice({required bool add, required int index, int? quantity}) {
    if (add) {
      if (quantity == null) {
        refundAmount.value = refundAmount.value +
            refundItemsList[index].cartModel!.price!;
      } else {
        refundAmount.value = refundAmount.value +
            (refundItemsList[index].cartModel!.price! *
                refundItemsList[index].cartModel!.quantity!);
      }
    } else {
      refundAmount.value =
          refundAmount.value - refundItemsList[index].cartModel!.price!;
    }
  }

  Future<void> refundCalculation() async {
    orderId = orderDetails.value.fulfillments![0].orderId ?? 0;
    Map<String, dynamic> param = // Session is built by the OAuth process
        {
      "refund": {
        "order_id": orderId,
        "calculate": {
          "refund": {"currency": "AED"}
        }
      }
    };
    ApiBaseHelper()
        .postMethod(url: "orders/$orderId/refunds/calculate.json", body: param)
        .then((parsedJson) async {
      GlobalVariables.showLoader.value = false;

      List transactionList = parsedJson['refund']['transactions'] as List;
      print("Refund Calculation======>>>>> ${transactionList}");
      if (transactionList.isNotEmpty) {
        transactionP_Id = transactionList[0]['parent_id'];
        refundablePrice =
            double.parse(transactionList[0]['maximum_refundable']).toDouble();

        AppConstants.displaySnackBar(
            "Success", 'Request for Refunded Successfully Approved');
        refundOrder();
      } else if (parsedJson['errors'] != null) {
        AppConstants.displaySnackBar('Error', 'Refund Request Failed');
      } else {
        AppConstants.displaySnackBar('Error', 'This Order is Already Refunded');
      }
    }).catchError((e) {
      AppConstants.displaySnackBar('Error', 'Sorry refund Request Error $e');
      print(e);
      GlobalVariables.showLoader.value = false;
    });
  }

  //=====Refund=====

  void selectItemFunc(index) {
    if (refundItemsList[index].isSelected == true) {
      refundItemlist.add({
        "line_item_id": refundItemsList[index].cartModel?.lineItemId,
        "quantity": refundItemsList[index].cartModel?.quantity,
        "restock_type": "return",
        "location_id": GlobalVariables.locationId.value,
        "already_stocked": false,
      });
    } else {
      refundItemlist.removeWhere((element) =>
          element['line_item_id'] ==
          refundItemsList[index].cartModel?.lineItemId);
    }
    // _itemlist = orderDetails.value.fulfillments![0].lineItems;
    // int? _locationId = orderDetails.value.fulfillments![0].locationId ?? 0;
    //
    // if (refundItemsList[index].isSelected == true) {
    //   refundItemlist.add({
    //     "line_item_id": _itemlist?[index].id,
    //     "quantity": _itemlist?[index].quantity,
    //     "restock_type": "return",
    //     "location_id": _locationId
    //   });
    // } else {
    //   refundItemlist.removeWhere((val) => val['line_item_id'] == _itemlist?[index].id);
    // }
  }

  Future<void> refundOrder() async {
    Map<String, dynamic> param = {
      "refund": {
        "order_id": orderId.toString(),
        "currency": "PKR",
        "notify": true,
        "reason": "Customer Returned",
        "shipping": {"full_refund": true},
        "refund_line_items": refundItemlist,
        "transactions": [
          {
            "parent_id": transactionP_Id,
            "amount": refundAmount.value,
            "kind": "refund",
            "gateway": "bogus"
          }
        ]
      }
    };
    ApiBaseHelper()
        .postMethod(url: "orders/$orderId/refunds.json", body: param)
        .then((parsedJson) async {
      GlobalVariables.showLoader.value = false;
      if (parsedJson['refund'] != null) {
        final HomeViewModel homeViewModel = Get.find();
        final OrderHistoryViewModel historyViewModel = Get.find();
        await historyViewModel.fetchOrders();
        homeViewModel.productsToShow.clear();
        homeViewModel.allProducts.clear();
        await homeViewModel.getProducts();
        Get.close(2);
        AppConstants.displaySnackBar("Success", 'Order Refunded Successfully');
      } else {
        AppConstants.displaySnackBar('Error', 'Order is already Refunded');
      }
    }).catchError(
      (e) {
        AppConstants.displaySnackBar('Error', 'Sorry Order Not Refund');
        print(e);
        GlobalVariables.showLoader.value = false;
      },
    );
  }
}
