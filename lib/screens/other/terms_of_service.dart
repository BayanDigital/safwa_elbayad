import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class TermsOfService extends ConsumerWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tosProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SizedBox(
        height: 812.h,
        width: 375.w,

        child: SizedBox(
          child: Column(
            children: [
              SizedBox(

                height: 88.h,
                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    children: [
                      AppSpacerH(44.h),
                      Row(
                        children: [
                          GestureDetector(
                            onTap:  () {
                context.nav.pop();
                },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color:  AppColors.primary,

                            ),
                          ),
                          const AppSpacerW(10),
                          Text(S.of(context).trmsofsrvc,style: AppTextDecor.osBold20white
                              .copyWith(fontSize: 18, color: AppColors.primary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]


                      )

                    ],
                  ),
                ),
              ),
              Expanded(
                child: ref.watch(tosProvider).map(
                      initial: (_) => const SizedBox(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) => SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0.h),
                              child: Html(
                                style: {
                                  '*': Style(
                                    color: AppColors.black,
                                    fontSize: FontSize(14.sp),

                                  ),
                                },
                                data:
                                    '${_.data.data!.setting!.content!}<p></p><p></p><p></p><p></p><p></p>',
                              ),
                            ),
                            AppSpacerH(60.h),
                          ],
                        ),
                      ),
                      error: (_) => ErrorTextWidget(error: _.error),
                    ),

              ),

              AppSpacerH(20.h)
            ,],
          ),
        ),
      ),
    );
  }
}
