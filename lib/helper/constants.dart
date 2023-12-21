import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppConstants {
  static const kLimeGreenColor = Color(0xFFACC254);
  static const kRedColor = Color(0xFFF54141);

  static displaySnackBar(String title, message, {SnackPosition? position}) {
    var bgColor = kLimeGreenColor;
    var icon = Icons.gpp_good_sharp;
    var titleNew = title;

    if (title.toLowerCase().contains('error')) {
      titleNew = "Oops!";
      bgColor = kRedColor;
      icon = Icons.error_outline;
    }

    var messageNew = message;

    Get.snackbar(titleNew.capitalizeFirst!.toString(), messageNew.toString(),
        duration: const Duration(milliseconds: 1500),
        snackPosition: position ?? SnackPosition.TOP,
        backgroundColor: bgColor,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        colorText: Colors.white);
  }

  static String convertDateFormat(String stringDate) {
    DateTime inputDate =
    DateFormat("yyyy-MM-ddTHH:mm:ss").parse(stringDate);
      String outputDate = DateFormat('dd MMM, yyyy - hh:mm a').format(inputDate);
    return outputDate;
  }

  static String? validateEmail(String? value) {
    if (GetUtils.isBlank(value)!) {
      return "Field is required";
    } else if (!GetUtils.isEmail(value!)) {
      return "Enter a valid email";
    } else {
      return null;
    }
  }

  static String? validateDefaultField(String? value) {
    if (GetUtils.isBlank(value)!) {
      return "Field is required";
    } else {
      return null;
    }
  }



}
