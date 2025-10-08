import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen_wrapper.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  final TextEditingController textEditingController = TextEditingController();
  bool obsecureText = true;

  @override
  void initState() {
    super.initState();
    for (final element in fNodes) {
      if (element.hasFocus) {
        element.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: FormBuilder(
                  key: _formkey,
                  child: Column(
                    children: [


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical:8.0),
                          child: Column(
                            children: [
                              AppSpacerH(50.h),
                              Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  'assets/images/logoApp.png',
                                  width: 200,

                                ),
                              ),
                              AppSpacerH(20.h),
                              Text(
                                S.of(context).login,
                                style: AppTextDecor.osBold20Black.copyWith(
                                  color: AppColors.primary
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'ادخل لحسابك وتابع طلباتك',
                                style: AppTextDecor.osSemiBold14black.copyWith(
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              SizedBox(height: 70.h),
                              FormBuilderTextField(
                                controller: textEditingController,
                                focusNode: fNodes[0],
                                name: 'email',
                                decoration: AppInputDecor.loginPageInputDecor.copyWith(
                                  hintText: S.of(context).email,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (RegExp('[a-zA-Z]').hasMatch(value)) {
                                      if (FormBuilderValidators.email()(value) != null) {
                                        return 'Invalid email address';
                                      }
                                    } else if (int.tryParse(value) == null) {
                                      return 'Invalid input';
                                    } else if (value.length < 6 || value.length > 11) {
                                      return 'Number must be between 6 and 11 characters long';
                                    }
                                  } else {
                                    return "This field cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              FormBuilderTextField(

                                focusNode: fNodes[1],
                                name: 'password',
                                obscureText: obsecureText,
                                decoration: AppInputDecor.loginPageInputDecor.copyWith(
                                  hintText: S.of(context).password,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obsecureText = !obsecureText;
                                      });
                                    },
                                    child: Icon(
                                      obsecureText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility,
                                      color: AppColors.lightgray,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    context.nav.pushNamed(Routes.recoverPassWordStageOne);
                                  },
                                  child: Text(
                                    S.of(context).forgotPassword,

                                    style: AppTextDecor.osRegular14black.copyWith(color: AppColors.primary,fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),
                              Consumer(
                                builder: (context, WidgetRef ref, child) {
                                  return ref.watch(loginProvider).map(
                                    error: (_) {
                                      Future.delayed(transissionDuration).then((value) {
                                        ref.refresh(loginProvider);
                                      });
                                      return ErrorTextWidget(error: _.error);
                                    },
                                    loaded: (_) {
                                      final Box box = Hive.box(AppHSC.authBox);
                                      final Box userBox = Hive.box(AppHSC.userBox);
                                      box.putAll(_.data.data!.access!.toMap());
                                      userBox.putAll(_.data.data!.user!.toMap());
                                      Future.delayed(transissionDuration).then((value) {
                                        ref.refresh(loginProvider);
                                        ref.refresh(profileInfoProvider);
                                        ref.refresh(addresListProvider);
                                        Future.delayed(buildDuration).then((value) {
                                          context.nav.pushNamedAndRemoveUntil(
                                            Routes.homeScreen,
                                                (route) => false,
                                          );
                                        });
                                      });
                                      return MessageTextWidget(msg: S.of(context).scs);
                                    },
                                    initial: (_) =>
                                        AppTextButton(
                                          fontSize: 18,
                                      x: 10,
                                      height: 50.h,
                                      buttonColor: AppColors.primary,
                                      title: S.of(context).login,
                                      titleColor: AppColors.white,
                                      onTap: () {
                                        for (final element in fNodes) {
                                          if (element.hasFocus) {
                                            element.unfocus();
                                          }
                                        }
                                        if (_formkey.currentState != null &&
                                            _formkey.currentState!.saveAndValidate()) {
                                          final formData = _formkey.currentState!.fields;
                                          ref.watch(loginProvider.notifier).login(
                                            formData['email']!.value as String,
                                            formData['password']!.value as String,
                                          );
                                        }
                                      },
                                    ),
                                    loading: (_) => const LoadingWidget(),
                                  );
                                },
                              ),
                              AppSpacerH(30.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${S.of(context).dontHaveAccount} ",
                                    style: AppTextDecor.osRegular14black.copyWith(
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.nav.pushNamed(Routes.signUpScreen);
                                    },
                                    child: Text(
                                      S.of(context).signUp,
                                      style: AppTextDecor.osBold14gold.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacerH(20.h),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );


  }
}
