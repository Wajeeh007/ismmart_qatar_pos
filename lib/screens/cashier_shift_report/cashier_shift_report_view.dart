import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/scrollable_column.dart';
import 'cashier_shiftReport_viewModel.dart';


class CashierShiftReportView extends StatelessWidget {
   CashierShiftReportView({super.key});
final CashierShiftReportViewModel viewModel = Get.put(CashierShiftReportViewModel());

  @override
  Widget build(BuildContext context){
    var formKey = GlobalKey<FormState>();
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shift Report'),
        ),
        body:  Form(
          key: formKey,
          child: ScrollableColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                'Cash Expenditures',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 15),
                  child: CustomTextField1(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: viewModel.cashExpensesController,
                    hint: 'Cash Expenses',
                    suffixIcon: Icons.expand,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Expenses is required!';
                      }
                      return null;
                      //return viewModel.emailValidate(value);
                    },
                  ),
                ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 15),
              //     child: CustomTextField1(
              //       controller: viewModel.cashRefundController,
              //       hint: 'Cash Refund',
              //       suffixIcon: Icons.call_received_sharp,
              //       keyboardType: TextInputType.number,
              //       validator: (value) {
              //         if (value == null || value.isEmpty) {
              //           return 'Cash refund required!';
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CustomTextField1(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: viewModel.cashOutController,
                    hint: 'Cash out',
                    suffixIcon: Icons.outbound_outlined,keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cash out required!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CustomTextField1(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: viewModel.cashHandOverController,
                    hint: 'Cash Handover',
                    suffixIcon: Icons.handshake,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cash Handover required!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: CustomTextBtn(
                  height: 52,
                  radius: 30,
                  title: "Generate Report",
                  backgroundColor: Colors.white.withOpacity(0.2),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      //viewModel.login();
                      viewModel.cashierShiftReport();
                      // PdfPreview(
                      //   canDebug: false,
                      //   canChangeOrientation: false,
                      //   canChangePageFormat: false,
                      //   initialPageFormat: const PdfPageFormat(100, double.minPositive),
                      //   build: (format) => viewModel.createPDF(),
                      // );
                    }
                  },
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
