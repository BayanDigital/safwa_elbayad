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

class RecoverPasswordStageThree extends StatefulWidget {
  const RecoverPasswordStageThree({super.key, required this.token, required this.otp});

  @override
  State<RecoverPasswordStageThree> createState() =>
      _RecoverPasswordStageThreeState();

  final String token;
  final String otp ;
}

class _RecoverPasswordStageThreeState extends State<RecoverPasswordStageThree> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  bool obsecureTextOne = true;
  bool obsecureTextTwo = true;

  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

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
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          'assets/images/pass.png',
                          width: 200,

                        ),
                      ),
                    ),
                    AppSpacerH(20.h),

                    Expanded(
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            focusNode: fNodes[0],
                            name: 'password',
                            obscureText: obsecureTextOne,
                            decoration: AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).password,

                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                          ),
                          AppSpacerH(20.h),
                          FormBuilderTextField(
                            focusNode: fNodes[1],
                            name: 'password2',
                            obscureText: obsecureTextTwo,
                            decoration: AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).pswrdagn,

                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                          ),
                          AppSpacerH(31.h),
                          SizedBox(
                            height: 50.h,
                            child: Consumer(
                              builder: (context, ref, child) {
                                return ref.watch(forgotPassResetPassProvider).map(
                                  error: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((value) {
                                      ref.refresh(forgotPassResetPassProvider);
                                    });
                                    return ErrorTextWidget(error: _.error);
                                  },
                                  initial: (_) {
                                    return AppTextButton(
                                      x:10,
                                      buttonColor: AppColors.primary,
                                      title: S.of(context).cnfirm,
                                      titleColor: AppColors.white,
                                      onTap: () {
                                        for (final element in fNodes) {
                                          if (element.hasFocus) {
                                            element.unfocus();
                                          }
                                        }

                                        if (_formkey.currentState != null &&
                                            _formkey.currentState!
                                                .saveAndValidate()) {
                                          final formData =
                                              _formkey.currentState!.fields;
                                          ref
                                              .watch(
                                                forgotPassResetPassProvider
                                                    .notifier,
                                              )
                                              .resetPassword(
                                                formData['password']!.value
                                                    as String,
                                                formData['password2']!.value
                                                    as String,
                                                widget.token,
                                                 widget.otp,
                                              );
                                        }
                                      },
                                    );
                                  },
                                  loaded: (_) {
                                    Future.delayed(transissionDuration)
                                        .then((value) {
                                      ref.refresh(
                                        forgotPassResetPassProvider,
                                      ); //Refresh This so That App Doesn't Auto Login

                                      Future.delayed(buildDuration).then((value) {
                                        context.nav.pushNamedAndRemoveUntil(
                                          Routes.loginScreen,
                                          (route) => false,
                                        );
                                      });
                                    });
                                    return MessageTextWidget(
                                      msg: S.of(context).scs,
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
        ),
      );
  }
}
