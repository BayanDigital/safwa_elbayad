import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/screens/cart/my_cart_tab.dart';
import 'package:laundry_customer/screens/order/my_orders_tab_signed.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class MyOrdersTab extends ConsumerWidget {
  const MyOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child:
    SizedBox(
      height: 812.h,
      width: 375.w,
      child: Column(
        children: [
          Container(

            height: 108.h,
            width: 375.w,
            child: Column(
              children: [
                AppSpacerH(44.h),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: Text( S.of(context).myorder,style: AppTextDecor.osSemiBold18black.copyWith(
                      color: AppColors.primary
                    ),),
                  ),
                )
                ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(AppHSC.authBox).listenable(),
                builder: (BuildContext context, Box authbox, Widget? child) {
                  return authbox.get(AppHSC.authToken) != null
                      ? const MyOrdersSignedIn()
                      : const NotSignedInwidget();
                },
              ),
            ),
          ),
        ],
      ),),
    );
  }
}
