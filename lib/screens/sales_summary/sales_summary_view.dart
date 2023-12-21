import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ismmart_dubai_pos/screens/sales_summary/sales_summary_viewmodel.dart';
import 'package:ismmart_dubai_pos/widgets/loader_view.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SalesSummaryView extends StatelessWidget {
  SalesSummaryView({super.key});

  final SalesSummaryViewModel viewModel = Get.put(SalesSummaryViewModel());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales Summary'),
        ),
        body: Obx(() => viewModel.dataRetrieved.value ? PdfPreview(
          canDebug: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          initialPageFormat: const PdfPageFormat(100, double.minPositive),
          build: (format) => viewModel.createPDF(),
        ) : const LoaderView()
      ),
      )
    );
  }

  // Future receiptDialog() async {
  //   return showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: ThemeHelper.backgroundColor,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(13),
  //         ),
  //         child: SizedBox(
  //           width: Get.width,
  //           child: Scaffold(
  //             appBar: AppBar(),
  //             body: PdfPreview(
  //               canDebug: false,
  //               canChangeOrientation: false,
  //               canChangePageFormat: false,
  //               initialPageFormat: const PdfPageFormat(100, double.minPositive),
  //               build: (format) => viewModel.createPDF(),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
