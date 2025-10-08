import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

// ignore: must_be_immutable
class RecoverPasswordStageOne extends StatelessWidget {
  final FocusNode fNode = FocusNode();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formkey,
          child: SizedBox(
            height: 812.h,
            width: 375.w,
            child:
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20,vertical:8.0),                  child: Column(
                    children: [
                      AppSpacerH(20.h),
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            context.nav.pop();
                          }, icon: const Icon(Icons.arrow_back,color: AppColors.primary,)),
                          Text(S.of(context).forgotpassword,style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                          ),),
                        ],
                      ),
                        AppSpacerH(150.h),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  'assets/images/forgotPassword.png',
                                  width: 200,

                                ),
                              ),
                            ),
                            AppSpacerH(20.h),
                            FormBuilderTextField(
                              focusNode: fNode,
                              name: 'email',
                              decoration: AppInputDecor.loginPageInputDecor.copyWith(
                                hintText: S.of(context).email,
                              ),
                              textInputAction: TextInputAction.done,
                              validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()],
                              ),
                            ),
                            AppSpacerH(20.h),
                            SizedBox(
                              height: 50.h,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return ref.watch(forgotPassProvider).map(
                                        initial: (_) => AppTextButton(
                                          fontSize: 18,
                                          x: 10,
                                          buttonColor: AppColors.primary,
                                          title: S.of(context).sndotp,
                                          titleColor: AppColors.white,
                                          onTap: () {
                                            if (fNode.hasFocus) {
                                              fNode.unfocus();
                                            }

                                            if (_formkey.currentState != null &&
                                                _formkey.currentState!
                                                    .saveAndValidate()) {
                                              final formData =
                                                  _formkey.currentState!.fields;
                                              email =
                                                  formData['email']!.value as String;
                                              ref
                                                  .watch(forgotPassProvider.notifier)
                                                  .forgotPassword(
                                                    email,
                                                  );
                                            }
                                          },
                                        ),
                                        error: (_) {
                                          Future.delayed(transissionDuration)
                                              .then((value) {
                                            ref.refresh(forgotPassProvider);
                                          });
                                          return ErrorTextWidget(error: _.error);
                                        },
                                        loaded: (_) {
                                          Future.delayed(transissionDuration)
                                              .then((value) {
                                            ref.refresh(
                                              forgotPassProvider,
                                            ); //Refresh This so That App Doesn't Auto Login
                                            ref
                                                .watch(
                                                  forgotPassTimerProvider.notifier,
                                                )
                                                .startTimer();

                                            Future.delayed(buildDuration)
                                                .then((value) {
                                              context.nav.pushNamed(
                                                Routes.recoverPassWordStageTwo,
                                                arguments: email,
                                              );
                                            });
                                          });
                                          return MessageTextWidget(
                                            msg: S.of(context).scs,
                                          );
                                        },
                                        loading: (_) => const LoadingWidget(),
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
          ),
    );
  }
}
