import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/order_place_model/order_place_model.dart';
import 'package:laundry_customer/models/package_model/package_model.dart';
import 'package:laundry_customer/models/package_model/package_place_model.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/providers/packege_providers.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/payment/payment_screen.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

// ignore: must_be_immutable
class SubscribeSection extends ConsumerStatefulWidget {
  const SubscribeSection({
    super.key,
    required this.instruction,
    required this.selectedPaymentType,
    required this.package,
  });
  final TextEditingController instruction;
  final PaymentType selectedPaymentType;
  final Package package;
  @override
  ConsumerState<SubscribeSection> createState() => _SubscribeSectionState();
}

class _SubscribeSectionState extends ConsumerState<SubscribeSection> {
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);

  bool isMakingPayment = false;

  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
   
        return Container(
          width: 375.w,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 25.h,
          ),
          child: SizedBox(
            // height: 70.h,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(placePackagesProvider).map(
                      initial: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 350,
                            child: Card(
                              elevation: 5,
                              color: const Color(0xFFF9F9F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).ttlpybl,
                                      style: AppTextDecor.osSemiBold14black
                                          .copyWith(
                                              color: AppColors.primary,
                                              fontSize: 14),
                                    ),
                                    AppSpacerH(10.h),

                                    Text(' ${widget.package.name ?? ''}',
                                        style:
                                            AppTextDecor.osBold14black.copyWith(
                                          color: AppColors.secondaryColor,
                                          fontSize: 14,
                                        )),
                                    Text(
                                        '${appSettingsBox.get('currency') ?? '\$'}${widget.package.price ?? '0'}',
                                        style:
                                            AppTextDecor.osBold14black.copyWith(
                                          color: AppColors.secondaryColor,
                                          fontSize: 14,
                                        )),

                                    // Text(
                                    //   '${appSettingsBox.get('currency') ?? '\$'}${(calculateTotal(cartItems) + dlvrychrg! - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                    //   style: AppTextDecor.osSemiBold18black,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (isMakingPayment)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: AppTextButton(
                                fontSize: 18,
                                title: S.of(context).pynw,
                                onTap: () async {
                                  final DateFormat formatter = DateFormat(
                                    'yyyy-MM-dd',
                                  );
                                  final isPackageProcessing =
                                      ref.watch(packageProcessingProvider);

                                  if (!isPackageProcessing) {
                                    ref
                                        .watch(
                                          packageProcessingProvider.notifier,
                                        )
                                        .state = false;
                                    final pickUp = ref.watch(
                                      scheduleProvider('Pick Up'),
                                    );
                                    final delivery = ref.watch(
                                      scheduleProvider(
                                        'Delivery',
                                      ),
                                    );
                                    final address = ref.watch(
                                      addressIDProvider,
                                    );

                                    //Cheks All Reguired Data Is AvailAble
                                    if (pickUp != null &&
                                        delivery != null &&
                                        address != '') {
                                      //Has All Data
                                      final Box userBox =
                                          Hive.box(AppHSC.userBox);
                                      final userId = userBox.get('id') as int?;

                                      if (userId == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'فشل في جلب بيانات المستخدم')),
                                        );
                                        return;
                                      }
                                      print(widget.package.id.toString());
                                      final data = PackagePlaceModel(
                                        address_id: address,
                                        user_id: userId.toString(),
                                        pick_date:
                                            "${pickUp.dateTime.year}-${pickUp.dateTime.month}-${pickUp.dateTime.day}",
                                        pick_hour:
                                            pickUp.schedule.hour.toString(),
                                        delivery_date:
                                            "${delivery.dateTime.year}-${delivery.dateTime.month}-${delivery.dateTime.day}",
                                        delivery_hour:
                                            delivery.schedule.hour.toString(),
                                        package_id:
                                            widget.package.id.toString(),
                                        instruction: widget.instruction.text,
                                        additional_service_id: [],
                                      );
                                      print(data.toMap());
                                      await ref
                                          .watch(
                                            placePackagesProvider.notifier,
                                          )
                                          .addPackege(data);
                                    } else {
                                      //Missing Data
                                      EasyLoading.showError(
                                        S.of(context).plsslctalflds,
                                      );
                                    }
                                    ref
                                        .watch(orderProcessingProvider.notifier)
                                        .state = false;
                                  } else {
                                    EasyLoading.showError(
                                      S.of(context).wrprcsngprvsdlvry,
                                    );
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        final String amount = widget.package.price ?? '0';

                        Future.delayed(buildDuration).then((value) async {
                          // EasyLoading.showSuccess(
                          //   S.of(context).ordrplcd,
                          // );

                          ref.refresh(placePackagesProvider);
                          ref
                              .watch(
                                dateProvider('Pick Up').notifier,
                              )
                              .state = null;
                          ref
                              .watch(
                                dateProvider('Delivery').notifier,
                              )
                              .state = null;
                          // context.nav.pushNamedAndRemoveUntil(
                          //   Routes.orderSuccessScreen,
                          //   arguments: {
                          //     'id': _.data.data!.order!.orderCode,
                          //     'amount': amount,
                          //     'couponID': couponID.toString(),
                          //     'isCOD': selectedPaymentType == PaymentType.cod
                          //   },
                          //   (route) => false,
                          // );

                          if (widget.selectedPaymentType == PaymentType.cod ||
                              isPaid) {
                            context.nav.pushNamedAndRemoveUntil(
                              Routes.orderSuccessScreen,
                              arguments: {
                                'id': widget.package.name,
                                'amount': amount,
                                'isCOD': widget.selectedPaymentType ==
                                    PaymentType.cod,
                              },
                              (route) => false,
                            );
                          } else {
                            if (!isMakingPayment) {
                              isMakingPayment = true;
                              // final PaymentController pay = PaymentController();
                              //
                              // isPaid = await pay.makePayment(
                              //   amount: amount,
                              //   currency: 'GBP',
                              //   couponID: couponID.toString(),
                              //   orderID: _.data.data!.order!.orderCode!,
                              // );

                              isMakingPayment = false;
                              setState(() {});

                              if (isPaid) {
                                context.nav.pushNamedAndRemoveUntil(
                                  Routes.orderSuccessScreen,
                                  arguments: {
                                    'id': widget.package.name,
                                    'amount': amount,
                                    'isCOD': widget.selectedPaymentType ==
                                        PaymentType.cod,
                                    "isPaidOnline": true,
                                  },
                                  (route) => false,
                                );
                              } else {
                                context.nav.pushNamedAndRemoveUntil(
                                  Routes.orderSuccessScreen,
                                  arguments: {
                                    'id': widget.package.name,
                                    'amount': amount,
                                    'isCOD': widget.selectedPaymentType ==
                                        PaymentType.cod,
                                    "isPaidOnline": false,
                                  },
                                  (route) => false,
                                );
                              }
                            }
                            print("Paid : $isPaid");
                          }
                        });
                        return MessageTextWidget(
                          msg: S.of(context).ordrplcd,
                        );
                        // return Text("Text");
                      },
                      error: (_) {
                        Future.delayed(
                          const Duration(seconds: 2),
                        ).then((value) {
                          ref.refresh(placePackagesProvider);
                        });
                        return ErrorTextWidget(
                          error: _.error,
                        );
                      },
                    );
              },
            ),
          ),
        );
      
  }
}
