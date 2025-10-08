import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/addres_list_model/address.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class AddOrEditAddress extends ConsumerStatefulWidget {
  const AddOrEditAddress({
    super.key,
    this.address,
  });
  final Address? address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddOrEditAddressState();
}

class _AddOrEditAddressState extends ConsumerState<AddOrEditAddress> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  List postCodelist = [];
  bool isMatchFound = false;

  void postCodeValidation({required String postCode}) {
    isMatchFound = false;
    for (final e in postCodelist) {
      final code = e.toString().toLowerCase().replaceAll(' ', '');
      final int lenghtToCompare = code.length;

      if (code == postCode) {
        setState(() {
          isMatchFound = true;
        });
      } else if (postCode.length > 3 &&
          code.substring(0, lenghtToCompare) == postCode.substring(0, lenghtToCompare)) {
        setState(() {
          isMatchFound = true;
        });
      }
    }
    if (isMatchFound) {
      ref.watch(addAddresProvider.notifier).addAddress(
        address: _formkey.currentState!.value,
      ).then((value) {
        setState(() {
          isMatchFound = false;
        });
      });
    } else {
      EasyLoading.showError("الخدمة غير متوفرة في منطقتك");
    }
  }

  String validationError({required String fieldName}) {
    return 'حقل $fieldName لا يمكن أن يكون فارغًا!';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addAddresProvider);
    ref.watch(updateAddresProvider);
    ref.watch(settingsProvider).maybeWhen(
      orElse: () {},
      loaded: (_) {
        postCodelist = _.data?.postCode ?? [];
      },
    );

    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        child: Column(
          children: [
            Container(
              height: 108.h,
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
                          Text(  widget.address == null ? 'إضافة عنوان' : 'تحديث العنوان',style: AppTextDecor.osBold20white
                              .copyWith(fontSize: 18, color: AppColors.primary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]


                    ),

                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formkey,
                  initialValue: widget.address != null ? widget.address!.toMap() : {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'address_name',
                          decoration: AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "اسم الشارع ",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: validationError(fieldName: 'اسم الشارع'),
                            ),
                          ]),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'address_line',
                          decoration: AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "رقم العماره",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: validationError(fieldName: 'رقم العماره'),
                            ),
                          ]),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: "address_line2",
                          decoration: AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "رقم الشقه",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'area',
                          decoration: AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "المنطقة ",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: validationError(fieldName: 'المنطقة'),
                            ),
                          ]),
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          cursorColor: AppColors.primary,
                          name: 'post_code',
                          decoration: AppInputDecor.loginPageInputDecor.copyWith(
                            hintText: "الرمز البريدي",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: validationError(fieldName: 'الرمز البريدي'),
                            ),
                          ]),
                        ),
                        AppSpacerH(300.h),
                        if (widget.address == null)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 18,
                            child: ref.watch(addAddresProvider).map(
                              initial: (_) => AppTextButton(
                                title: 'إضافة عنوان',
                                onTap: () {
                                  if (_formkey.currentState!.saveAndValidate()) {
                                    ref.watch(addAddresProvider.notifier).addAddress(
                                      address: _formkey.currentState!.value,
                                    );
                                  }
                                },
                              ),
                              loading: (_) => const LoadingWidget(),
                              loaded: (_) {
                                Future.delayed(transissionDuration).then((value) {
                                  ref.refresh(updateAddresProvider);
                                  ref.refresh(addresListProvider);
                                  ref.refresh(addAddresProvider);
                                  Future.delayed(transissionDuration).then((value) {
                                    context.nav.pop();
                                  });
                                });
                                return const MessageTextWidget(msg: 'تم بنجاح');
                              },
                              error: (_) {
                                Future.delayed(transissionDuration).then((_) {
                                  ref.refresh(addAddresProvider);
                                  ref.refresh(updateAddresProvider);
                                  ref.refresh(addresListProvider);
                                });
                                return ErrorTextWidget(error: _.error);
                              },
                            ),
                          )
                        else
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 18,
                            child: ref.watch(updateAddresProvider).map(
                              initial: (_) => AppTextButton(
                                title: 'تحديث العنوان',
                                onTap: () {
                                  if (_formkey.currentState!.saveAndValidate()) {
                                    ref.watch(updateAddresProvider.notifier).updateAddress(
                                      address: _formkey.currentState!.value,
                                      addressID: widget.address!.id!.toString(),
                                    );
                                  }
                                },
                              ),
                              loading: (_) => const LoadingWidget(),
                              loaded: (_) {
                                Future.delayed(transissionDuration).then((value) {
                                  ref.refresh(updateAddresProvider);
                                  ref.refresh(addresListProvider);
                                  ref.refresh(addAddresProvider);
                                  Future.delayed(transissionDuration).then((value) {
                                    context.nav.pop();
                                  });
                                });
                                return const MessageTextWidget(msg: 'تم بنجاح');
                              },
                              error: (_) {
                                Future.delayed(transissionDuration).then((_) {
                                  ref.refresh(addAddresProvider);
                                  ref.refresh(updateAddresProvider);
                                  ref.refresh(addresListProvider);
                                });
                                return ErrorTextWidget(error: _.error);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
