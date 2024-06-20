import 'package:flutter/material.dart';
import 'package:musicly/constant/app_colors.dart';
import 'package:musicly/constant/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final IconData icon;
  final TextInputType? textInputType;
  final String labelText;
  final String? hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const AppTextField(
      {super.key,
      required this.textController,
      this.hintText,
      required this.icon,
      required this.labelText,
      this.textInputType,
      this.onSaved,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.height10 / 2, right: Dimensions.height10 / 2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(1, 1),
                color: Colors.grey.withOpacity(0.2))
          ]),
      child: TextFormField(
        maxLines: hintText == "Address" ? 2 : 1,
        keyboardType: textInputType,
        obscureText: hintText == "password" ? true : false,
        controller: textController,
        onSaved: onSaved,
        validator: validator,
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
          ),
          labelText: labelText,

          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.signColor),
          // prefix: const Icon(Icons.email, color: AppColors.yellowColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
        ),
      ),
    );
  }
}
