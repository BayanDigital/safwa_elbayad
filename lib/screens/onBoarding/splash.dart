import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor:AppColors.primary,

      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacerH(250.h),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo2.png',

              ),
            ),
            Text(
              S.of(context).splashTitle,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextDecor.osBold14white.copyWith(
                color: const Color(0xFF000033),
                  fontSize: 20.sp,
                  height: 1.8,
                  fontWeight: FontWeight.w900
              ),
            ),
            const Spacer(),
            AppTextButton(
              width: 100,
              x: 10,
              height: 50.h,
              buttonColor: AppColors.white,
              title: S.of(context).letsGetStarted,
              titleColor: AppColors.primary,
 onTap: (){
   final Box appSettingsBox =
   Hive.box(AppHSC.appSettingsBox);
   appSettingsBox.put(
       AppHSC.hasSeenSplashScreen, true);
   context.nav.pushNamedAndRemoveUntil(
     Routes.homeScreen,
         (route) => false,
   );
 },
            ),
            AppSpacerH(40.h),
          ],
        ),
      ),
    );
    ;
  }
}
