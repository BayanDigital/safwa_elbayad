import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/package_model/package_model.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/screens/order/payment_method_card.dart';
import 'package:laundry_customer/screens/packages/subscribe_section.dart';
import 'package:laundry_customer/screens/payment/payment_screen.dart'; 
import 'package:laundry_customer/screens/payment/schedule_picker_widget.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/button_with_icon.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class SubscribeScreen extends ConsumerStatefulWidget {
  const SubscribeScreen({
    super.key,
    this.package,
  });
  final Package? package;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubscribeScreenState();
}

class _SubscribeScreenState extends ConsumerState<SubscribeScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  final TextEditingController _instruction = TextEditingController();

  PaymentType selectedPaymentType = PaymentType.cod;

  String validationError({required String fieldName}) {
    return 'حقل $fieldName لا يمكن أن يكون فارغًا!';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            height: 812.h,
            width: 375.w,
            child: Column(children: [
              Container(
                color: const Color(0xFFF9F9F9),
                height: 88.h,
                width: 375.w,
                child: Column(
                  children: [
                    AppSpacerH(42.h),
                    Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.nav.pop();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            const AppSpacerW(10),
                            Text(
                              S.of(context).subPackage,
                              style: AppTextDecor.osSemiBold18black
                                  .copyWith(color: AppColors.primary),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      height: 724.h,
                      color: const Color(0xFFF9F9F9),
                      child: ValueListenableBuilder(
                          valueListenable:
                              Hive.box(AppHSC.authBox).listenable(),
                          builder: (BuildContext context, Box authbox,
                              Widget? child) {
                            return authbox.get(AppHSC.authToken) != null
                                ? SizedBox(
                                    height: 606.h,
                                    width: 335.w,
                                    child: SingleChildScrollView(
                                        child: FormBuilder(
                                            key: _formkey,
                                            // initialValue: widget.package != null
                                            //     ? widget.package!.toMap()
                                            //     : {},
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 375.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 335.w,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                S
                                                                    .of(context)
                                                                    .adrs,
                                                                style: AppTextDecor
                                                                    .osSemiBold18black
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        color: AppColors
                                                                            .primary),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  context.nav
                                                                      .pushNamed(
                                                                    Routes
                                                                        .manageAddressScreen,
                                                                  );
                                                                },
                                                                // ignore: use_decorated_box
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .grayBG,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.w),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            3.0),
                                                                    child: Text(
                                                                      S
                                                                          .of(context)
                                                                          .mngaddrs,
                                                                      style: AppTextDecor.osSemiBold18black.copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          color:
                                                                              AppColors.textColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        AppSpacerH(11.h),
                                                        ref
                                                            .watch(
                                                                addresListProvider)
                                                            .map(
                                                              initial: (_) =>
                                                                  const SizedBox(),
                                                              loading: (_) =>
                                                                  const LoadingWidget(),
                                                              loaded: (_) => _
                                                                      .data
                                                                      .data!
                                                                      .addresses!
                                                                      .isEmpty
                                                                  ? AppIconTextButton(
                                                                      buttonColor:
                                                                          const Color(
                                                                              0xFFF9F9F9),
                                                                      icon: Icons
                                                                          .add,
                                                                      titleColor:
                                                                          AppColors
                                                                              .textColor,
                                                                      title: S
                                                                          .of(context)
                                                                          .adadres,
                                                                      onTap:
                                                                          () {
                                                                        context
                                                                            .nav
                                                                            .pushNamed(
                                                                          Routes
                                                                              .addOrUpdateAddressScreen,
                                                                        );
                                                                      },
                                                                    )
                                                                  : FormBuilderDropdown(
                                                                      decoration: AppInputDecor
                                                                          .loginPageInputDecor
                                                                          .copyWith(
                                                                        hintText: S
                                                                            .of(context)
                                                                            .chsadrs,
                                                                      ),
                                                                      onChanged:
                                                                          (val) {
                                                                        ref
                                                                            .watch(
                                                                              addressIDProvider.notifier,
                                                                            )
                                                                            .state = val.toString();
                                                                      },
                                                                      name:
                                                                          'address',
                                                                      items: _
                                                                          .data
                                                                          .data!
                                                                          .addresses!
                                                                          .map(
                                                                            (e) =>
                                                                                DropdownMenuItem(
                                                                              value: e.id.toString(),
                                                                              child: Text(
                                                                                AppGFunctions.processAdAddess(
                                                                                  e,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                          .toList(),
                                                                    ),
                                                              error: (_) =>
                                                                  ErrorTextWidget(
                                                                      error: _
                                                                          .error),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 375.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .pymntmthd,
                                                          style: AppTextDecor
                                                              .osSemiBold18black
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: AppColors
                                                                      .primary),
                                                        ),
                                                        AppSpacerH(11.h),
                                                        PaymentMethodCard(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedPaymentType =
                                                                  PaymentType
                                                                      .cod;
                                                            });
                                                          },
                                                          imageLocation:
                                                              'assets/images/logo_cod.png',
                                                          title: S
                                                              .of(context)
                                                              .cshondlvry,
                                                          subtitle: S
                                                              .of(context)
                                                              .pywhndlvry,
                                                          isSelected:
                                                              selectedPaymentType ==
                                                                  PaymentType
                                                                      .cod,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 375.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .shpngschdl,
                                                          style: AppTextDecor
                                                              .osSemiBold18black
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: AppColors
                                                                      .primary),
                                                        ),
                                                        AppSpacerH(10.h),
                                                        Column(
                                                          children: [
                                                            ShedulePicker(
                                                              image:
                                                                  'assets/images/pickup-car.png',
                                                              title: S
                                                                  .of(context)
                                                                  .pickupat,
                                                            ),
                                                            AppSpacerH(20.h),
                                                            ShedulePicker(
                                                              image:
                                                                  'assets/images/pick-up-truck.png',
                                                              title: S
                                                                  .of(context)
                                                                  .dlvryat,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 375.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 20.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .instrctn,
                                                          style: AppTextDecor
                                                              .osSemiBold18black
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: AppColors
                                                                      .primary),
                                                        ),
                                                        AppSpacerH(11.h),
                                                        TextField(
                                                          controller:
                                                              _instruction,
                                                          decoration: AppInputDecor
                                                              .loginPageInputDecor
                                                              .copyWith(
                                                            hintText: S
                                                                .of(context)
                                                                .adinstrctnop,
                                                            hintStyle: AppTextDecor
                                                                .osSemiBold12black
                                                                .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: AppColors
                                                                        .textColor),
                                                          ),
                                                          maxLines: 3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SubscribeSection(
                                                    instruction: _instruction,
                                                    package: widget.package!,
                                                    selectedPaymentType:
                                                        selectedPaymentType,
                                                  ),
                                                ],
                                              ),
                                            ))))
                                : SizedBox();
                          })))
            ])));
  }
}
