import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/theme_helper.dart';
import '../../widgets/custom_buttons.dart';
import 'order_history_detail_viewmodel.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderHistoryDetailViewModel viewModel = Get.put(OrderHistoryDetailViewModel());

  OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            orderDetailHeadingItem(value: 'Order Info'),
            orderDetailContainerItem1(
              children: [
                orderDetailItem1(
                  title: 'Order No',
                  value: '${viewModel.orderDetails.value.orderNumber}',
                ),
                orderDetailItem1(
                  title: 'Order Date/Time',
                  value: '${viewModel.orderDetails.value.createdAt}',
                ),
              ],
            ),
            orderDetailHeadingItem(value: 'Customer Info'),
            orderDetailContainerItem1(
              children: [
                orderDetailItem1(
                  title: 'Customer Name',
                  value: viewModel.orderDetails.value.customer?.firstName ==
                      null &&
                      viewModel.orderDetails.value.customer?.lastName ==
                          null
                      ? ''
                      : viewModel.orderDetails.value.customer?.firstName == null
                      ? '${viewModel.orderDetails.value.customer?.lastName}'
                      : viewModel.orderDetails.value.customer?.lastName ==
                      null
                      ? '${viewModel.orderDetails.value.customer?.firstName}'
                      : '${viewModel.orderDetails.value.customer?.firstName} ${viewModel.orderDetails.value.customer?.lastName}',
                ),
                orderDetailItem1(
                  title: 'Customer Phone No',
                  value: viewModel.orderDetails.value.phone == null
                      ? ' '
                      : '${viewModel.orderDetails.value.phone}',
                ),
              ],
            ),
            orderDetailHeadingItem(value: 'Product Info'),
            Column(
              children: <Widget>[
                Container(
                  color: const Color(0xFF526D82).withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      orderHistoryTitle('Product Name'),
                      orderHistoryTitle('Variant'),
                      orderHistoryTitle('Quantity'),
                      orderHistoryTitle('Price'),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel
                      .orderDetails.value.fulfillments?[0].lineItems?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: const Color(0xFF526D82).withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          orderHistoryItem(
                              '${viewModel.orderDetails.value.fulfillments?[0].lineItems?[index].title}'),
                          orderHistoryItem(
                              '${viewModel.orderDetails.value.fulfillments?[0].lineItems?[index].variantTitle}'),
                          orderHistoryItem(
                              '${viewModel.orderDetails.value.fulfillments?[0].lineItems?[index].quantity}'),
                          orderHistoryItem(
                              '${viewModel.orderDetails.value.fulfillments?[0].lineItems?[index].price}'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            orderDetailHeadingItem(value: 'Calculations'),
            orderDetailContainerItem1(
              children: [
                orderDetailItem1(
                    title: 'Subtotal',
                    value:
                    (double.parse(viewModel.orderDetails.value.totalPrice!) - double.parse(viewModel.orderDetails.value.totalTax!)).toStringAsFixed(2)),
                orderDetailItem1(
                    title: 'Tax',
                    value: '${viewModel.orderDetails.value.totalTax}'),
                orderDetailItem1(
                    title: 'Total',
                    value: '${viewModel.orderDetails.value.totalPrice}'),
              ],
            ),
            Obx(
                  () => viewModel.isRefunded.value
                  ? const SizedBox()
                  : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 250,
                  child: CustomTextBtn(
                    title: 'Exchange',
                    onPressed: () async {
                      viewModel.refundItemlist.clear();
                      await viewModel.addItemsToRefundList();
                      refundOrderDialog();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future refundOrderDialog() async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ThemeHelper.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: SizedBox(
            width: 400,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            cartProductListView(),
                            const SizedBox(height: 8),
                            cartCalculation(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        viewModel.refundAmount.value = 0.0;
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cartProductListView() {
    return Expanded(
      child: Obx(
            () => viewModel.refundItemsList.isEmpty
            ? const Center(
          child: Text(
            'No Items in Cart',
            style: TextStyle(color: Colors.white),
          ),
        )
            : Obx(
              () => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: viewModel.refundItemsList.length,
            itemBuilder: (context, index) {
              return listViewItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget listViewItem(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Row(
              children: [
                CachedNetworkImage(
                  height: 70,
                  width: 70,
                  imageUrl: viewModel.refundItemsList[index].cartModel!.imageSrc
                      .toString(),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/no_image_found.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 0.5),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              viewModel.refundItemsList[index].cartModel!.name
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      viewModel.refundItemsList[index].cartModel
                          ?.variantTitle !=
                          "Default Title"
                          ? Text(
                        "Variant: ${viewModel.refundItemsList[index].cartModel?.variantTitle}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      )
                          : const SizedBox(),
                      Text(
                        'Rs ${viewModel.refundItemsList[index].cartModel?.price}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Obx(
                                () => Text(
                              'Qty : ${viewModel.refundItemsList[index].cartModel?.quantity}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          CustomIconButton(
                            onPressed: () {
                              if (viewModel.refundItemsList[index].cartModel!
                                  .quantity! >
                                  1) {
                                viewModel.refundItemsList[index].cartModel!
                                    .quantity = viewModel.refundItemsList[index]
                                    .cartModel!.quantity! -
                                    1;
                                viewModel.refundItemsList.refresh();
                                viewModel.calculatePrice(
                                    add: false, index: index);
                              } else {
                                return;
                              }
                            },
                            icon: Icons.remove_circle_outline_outlined,
                          ),
                          Obx(
                                () => Text(
                              '${viewModel.refundItemsList[index].cartModel?.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CustomIconButton(
                            onPressed: () {
                              if (viewModel.refundItemsList[index].cartModel!
                                  .quantity! <
                                  viewModel.refundItemsList[index].cartModel!
                                      .quantityInStock!) {
                                viewModel.refundItemsList[index].cartModel!
                                    .quantity = viewModel.refundItemsList[index]
                                    .cartModel!.quantity! +
                                    1;
                                viewModel.calculatePrice(
                                    add: true, index: index);
                              }
                            },
                            icon: Icons.add_circle_outline_rounded,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: viewModel.refundItemsList[index].isSelected!
                    ? ThemeHelper.green1
                    : Colors.transparent,
                border: Border.all(
                    color: viewModel.refundItemsList[index].isSelected!
                        ? ThemeHelper.green1
                        : Colors.white,
                    width: 0.5)),
            child: InkWell(
                onTap: () {
                  viewModel.refundItemsList[index].isSelected =
                  !viewModel.refundItemsList[index].isSelected!;
                  viewModel.refundItemsList.refresh();
                  viewModel.calculatePrice(
                      add: viewModel.refundItemsList[index].isSelected!,
                      index: index,
                      quantity:
                      viewModel.refundItemsList[index].cartModel!.quantity);
                  viewModel.selectedItemList.add(
                    viewModel.refundItemsList[index].cartModel!.quantity,
                  );
                  viewModel.selectItemFunc(index);
                },
                child: viewModel.refundItemsList[index].isSelected!
                    ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                )
                    : SizedBox()),
          ),
        )
      ],
    );
  }

  Widget cartCalculation() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: ThemeHelper.green1.withOpacity(0.05),
      ),
      child: Column(
        children: [
          const Divider(
            color: Colors.white,
            thickness: 0.8,
          ),
          Obx(() => item(
              title: 'Refund Amount',
              value: 'Rs ${viewModel.refundAmount.value}',
              fontSize: 18)),
          const SizedBox(height: 20),
          CustomTextBtn(
            height: 55,
            backgroundColor: ThemeHelper.green1,
            title: 'Exchange Items',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_return_rounded),
                SizedBox(width: 15),
                Text('Exchange Items')
              ],
            ),
            onPressed: () async {
              await viewModel.refundCalculation();
              Get.back();
              // viewModel.confirm_Order();
              // viewModel.payBill(
              //   subTotal: viewModel.cartSubTotal.value,
              //   tax: viewModel.cartTax.value,
              //   total: viewModel.cartTotal.value,
              //   quantity: viewModel.productQuantity.value,
              // );
            },
          ),
        ],
      ),
    );
  }

  Widget item({
    required String title,
    required String value,
    double fontSize = 14,
  }) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

//   Future<void> _showEditOrderDialog(
//       BuildContext context, OrderHistoryDetailViewModel viewModel) async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, setState) {
//             return AlertDialog(
//               title: Text('Edit Order'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     Text('Order No'),
//                     TextFormField(
//                       initialValue:
//                           viewModel.orderDetails.value.orderNumber.toString(),
//                       onChanged: (value) {
//                         viewModel.orderDetails.value.orderNumber =
//                             value as int?;
//                       },
//                     ),
//                     Text('Product Name'),
//                     TextFormField(
//                       initialValue: viewModel.orderDetails.value
//                           .fulfillments?[0].lineItems?[0].title,
//                       onChanged: (value) {
//                         viewModel.orderDetails.value.fulfillments?[0]
//                             .lineItems?[0].title = value;
//                       },
//                     ),
//                     Text('Variant'),
//                     TextFormField(
//                       initialValue: viewModel.orderDetails.value
//                           .fulfillments?[0].lineItems?[0].variantTitle,
//                       onChanged: (value) {
//                         viewModel.orderDetails.value.fulfillments?[0]
//                             .lineItems?[0].variantTitle = value;
//                       },
//                     ),
//                     Text('Quantity'),
//                     TextFormField(
//                       initialValue: viewModel.orderDetails.value
//                           .fulfillments?[0].lineItems?[0].quantity
//                           .toString(),
//                       onChanged: (value) {
//                         viewModel.orderDetails.value.fulfillments?[0]
//                             .lineItems?[0].quantity = int.parse(value);
//                       },
//                     ),
//                     Text('Order Date/Time'),
//                     TextFormField(
//                       initialValue: viewModel.orderDetails.value.createdAt,
//                       onChanged: (value) {
//                         viewModel.orderDetails.value.createdAt = value;
//                       },
//                     ),
//                     // Other order details go here...
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Save'),
//                   onPressed: () {
//                     //show success message here and then navigate to order history screen and then refresh order history screen
//                     Navigator.of(context).pop();
//                     Get.back();
//                     Get.snackbar(
//                       'Success',
//                       'Order updated successfully',
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: Colors.green,
//                       colorText: Colors.white,
//                     );
//                   },
//                 ),
//                 TextButton(
//                   child: Text('Cancel'),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                     Get.snackbar(
//                       'Error',
//                       'Order not updated',
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

  Widget orderDetailContainerItem1({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF526D82).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(children: children),
    );
  }

  Widget orderDetailHeadingItem({required String value}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 3),
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ));
  }

  Widget orderDetailItem1({required String title, required String value}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 13.5,
              ),
            ),
          ],
        ));
  }

  Widget orderHistoryTitle(String title) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget orderHistoryItem(String value) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}