import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ismmart_dubai_pos/screens/search_order/search_order_viewmodel.dart';
import '../../helper/theme_helper.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_textfield.dart';
import '../order_history/order_history_viewmodel.dart';

class SearchOrderView extends StatelessWidget {
  SearchOrderView({super.key});
  final viewModel = Get.put(SearchOrderViewModel());
  final viewModel2 = Get.put(OrderHistoryViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Single Order'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeHelper.white.withOpacity(0.2))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo_white.png'),
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'ISMMART POS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              const SizedBox(height: 10),
              const Text(
                'Search Order',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20),
                child: CustomTextField1(
                  controller: viewModel.searchController,
                  hint: 'Order No',
                  suffixIcon: Icons.manage_search_outlined,
                ),
              ),
              CustomTextBtn(
                height: 52,
                radius: 30,
                title: "Search",
                backgroundColor: Colors.white.withOpacity(0.2),
                onPressed: () {
                  int orderId =
                      int.tryParse(viewModel.searchController.text) ?? 0;

                  if (orderId == 0) {
                    Get.snackbar(
                      'Error',
                      'Please enter a valid Order No.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    viewModel2.orderDetail(orderId);
                  }
                  // bool orderIdFound = false;

                  // for (var i = 0; i < viewModel2.ordersList.length; i++) {
                  //   if (viewModel2.ordersList[i].id == orderId) {
                  //     orderIdFound = true;
                  //     break;
                  //   }
                  // }

                  // if (orderIdFound) {
                  //   viewModel2.orderDetail(orderId);
                  // } else {
                  //   Get.snackbar(
                  //     'Error',
                  //     'Please enter a valid Order No.',
                  //     snackPosition: SnackPosition.TOP,
                  //     backgroundColor: Colors.red,
                  //     colorText: Colors.white,
                  //   );
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
