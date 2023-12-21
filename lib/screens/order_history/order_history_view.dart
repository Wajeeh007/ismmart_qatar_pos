import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/constants.dart';
import '../../helper/theme_helper.dart';
import 'order_history_viewmodel.dart';

class OrderHistoryView extends StatelessWidget {
  final OrderHistoryViewModel viewModel = Get.put(OrderHistoryViewModel());

  OrderHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        //actions: [topMenu(context)],
      ),
      body: Column(
        children: [
          //  topMenu(context),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
                  () =>
              viewModel.ordersList.isEmpty
                  ? Center(
                child: viewModel.ordersListCheck.value ? const Text(
                  'No Orders Yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ) : const CircularProgressIndicator(
                  color: Colors.white,
                )
              ) : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      orderHistoryTitle('Order ID'),
                      orderHistoryTitle('Created at'),
                      orderHistoryTitle('Name'),
                      orderHistoryTitle('Total'),
                      orderHistoryTitle('Status', color: Colors.yellow),
                    ],
                  ), //expanded wrapped inside coloumn
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      //  reverse: true,
                      controller: viewModel.scrollController,
                      itemCount: viewModel.ordersList.length,
                      padding: const EdgeInsets.only(bottom: 50),
                      itemBuilder: (context, index) {
                        //_navigateToTop();
                        final order = viewModel.ordersList[index];
                        // String status = viewModel.statusListt[index];
                        final isEvenRow = index % 2 == 0;
                        final rowColor = isEvenRow
                            ? const Color(0xFF526D82).withOpacity(0.4)
                            : const Color(0xFF526D82).withOpacity(0.2);

                        return InkWell(
                          onTap: () {
                            viewModel.orderDetail(order.id ?? 0);
                          },
                          child: Container(
                            color: rowColor,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                orderHistoryItem(order.id.toString()),
                                orderHistoryItem(
                                    AppConstants.convertDateFormat(
                                        order.createdAt.toString())),
                                orderHistoryItem(order.name.toString()),
                                orderHistoryItem(
                                    order.totalPrice.toString()),
                                orderHistoryItem(
                                    viewModel.ordersList[index]
                                        .financialStatus == 'paid' ?
                                    "Completed"
                                        : viewModel.ordersList[index]
                                        .financialStatus == 'partially_refunded'
                                        ? 'Partially Refunded'
                                        : "Refunded",
                                    color: viewModel.ordersList[index]
                                        .financialStatus == 'paid'
                                        ? Colors.green
                                        : viewModel.ordersList[index]
                                        .financialStatus == 'partially_refunded'
                                        ? Colors.deepPurple
                                        : Colors.red),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  viewModel.loadMore.value == true
                      ? const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          viewModel.loadMore.value == true
              ? const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 40),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget topMenu(BuildContext context) {
    return SizedBox(
      width: 700,
      child: TextFormField(
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: ThemeHelper.white,
        ),
        onChanged: (value) {
          // Handle search here
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            CupertinoIcons.search,
            size: 18,
            color: ThemeHelper.white,
          ),
          contentPadding: const EdgeInsets.only(left: 16),
          fillColor: Colors.white.withOpacity(0.1),
          filled: true,
          hintText: 'Search Order History here...',
          isDense: true,
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: ThemeHelper.white,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget orderHistoryTitle(String title, {Color? color}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget orderHistoryItem(String value, {Color? color}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // void _navigateToTop() {
  //   final Duration duration = const Duration(milliseconds: 400);
  //   final Curve curve = Curves.ease;
  //   if (viewModel.scrollController.hasClients) {
  //     var scrollPosition = this.viewModel.scrollController.position;

  //     scrollPosition.animateTo(
  //       0,
  //       duration: duration,
  //       curve: curve,
  //     );
  //   }
  // }
}
