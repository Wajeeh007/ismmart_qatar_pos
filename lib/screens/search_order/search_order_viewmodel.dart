import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../helper/global_variables.dart';

class SearchOrderViewModel extends GetxController {
  final searchController = TextEditingController();
  @override
  void onClose() {
    GlobalVariables.showLoader.value = false;
    super.onClose();
  }
}
