import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({
    super.key,
    this.backgroundColor = AppColors.white,
    this.titleColor = AppColors.black,
    this.backButtionColor = AppColors.white,
    this.title,
    this.onBack,
    this.showBack = true,
  });
  final String? title;
  final Color titleColor;
  final Color backButtionColor;
  final Color backgroundColor;
  final Function()? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: backgroundColor,
          height: 44.h,
          width: 400.w,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 80.h,
                    width: 260.w,
                    child: Center(
                      child: Text(
                        title ?? '',
                        style: AppTextDecor.osBold20white
                            .copyWith(fontSize: 18, color: titleColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showBack)
          Positioned(
            top: 12.h,
            child: Hive.box(AppHSC.appSettingsBox)
                        .get(AppHSC.appLocal)
                        .toString() ==
                    "ar"
                ? RotatedBox(
                    quarterTurns: 2, // Rotate by 180 degrees (2 quarter turns)
                    child: GestureDetector(
                      onTap: onBack,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: AppColors.black,
                      ),
                    ),
                    // AppBackButton(

                    //   size: 44.h,
                    //   onTap: onBack,
                    // ),
                  )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: onBack,
                      child: const Icon(
                        size: 40,
                        Icons.arrow_back_ios,
                        color: AppColors.black,
                      ),
                    ),
                ),
          ),
      ],
    );
  }
}
