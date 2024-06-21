import 'package:flutter/material.dart';
import 'package:musicly/constant/app_colors.dart';
import 'package:musicly/constant/dimensions.dart';

Align submitButton({required String title, required Function() onPressed}) {
  return Align(
    alignment: Alignment.bottomRight,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, elevation: 5,
        backgroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height15,
            horizontal: Dimensions.width20), // text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              Dimensions.radius15), // button corner radius
        ),
        side: const BorderSide(
          color: Colors.black, // border color
          width: 2, // border width
        ),
        textStyle: const TextStyle(
          fontSize: 18, // text size
          fontWeight: FontWeight.bold, // text weight
        ),
      ),
      onPressed: onPressed,
      label: Text(
        title,
        style: TextStyle(fontSize: Dimensions.font20, color: Colors.white),
      ),
      icon: Icon(
        Icons.add,
        size: Dimensions.iconSize24,
        color: Colors.white,
      ),
      iconAlignment: IconAlignment.end,
    ),
  );
}
