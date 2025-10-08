import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/config.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class SignUpComplete extends StatelessWidget {
  const SignUpComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Container(
        padding: EdgeInsets.only(right: 20.w, left: 20.w,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              width: 310.w,
              height: 265.h,
            ),
            AppSpacerH(30.h),
            Text(
              S.of(context).cngrts,
              style:
                  AppTextDecor.osBold20Black.copyWith(color: AppColors.secondaryColor),
            ),
            AppSpacerH(10.h),
            Text(
              'لقد قمت بالتسجيل بنجاح  ',
              style: AppTextDecor.osBold16black
                  .copyWith(color: AppColors.secondaryColor,fontSize: 18),
              textAlign: TextAlign.center,
            ),
            AppSpacerH(60.h),
            AppTextButton(
              x: 10,
              width: 250,
              buttonColor: AppColors.primary,
              titleColor: AppColors.white,
              title: S.of(context).grt,
              onTap: () {
                context.nav.pushNamedAndRemoveUntil(
                  Routes.homeScreen,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
