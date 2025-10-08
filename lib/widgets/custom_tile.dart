import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class CustomTile extends StatelessWidget {
  CustomTile({
    super.key,
    required this.title,
    this.colorIcon,
    this.color,
    this.ontap,
    this.hasBorder = true, required this.image,
  });

  final String title;
  final String image;
  final Function()? ontap;
  Color? color;
  Color? colorIcon;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: ontap,
          child: SizedBox(
            width: 335.w,
            height: 60.h,

            child: Column(
              children: [
                Row(
                  children: [
                   Image.asset(image,width: 25,),
                    AppSpacerW(15.w),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextDecor.osRegular14black.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color ?? AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    IconButton(onPressed:ontap , icon: const Icon(Icons.arrow_back_ios))
                    // Icon(
                    //   Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal).toString() ==
                    //           "ar"
                    //       ? Icons.keyboard_arrow_left
                    //       : Icons.keyboard_arrow_right,
                    //   size: 24.w,
                    //   color: AppColors.gray,
                    // ),
                    // AppSpacerW(5.w)
                  ],
                ),
                const Divider(color: Color(0xFFB2C5E2),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile2 extends StatelessWidget {
  CustomTile2({
    super.key,

    required this.title,
    this.colorIcon,
    this.color,
    this.ontap,
    this.hasBorder = true,  this.image,
  });
  final String title;
  final String ? image;
  final Function()? ontap;
  Color? color;
  Color? colorIcon;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: ontap,
        child: SizedBox(
          width: 335.w,
          height: 60.h,

          child: Column(
            children: [
              Row(
                children: [
                 Image.asset(image??'assets/images/logout.png',width: 25,),
                  AppSpacerW(15.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextDecor.osRegular14black.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color ?? AppColors.black,
                      ),
                    ),
                  ),
                  IconButton(onPressed:ontap , icon: const Icon(Icons.arrow_back_ios))
                  // Icon(
                  //   Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal).toString() ==
                  //           "ar"
                  //       ? Icons.keyboard_arrow_left
                  //       : Icons.keyboard_arrow_right,
                  //   size: 24.w,
                  //   color: AppColors.gray,
                  // ),
                  // AppSpacerW(5.w)
                ],
              ),
              const Divider(color: Color(0xFFB2C5E2),)
            ],
          ),
        ),
      ),
    );
  }
}