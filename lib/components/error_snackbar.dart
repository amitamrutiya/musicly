import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicly/constant/dimensions.dart';

void showErrorSnackBar({required String title, required String message}) {
  Get.closeAllSnackbars();
  Get.snackbar(title, message,
      icon: Icon(
        Icons.dangerous_rounded,
        size: Dimensions.iconSize16 * 2,
      ),
      titleText: Text(
        title,
        style: TextStyle(
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.bold,
            fontFamily: 'assets/fonts/SourceSansPro-Bold'),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: Dimensions.font16),
      ),
      backgroundColor: Colors.red,
      backgroundGradient:
          const LinearGradient(colors: [Color(0xffED6F9E), Color(0xffEC8B6A)]));
}
