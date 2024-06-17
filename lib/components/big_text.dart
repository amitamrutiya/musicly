import 'package:flutter/material.dart';
import 'package:musicly/constant/app_colors.dart';
import 'package:musicly/constant/dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double? size;
  TextOverflow? overFlow;
  FontWeight? fontWeight;
  BigText(
      {super.key,
      this.color = AppColors.primaryTextColor,
      required this.text,
      this.size = 0,
      this.overFlow = TextOverflow.ellipsis,
      FontWeight? fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? Dimensions.font20 : size,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontFamily: 'Lora',
      ),
      softWrap: true,
    );
  }
}
