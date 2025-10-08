import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor, this.x, this.fontSize, this.borderColor,
  });
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? buttonColor;
  final Color?borderColor;
  final String title;
  final Color? titleColor;
  final Function()? onTap;
  final double ?x;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor??AppColors.primary,
          ),
          color: buttonColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(x??6.w),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextDecor.osBold14white
                .copyWith(color: titleColor ?? AppColors.white,fontSize: fontSize??14),
          ),
        ),
      ),
    );
  }
}


class AppTextButton2 extends StatelessWidget {
  const AppTextButton2({
    super.key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor, this.x,
  });
  final double? width;
  final double? height;
  final Color? buttonColor;
  final String title;
  final Color? titleColor;
  final Function()? onTap;
  final double ?x;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(x??6.w),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home,color: AppColors.white,),
              AppSpacerW(10.w),
              Text(
                title,
                style: AppTextDecor.osBold14white
                    .copyWith(color: titleColor ?? AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}