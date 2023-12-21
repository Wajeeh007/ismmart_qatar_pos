import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/global_variables.dart';
import '../../helper/urls.dart';
import '../../models/orders_model.dart';

class SalesSummaryViewModel extends GetxController {

  RxList<Orders> ordersList = <Orders>[].obs;
  RxList<Orders> completedOrdersList = <Orders>[].obs;
  RxInt sinceOrderId = 0.obs;
  RxDouble cashPaymentReceived = 0.0.obs;
  RxDouble cardPaymentReceived = 0.0.obs;
  RxList<Orders> refundedOrdersList = <Orders>[].obs;
  RxDouble cashRefundedAmount = 0.0.obs;
  RxDouble advanceAmount = 0.0.obs;
  RxDouble debtorAmount = 0.0.obs;
  RxDouble cashInAmount = 0.0.obs;
  RxDouble pointsAdded = 0.0.obs;
  RxDouble cashExpenses = 0.0.obs;
  RxDouble supPayments = 0.0.obs;
  RxDouble cashHandOut = 0.0.obs;
  RxDouble cashHandOver = 0.0.obs;
  RxDouble chequeSales = 0.0.obs;
  RxDouble bankSales = 0.0.obs;
  RxDouble cashOut = 0.0.obs;
  RxDouble voucherRedeems = 0.0.obs;
  RxDouble giftVouchers = 0.0.obs;
  RxDouble creditSales = 0.0.obs;
  RxDouble cardRefundedAmount = 0.0.obs;
  RxDouble slipExchange = 0.0.obs;
  RxDouble returnOverPay = 0.0.obs;
  RxBool dataRetrieved = false.obs;

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  @override
  void onReady() async {
    GlobalVariables.showLoader.value = true;
    // value = GetStorage().read('cashInHand');
    super.onReady();
  }

  getOrders() {
    DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(currentDate);
    
    ApiBaseHelper().getMethodFrmCustomApi(url: "${Urls.getOrdersForSalesSummary}${GlobalVariables.locationId.value}").then((parsedJson) {
      final data = parsedJson['data']['items'] as List;
      GlobalVariables.showLoader.value = false;
      if(data.isNotEmpty) {
            List<Orders> allOrders = [];
            allOrders.addAll(data.map((e) => Orders.fromJson(e)));
            allOrders.forEach((element) async {
              if(element == allOrders.last && element.createdAt!.contains(formatted)){
                ordersList.add(element);
                ordersList.refresh();
                await filterData();
              } else{
                if(element.createdAt!.contains(formatted)){
                  ordersList.add(element);
                  ordersList.refresh();
                }
              }
            });
      }
    });
  }

  filterData() {
    ordersList.forEach((element) {
      if(element.note == "1") {
        cashRefundedAmount.value += double.parse(element.totalPrice!) - double.parse(element.currentTotalPrice!);
        cashPaymentReceived.value += double.parse(element.currentTotalPrice!);
      } else {
        cardRefundedAmount.value += double.parse(element.totalPrice!) - double.parse(element.currentTotalPrice!);
        cardPaymentReceived.value += double.parse(element.currentTotalPrice!);
      }
      if(element == ordersList.last){
        dataRetrieved.value = true;
      }
    });
  }

  Future<Uint8List> createPDF() async {

    DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    final String formatted = formatter.format(currentDate);

    var pdf = Document();
    pdf.addPage(
      Page(
        pageTheme: const PageTheme(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) {
          return Column(
            children: [
              Text(
                'Sales Summary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'ISMMART Outlets',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 7,
                  ),
                ),
              ),
              Center(
                child: item1(
                  'Date: $formatted / Branch : ${GlobalVariables.locationName.value}',
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: containerDecoration(
                        allBorder: true,
                        child: Column(
                          children: [
                            headingItem('Cash Income'),
                            item2(
                              title: 'Cash Sales',
                              value: cashPaymentReceived.value == 0.0 ? '-' : '${cashPaymentReceived.value}',
                            ),
                            item2(
                              title: 'Adv/Over Payments',
                              value: advanceAmount.value == 0.0 ? '-' : '${advanceAmount.value}',
                            ),
                            item2(
                              title: 'Debtor Payments',
                              value: debtorAmount.value == 0.0 ? '-' : '${debtorAmount.value}',
                            ),
                            item2(
                              title: 'Points Added',
                              value: pointsAdded.value == 0.0 ? '-' : '${pointsAdded.value}',
                            ),
                            item2(
                              title: 'Cash In',
                              value: cashInAmount.value == 0.0 ? '-' : '${cashInAmount.value}',
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: PdfColors.grey200,
                                border: topBottomBorder,
                              ),
                              child: totalItem(
                                title: 'Total',
                                value: '${cashPaymentReceived.value + advanceAmount.value + debtorAmount.value + pointsAdded.value + cashInAmount.value}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: containerDecoration(
                        allBorder: true,
                        child: Column(
                          children: [
                            headingItem('Cash Expenditure'),
                            item2(
                              title: 'Cash Refunds',
                              value: cashRefundedAmount.value == 0.0 ? '-' : '${cashRefundedAmount.value}',
                            ),
                            item2(
                              title: 'Cash Expenses',
                              value: cashExpenses.value == 0.0 ? '-' : '${cashExpenses.value}',
                            ),
                            item2(
                              title: 'Sup. Payments',
                              value: supPayments.value == 0.0 ? '-' : '${supPayments.value}',
                            ),
                            item2(
                              title: 'Cash Out',
                              value: cashOut.value == 0.0 ? '-' : '${cashOut.value}',
                            ),
                            item2(
                              title: 'Cash Handover',
                              value: cashHandOver.value == 0.0 ? '-' : '${cashHandOver.value}',
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: PdfColors.grey200,
                                border: topBottomBorder,
                              ),
                              child: totalItem(
                                title: 'Total',
                                value: '${cashExpenses.value + cashRefundedAmount.value + supPayments.value + cashOut.value + cashHandOver.value}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: containerDecoration(
                        child: Column(
                          children: [
                            headingItem('Cash Income'),
                            item2(
                              title: 'Cash Sale',
                              value: cashPaymentReceived.value == 0.0 ? '-' : '${cashPaymentReceived.value}',
                            ),
                            item2(
                              title: 'Credit Sales',
                              value: creditSales.value == 0.0 ? '-' : '${creditSales.value}',
                            ),
                            item2(
                              title: 'Card Sales',
                              value: cardPaymentReceived.value == 0.0 ? '-' : '${cardPaymentReceived.value}',
                            ),
                            item2(
                              title: 'Cheque Sales',
                              value: chequeSales.value == 0.0 ? '-' : '${chequeSales.value}',
                            ),
                            item2(
                              title: 'Bank Sales',
                              value: bankSales.value == 0.0 ? '-' : '${bankSales.value}',
                            ),
                            item2(
                              title: 'Voucher Redeems',
                              value: voucherRedeems.value == 0.0 ? '-' : '${voucherRedeems.value}',
                            ),
                            item2(
                              title: 'Gift Vouchers',
                              value: giftVouchers.value == 0.0 ? '-' : '${giftVouchers.value}',
                            ),
                            totalItem(
                              title: 'Total',
                              value: '${cashPaymentReceived.value + creditSales.value + cardPaymentReceived.value + chequeSales.value + bankSales.value + voucherRedeems.value + giftVouchers.value}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: containerDecoration(
                        allBorder: true,
                        child: Column(
                          children: [
                            headingItem('Sales Returns'),
                            item2(
                              title: 'Cash Refunds',
                              value: cashRefundedAmount.value == 0.0 ? '-' : '${cashRefundedAmount.value}',
                            ),
                            item2(
                              title: 'Card Refunds',
                              value: cardRefundedAmount.value == 0.0 ? '-' : '${cardRefundedAmount.value}',
                            ),
                            item2(
                              title: 'Exchange Slips',
                              value: slipExchange.value == 0.0 ? '-' : '${slipExchange.value}',
                            ),
                            item2(
                              title: 'Return Overpay',
                              value: returnOverPay.value == 0.0 ? '-' : '${returnOverPay.value}',
                            ),
                            totalItem(
                              title: 'Total',
                              value: '${cashRefundedAmount.value + cardRefundedAmount.value + slipExchange.value + returnOverPay.value}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: containerDecoration(
                    //     child: Column(
                    //       children: [
                    //         headingItem('Discounts'),
                    //         item2(
                    //           title: 'Line Discounts',
                    //           value: '16,282.50',
                    //         ),
                    //         item2(
                    //           title: 'Bill Discounts',
                    //           value: '16,282.50',
                    //         ),
                    //         item2(
                    //           title: 'Debtor Discounts',
                    //           value: '16,282.50',
                    //         ),
                    //         totalItem(
                    //           title: 'Total',
                    //           value: '0.00',
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 160,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(
              //         child: containerDecoration(
              //           child: Column(
              //             children: [
              //               headingItem('Debtor Payments'),
              //               item2(
              //                 title: 'Cash Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'CARD Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'Chq Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'Bank Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'Overpayment Setl.',
              //                 value: '16,282.50',
              //               ),
              //               totalItem(
              //                 title: 'Total',
              //                 value: '0.00',
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: containerDecoration(
              //           allBorder: true,
              //           child: Column(
              //             children: [
              //               headingItem('Advance Payment'),
              //               item2(
              //                 title: 'Cash Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'CARD Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'Chq Payments',
              //                 value: '16,282.50',
              //               ),
              //               item2(
              //                 title: 'Bank Payments',
              //                 value: '16,282.50',
              //               ),
              //               totalItem(
              //                 title: 'Total',
              //                 value: '0.00',
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: containerDecoration(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               headingItem('Bank-wise Card Payments'),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Text item1(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 9,
      ),
    );
  }

  Padding item2({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row totalItem({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Padding headingItem(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget containerDecoration({required Widget child, bool allBorder = false}) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        border: allBorder ? allSideBorder : topBottomBorder,
      ),
      child: child,
    );
  }

  Border topBottomBorder = const Border.symmetric(
    horizontal: BorderSide(color: PdfColors.black, width: 0.09),
  );

  Border allSideBorder = Border.all(color: PdfColors.black, width: 0.09);
}