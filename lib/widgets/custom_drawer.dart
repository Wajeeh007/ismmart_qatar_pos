import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ismmart_dubai_pos/screens/cashier_shift_report/cashier_shift_report_view.dart';
import '../screens/login/login_view.dart';
import '../screens/order_history/order_history_view.dart';
import '../screens/sales_summary/sales_summary_view.dart';
import '../screens/search_order/search_order_view.dart';
import 'loader_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Drawer(
            width: Get.width * 0.2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // drawerHeader(),
                  drawerItem(
                    title: 'Home',
                    icon: Icons.home,
                    onTap: () {
                      Get.back();
                      //Get.to(() => LeavesView());
                    },
                  ),
                  drawerItem(
                    title: 'Orders History',
                    icon: Icons.history,
                    onTap: () {
                      Get.back();
                      Get.to(() => OrderHistoryView());
                    },
                  ),
                  drawerItem(
                    title: 'Search Single Order',
                    icon: Icons.manage_search_outlined,
                    onTap: () {
                      Get.back();
                      Get.to(() => SearchOrderView());
                    },
                  ),
                  drawerItem(
                    title: 'Sales Summary',
                    icon: Icons.point_of_sale_sharp,
                    onTap: () {
                      Get.back();
                      Get.to(() => SalesSummaryView());
                    },
                  ),drawerItem(
                    title: 'Shift Report',
                    icon: Icons.file_copy_sharp,
                    onTap: () {
                      Get.back();
                      Get.to(() => CashierShiftReportView());
                    },
                  ),
                  drawerItem(
                    title: 'Logout',
                    icon: Icons.logout,
                    onTap: () {
                      Get.offAll(() => const LoginView());
                    },
                  ),
                ],
              ),
            ),
          ),
          const LoaderView()
        ],
      ),
    );
  }

  // Widget drawerHeader() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 20, top: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CachedNetworkImage(
  //           height: 75,
  //           width: 75,
  //           imageUrl: GlobalVariables.userModel?.image ?? '',
  //           imageBuilder: (context, imageProvider) {
  //             return Container(
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 image: DecorationImage(
  //                   image: imageProvider,
  //                   fit: BoxFit.fill,
  //                 ),
  //               ),
  //             );
  //           },
  //           errorWidget: (context, url, error) {
  //             return CircleAvatar(
  //                 radius: 35,
  //                 backgroundColor: Colors.grey.shade300,
  //                 child: Icon(
  //                   Icons.person,
  //                   size: 45,
  //                   color: Colors.grey,
  //                 ));
  //           },
  //           placeholder: (context, url) {
  //             return const Center(
  //               child: CircularProgressIndicator(strokeWidth: 0.5),
  //             );
  //           },
  //         ),
  //         SizedBox(height: 20),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 2),
  //           child: Text(
  //             '${GlobalVariables.userModel?.name}',
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.black,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         Divider(height: 30),
  //       ],
  //     ),
  //   );
  // }

  Widget drawerItem({
    String title = '',
    required IconData icon,
    double iconSize = 22,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 2,
      dense: true,
      contentPadding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
      leading: Icon(
        icon,
        size: iconSize,
        color: Colors.grey.shade500,
        //color: Get.theme.primaryColor.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

//   Widget drawerExpandableItem(
//       {String title = '',
//       required IconData icon,
//       double iconSize = 19,
//       required List<Widget> children}) {
//     return ListTileTheme(
//       horizontalTitleGap: -14,
//       dense: true,
//       child: ExpansionTile(
// // textColor: Color(0xff622260),
// // iconColor: Color(0xff622260),
//         tilePadding: EdgeInsets.only(left: 10, right: 20),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontFamily: 'Roboto-Regular',
// //fontWeight: FontWeight.w00
//           ),
//         ),
//         leading: Container(
//           child: Icon(
//             icon,
//             size: iconSize,
//             color: Colors.grey,
//           ),
//         ),
//         children: children,
//       ),
//     );
//   }
}
