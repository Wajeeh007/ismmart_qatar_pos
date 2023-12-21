import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ismmart_dubai_pos/helper/global_variables.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/constants.dart';
import '../../helper/urls.dart';
import '../home/home_view.dart';

class LoginViewModel extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login() async {
    Map<String, dynamic> param = {
      "email": emailController.text.toString(),
      "password": passController.text.toString()
    };

    ApiBaseHelper()
        .customPostMethod(url: Urls.login, body: param)
        .then((parsedJson) async {
      print("login  ======>>>>>> $parsedJson");
      if (parsedJson['success'] == true) {
        String token = parsedJson["data"]['token'] ?? "";
        await GetStorage().write("token", token);
        await getUserProfile();
      } else {
        AppConstants.displaySnackBar(
          'Error',
          'Login Failed.',
        );
      }
    }).catchError((e) {
      AppConstants.displaySnackBar(
        'Error',
        e,
      );
    });
  }

  //Get Profile-------
  Future<void> getUserProfile() async {
    ApiBaseHelper()
        .getMethodFrmCustomApi(url: Urls.profile, withAuthorization: true)
        .then((parsedJson) async {
      if (parsedJson['success'] == true) {
        GlobalVariables.locationId.value = int.parse(
            parsedJson['data']['location']['location']['id'].toString());
        GlobalVariables.locationName.value =
            parsedJson['data']['location']['location']['name'];
        GlobalVariables.locationAddress.value = parsedJson['data']['location']
                ['location']['address1'] +
            parsedJson['data']['location']['location']['address2'] ;
            // parsedJson['data']['location']['location']['province'];
        GlobalVariables.cashierName.value =
            parsedJson['data']['name'].toString();
        Get.off(() => HomeView());
      } else {
        AppConstants.displaySnackBar(
          'Error',
          'User Location not Found.',
        );
      }
    }).catchError((e) {
      AppConstants.displaySnackBar(
        'Error',
        e,
      );
    });
  }
}
