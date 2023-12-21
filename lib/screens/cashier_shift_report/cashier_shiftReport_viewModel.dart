import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ismmart_dubai_pos/helper/api_base_helper.dart';
import 'package:ismmart_dubai_pos/helper/constants.dart';
import 'package:ismmart_dubai_pos/helper/global_variables.dart';
import 'package:ismmart_dubai_pos/helper/theme_helper.dart';
import 'package:ismmart_dubai_pos/screens/cashier_shift_report/shift_report_order_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../helper/urls.dart';

class CashierShiftReportViewModel extends GetxController {
  Map<String, dynamic> shiftDataMap = <String, dynamic>{}.obs;
  int? locationID = 0;
  RxDouble? totalSale = 0.0.obs;
  RxDouble refundAmount = 0.0.obs;
  int ordersCount = 0;
  int sinceId = 0;
  TextEditingController cashRefundController = TextEditingController();
  TextEditingController cashExpensesController = TextEditingController();
  TextEditingController cashOutController = TextEditingController();
  TextEditingController cashHandOverController = TextEditingController();
  List<ShiftReportOrder> allOrders = [];

  @override
  void onReady() {
    getCashReport();
    super.onReady();
  }

  getShiftReportData() async {
    num? shiftID = Random().nextInt(1000000000);
    shiftDataMap.putIfAbsent('shiftId', () => shiftID);
    shiftDataMap.putIfAbsent(
        'cashier', () => GlobalVariables.cashierName.value);

    String startDate = AppConstants.convertDateFormat(
        DateTime.now().add(const Duration(hours: -8)).toIso8601String());
    String endDate =
        AppConstants.convertDateFormat(DateTime.now().toIso8601String());

    shiftDataMap.putIfAbsent('started', () => startDate);
    shiftDataMap.putIfAbsent('ended', () => endDate);
    shiftDataMap.putIfAbsent(
        'startBal', () => GlobalVariables.startingBalance.value);
  }

  Future<void> getCashReport() async {

    ApiBaseHelper().getMethodFrmCustomApi(url: "${Urls.getOrdersForShiftReport}${GlobalVariables.locationId.value}").then((parsedJson) {
      final data = parsedJson['data']['items'] as List;
      if(data.isNotEmpty){
        allOrders.addAll(data.map((e) => ShiftReportOrder.fromJson(e)));
        handleAllOrdersData();
      }
    });
  }

  void handleAllOrdersData() {
    allOrders.forEach((element) {
      DateTime previousEightHours = DateTime.now().subtract(const Duration(hours: 8));
      DateTime elementDateTime = DateTime.parse(element.fulfillments![0].createdAt!);
      if(element.fulfillments!.isNotEmpty && elementDateTime.compareTo(previousEightHours) >= 0){
          totalSale!.value += double.parse(element.currentTotalPrice!);
          refundAmount.value += double.parse(element.totalPrice!) - double.parse(element.currentTotalPrice!);
      }
    });
  }

  Future cashierShiftReport() async {
    getShiftReportData();
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
            child: Scaffold(
              appBar: AppBar(),
              body: PdfPreview(
                canDebug: false,
                canChangeOrientation: false,
                canChangePageFormat: false,
                initialPageFormat: const PdfPageFormat(100, double.minPositive),
                build: (format) => createPDF(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List> createPDF() async {

    var pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Cashier Shift Report',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      //fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    infoItem(title: "Shift ID", value: shiftDataMap['shiftId']),
                    infoItem(
                        title: 'Terminal',
                        value: GlobalVariables.locationName.value),
                    infoItem(
                        title: 'Cashier',
                        value: GlobalVariables.cashierName.value),
                    infoItem(title: 'Started', value: shiftDataMap['started']),
                    infoItem(title: 'Ended', value: shiftDataMap['ended']),
                    infoItem(
                        title: 'Start Balance',
                        value: GlobalVariables.startingBalance.value),
                  ],
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Cash Income',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      //fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    infoItem(
                        title: 'Start Balance',
                        value: GlobalVariables.startingBalance.value),
                    infoItem(
                        title: 'Sales',
                        value: totalSale!.value.toString()),
                    // infoItem(
                    //     title: 'Cash In', value: totalSale!.value.toString()),
                    //infoItem(title: 'Total Cash Income', value: shiftDataMap['startBal']),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Total Income: ${calculateTotalCashIn()}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        //fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Cash Expenditure',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      //fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.5),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  infoItem(
                      title: 'Cash Refund',
                      value: refundAmount.value),
                  infoItem(
                      title: 'Cash Expenses',
                      value: cashExpensesController.text.trim()),
                  infoItem(
                      title: 'Cash Out', value: cashOutController.text.trim()),
                  infoItem(
                      title: 'Cash Handover',
                      value: cashHandOverController.text.trim()),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Total Expenditure: ${calculateExpenditure()}',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      //fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget infoItem({String? title, value}) {
    //final parts = value.split(':'); // Splitting the text by colon
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
          vertical: 1), // Adjust vertical padding as needed
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 70, // Set a fixed width for the first Text widget
            child: pw.Text(
              '$title : ',
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              "$value",
              // parts.length > 1 ? parts[1].trim() : '',
              textAlign: pw.TextAlign.left,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalCashIn() {
    double startBal = GlobalVariables.startingBalance.value.toDouble();

    return startBal + totalSale!.value;
  }

  double calculateExpenditure() {
    double expenses = double.tryParse(cashExpensesController.text) ?? 0;
    // double refund = double.tryParse(cashRefundController.text) ?? 0;
    double cashOut = double.tryParse(cashOutController.text) ?? 0;
    double handover = double.tryParse(cashHandOverController.text) ?? 0;

    return expenses + refundAmount.value + cashOut + handover;
  }

  @override
  void onClose() {
    super.onClose();
    shiftDataMap.clear();
  }
}
