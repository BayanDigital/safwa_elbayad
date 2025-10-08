import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class RecoverPasswordStageTwo extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  final String forEmailorPhone;

  RecoverPasswordStageTwo({super.key, required this.forEmailorPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      body: SingleChildScrollView(
        child: SizedBox(
          height: 812.h,
          width: 375.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical:8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacerH(20.h),

                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: (){
                      context.nav.pop();
                    }, icon: const Icon(Icons.arrow_back,color: AppColors.primary,)),
                  ),
                  AppSpacerH(100.h),

                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/otp.png',
                        width: 200,

                      ),
                    ),
                  ),
                  AppSpacerH(20.h),
                  Center(
                    child: Text(
                      S.of(context).entrotp,
                      style: AppTextDecor.osBold20Black.copyWith(
                        color: AppColors.primary
                      ),

                    ),
                  ),
                  AppSpacerH(10.h),
                  Center(
                    child: Text(
                      '${S.of(context).ndgtotp} ',
                      style: AppTextDecor.osSemiBold14black
                          .copyWith(color: AppColors.secondaryColor),

                    ),
                  ),
                  AppSpacerH(10.h),
                  Expanded(
                    child: Column(
                      children: [
                        AppSpacerH(33.h),
                        Form(
                          key: formKey,
                          child: PinCodeTextField(

                            appContext: context,
                            length: 4,
                            hintCharacter: '_',
                            animationType: AnimationType.fade,
                            validator: (v) {
                              debugPrint(v);
                              return null;
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10.w),
                              fieldHeight: 50.w,
                              fieldWidth: 70.w,
                              inactiveFillColor: AppColors.primary,
                              activeFillColor: AppColors.white,
                              activeColor: AppColors.primary,
                              errorBorderColor: AppColors.white,
                              inactiveColor: AppColors.primary,
                            ),
                            cursorColor: Colors.black,
                            animationDuration: const Duration(milliseconds: 300),
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            onCompleted: (v) {
                              debugPrint("Completed");
                            },
                            onChanged: (String value) {
                              debugPrint("Changed : $value");
                            },
                          ),
                        ),
                        AppSpacerH(10.h),
                        Consumer(
                          builder: (context, ref, child) {
                            final int time = ref.watch(forgotPassTimerProvider);
                            return SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (time > 0)
                                    Text(
                                      '${S.of(context).otpwillbesnd} : ${time > 9 ? time : '0$time'}',
                                      style: AppTextDecor.osRegular14black
                                          .copyWith(color: AppColors.primary),
                                    )
                                  else
                                    const SizedBox(),
                                  if (time <= 0)
                                    ref.watch(forgotPassProvider).maybeMap(
                                      orElse: () {
                                        return const SizedBox();
                                      },
                                      initial: (_) {
                                        return GestureDetector(
                                          onTap: () async {
                                            await ref
                                                .watch(
                                              forgotPassProvider.notifier,
                                            )
                                                .forgotPassword(
                                              forEmailorPhone,
                                            );

                                            ref
                                                .watch(forgotPassProvider)
                                                .maybeWhen(
                                              orElse: () {},
                                              loaded: (_) {
                                                ref
                                                    .watch(
                                                  forgotPassTimerProvider
                                                      .notifier,
                                                )
                                                    .startTimer();
                                              },
                                            );
                                          },
                                          child: Text(
                                            S.of(context).rsndotp,
                                            style: AppTextDecor.osBold14black.copyWith(
                                              color:AppColors.primary,
                                            ),
                                          ),
                                        );
                                      },
                                      loading: (_) => SizedBox(
                                        height: 10.h,
                                        width: 10.w,
                                        child: const LoadingWidget(),
                                      ),
                                      error: (_) {
                                        return const SizedBox();
                                      },
                                    )
                                  else
                                    const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                        AppSpacerH(50.h),
                        SizedBox(
                          height: 50.h,
                          child: Consumer(
                            builder: (context, ref, child) {
                              return ref
                                  .watch(forgotPassOtpVerificationProvider)
                                  .map(
                                error: (_) {
                                  Future.delayed(transissionDuration).then((value) {
                                    ref.refresh(forgotPassOtpVerificationProvider);
                                  });
                                  return ErrorTextWidget(error: _.error);
                                },
                                loaded: (_) {
                                  Future.delayed(transissionDuration).then((value) {
                                    ref.refresh(
                                      forgotPassOtpVerificationProvider,
                                    ); //Refresh This so That App Doesn't Auto Login

                                    Future.delayed(buildDuration).then((value) {
                                      context.nav.pushNamed(
                                        Routes.recoverPassWordStageThree,
                                        arguments: {
                                          'token': forEmailorPhone??'',
                                          'otp': textEditingController.text??'',
                                        },
                                      );

                                    });
                                  });
                                  return MessageTextWidget(
                                    msg: S.of(context).scs,
                                  );
                                },
                                initial: (_) {
                                  return AppTextButton(
                                    x: 10,
                                    buttonColor: AppColors.primary,
                                    title: S.of(context).cnfirm,
                                    titleColor: AppColors.white,
                                    onTap: () {
                                      debugPrint(textEditingController.text);
                                      ref
                                          .watch(
                                            forgotPassOtpVerificationProvider
                                                .notifier,
                                          )
                                          .verifyOtp(
                                            forEmailorPhone,
                                            textEditingController.text,
                                          );
                                    },
                                  );
                                },
                                loading: (_) {
                                  return const LoadingWidget();
                                },
                              );
                            },
                          ),
                        ),




                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
