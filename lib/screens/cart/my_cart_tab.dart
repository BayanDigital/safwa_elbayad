import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/order_place_model/order_place_model.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/providers/order_update_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/cart/my_cart_with_image_card.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

class MyCartTab extends ConsumerWidget {
  MyCartTab({super.key});
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  final TextEditingController coupon = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = ref.watch(orderIdProvider);
    int? minimum;
    double? dlvrychrg;
    double? free;
    final List<CarItemHiveModel> cartItems = [];

    final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
    ref.watch(settingsProvider).whenOrNull(
      loaded: (data) {
        print("eeeeeeeeeee ${data.toJson()}");
        final String total = (AppGFunctions.calculateTotal(
                  cartItems,
                ) +
                data.data!.deliveryCost!)
            .toStringAsFixed(2);
        minimum = data.data!.minimumCost;
        dlvrychrg = data.data!.deliveryCost!.toDouble();

        free = data.data!.feeCost!.toDouble();
      },
    );
    ref.watch(couponProvider);
    ref.watch(discountAmountProvider);
    return SingleChildScrollView(
      child: SizedBox(
        height: 812.h,
        width: 375.w,
        child: Column(
          children: [
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
                            S.of(context).myCart,
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
                  valueListenable: Hive.box(AppHSC.authBox).listenable(),
                  builder: (BuildContext context, Box authbox, Widget? child) {
                    return authbox.get(AppHSC.authToken) != null
                        ? SizedBox(
                            height: 606.h,
                            width: 335.w,
                            child: ValueListenableBuilder(
                              valueListenable:
                                  Hive.box(AppHSC.cartBox).listenable(),
                              builder: (
                                BuildContext context,
                                Box cartBox,
                                Widget? child,
                              ) {
                                if (cartBox.isEmpty) return const SizedBox();

                                final List<CarItemHiveModel> cartItems = [];
                                for (var i = 0; i < cartBox.length; i++) {
                                  final Map<String, dynamic> processedData = {};
                                  final Map<dynamic, dynamic> unprocessedData =
                                      cartBox.getAt(i) as Map<dynamic, dynamic>;

                                  unprocessedData.forEach((key, value) {
                                    processedData[key.toString()] = value;
                                  });
                                  cartItems.add(
                                    CarItemHiveModel.fromMap(
                                      processedData,
                                    ),
                                  );
                                }

                                ref.watch(couponProvider).maybeWhen(
                                      orElse: () {},
                                      error: (_) {
                                        EasyLoading.showError(_);
                                        ref.refresh(couponProvider);
                                      },
                                      loaded: (_) {
                                        if (_.data?.coupon?.discount != null) {
                                          if (_.data!.coupon!.type!
                                                  .toLowerCase() ==
                                              "percent".toLowerCase()) {
                                            final double subToatalAmount =
                                                calculateTotal(
                                              cartItems,
                                            );
                                            Future.delayed(buildDuration)
                                                .then((value) {
                                              ref
                                                      .watch(
                                                        discountAmountProvider
                                                            .notifier,
                                                      )
                                                      .state =
                                                  subToatalAmount *
                                                      (_.data!.coupon!
                                                              .discount! /
                                                          100);
                                            });
                                          } else {
                                            Future.delayed(buildDuration)
                                                .then((value) {
                                              ref
                                                      .watch(
                                                        discountAmountProvider
                                                            .notifier,
                                                      )
                                                      .state =
                                                  _.data!.coupon!.discount!
                                                      .toDouble();
                                            });
                                          }
                                        }
                                      },
                                    );
                                return cartItems.isNotEmpty
                                    ? ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          ...cartItems.map(
                                            (e) => Column(
                                              children: [
                                                MyCartItemImageCard(
                                                  carItemHiveModel: e,
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppSpacerH(25.h),
                                          Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 6),
                                                  child: Text(
                                                    S.of(context).odrdsmry,
                                                    style: AppTextDecor
                                                        .osSemiBold16black
                                                        .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 6),
                                                  child: Table(
                                                    children: [
                                                      AppGFunctions
                                                          .tableTextRow(
                                                        title:
                                                            S.of(context).sbttl,
                                                        data:
                                                            '${appSettingsBox.get('currency') ?? '\$'}${calculateTotal(cartItems).toStringAsFixed(2)}',
                                                      ),
                                                      AppGFunctions
                                                          .tableTextRow(
                                                        title: S
                                                            .of(context)
                                                            .dlvrychrg,
                                                        data:
                                                            '${appSettingsBox.get('currency') ?? '\$'}${dlvrychrg?.toStringAsFixed(2)}',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        S.of(context).ttl,
                                                        style: AppTextDecor
                                                            .osBold14black
                                                            .copyWith(
                                                                color: AppColors
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8),
                                                    child: Text(
                                                      '${appSettingsBox.get('currency') ?? '\$'}${(AppGFunctions.calculateTotal(cartItems) + (dlvrychrg??0) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}',
                                                      style: AppTextDecor
                                                          .osBold14black
                                                          .copyWith(
                                                              color: AppColors
                                                                  .secondaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppSpacerH(25.h),
                                          Column(
                                            children: [
                                              Container(
                                                height: 104.h,
                                                width: 350.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: 350.w,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (calculateTotal(
                                                                  cartItems) <
                                                              200)
                                                            Text(
                                                              '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum??0)}',
                                                              style: AppTextDecor
                                                                  .osRegular12red,
                                                            ),
                                                          ref
                                                              .watch(
                                                                  updateOrderProvider)
                                                              .map(
                                                                initial: (_) {
                                                                  return orderId !=
                                                                          ''
                                                                      ? AppTextButton(
                                                                          height:
                                                                              45.h,
                                                                          width:
                                                                              300.w,
                                                                          title: S
                                                                              .of(context)
                                                                              .updateproduct,
                                                                          onTap:
                                                                              () {
                                                                            updateOrderProduct(
                                                                              ref: ref,
                                                                              orderId: orderId,
                                                                              cartItems: cartItems,
                                                                              context: context,
                                                                            );
                                                                          },
                                                                        )
                                                                      : Row(
                                                                          children: [
                                                                            Card(
                                                                              elevation: 5,
                                                                              child: Center(
                                                                                child: AppTextButton(
                                                                                  fontSize: 18,
                                                                                  title: S.of(context).chckout,
                                                                                  height: 45.h,
                                                                                  width: 320.w,
                                                                                  onTap: () {
                                                                                    final Box authBox = Hive.box(AppHSC.authBox);
                                                                                    final double total = calculateTotal(cartItems);

                                                                                    if (authBox.get(AppHSC.authToken) != null && authBox.get(AppHSC.authToken) != '') {
                                                                                      if (total >= 200) {
                                                                                        ref.refresh(addresListProvider);
                                                                                        context.nav.pushNamed(Routes.checkOutScreen);
                                                                                      } else {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              title: const Text('تنبيه'),
                                                                                              content: Text(
                                                                                                '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum??0)}',
                                                                                              ),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    context.nav.pushNamed(Routes.homeScreen);
                                                                                                  },
                                                                                                  child: const Text(' الرجاء زياده المنتجات '),
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      }
                                                                                    } else {
                                                                                      context.nav.pushNamed(Routes.loginScreen);
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                },
                                                                loading: (_) =>
                                                                    const LoadingWidget(),
                                                                loaded: (_) {
                                                                  print(
                                                                      'loaded');
                                                                  return const Text(
                                                                      '');
                                                                },
                                                                error: (_) {
                                                                  print(
                                                                      'error');
                                                                  return const Text(
                                                                      'error');
                                                                },
                                                              ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (orderId != '')
                                            AppSpacerH(20.h)
                                          else
                                            const SizedBox(),
                                          if (orderId != '')
                                            AppTextButton(
                                              height: 45.h,
                                              width: 164.w,
                                              title: S.of(context).addmore,
                                              onTap: () {
                                                ref
                                                    .watch(
                                                      homeScreenPageControllerProvider,
                                                    )
                                                    .animateToPage(
                                                      4,
                                                      duration:
                                                          transissionDuration,
                                                      curve: Curves.easeInOut,
                                                    );
                                                ref
                                                    .watch(
                                                      homeScreenIndexProvider
                                                          .notifier,
                                                    )
                                                    .state = 4;
                                              },
                                            )
                                          else
                                            const SizedBox(),
                                          AppSpacerH(90.h),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/images/no_cart.png"),
                                          AppSpacerH(50.h),
                                          MessageTextWidget(
                                            msg: S.of(context).noitmcrt,
                                          )
                                        ],
                                      );
                              },
                            ),
                          )
                        : const NotSignedInwidget();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateOrderProduct({
    required WidgetRef ref,
    required String orderId,
    required List<CarItemHiveModel> cartItems,
    required BuildContext context,
  }) {
    final List<OrderProductModel> products = [];
    final Box cartBox = Hive.box(AppHSC.cartBox);
    for (final cartItem in cartItems) {
      final OrderProductModel productModel = OrderProductModel(
        id: cartItem.productsId.toString(),
        quantity: cartItem.productsQTY.toString(),
      );
      products.add(productModel);
    }
    ref
        .read(
          orderRepoProvider,
        )
        .updateOrder(
          products,
          orderId,
        )
        .then((value) {
      EasyLoading.showSuccess(S.of(context).orderupdatesuccmes);
      ref.read(orderIdProvider.notifier).state = '';
      cartBox.clear();
      ref
          .watch(
            homeScreenIndexProvider.notifier,
          )
          .state = 1;
      ref
          .watch(
            homeScreenPageControllerProvider,
          )
          .animateToPage(
            1,
            duration: transissionDuration,
            curve: Curves.easeInOut,
          );
    });
  }

  double calculateTotal(List<CarItemHiveModel> cartItems) {
    double amount = 0;
    for (final element in cartItems) {
      if (element.subProduct != null) {
        amount += element.productsQTY *
            (element.unitPrice + element.subProduct!.price!);
      } else {
        amount += element.productsQTY * element.unitPrice;
      }
    }

    return amount;
  }
}

class NotSignedInwidget extends ConsumerWidget {
  const NotSignedInwidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/no_login.png'),
        AppSpacerH(20.h),
        Text(
          S.of(context).yourntsignedin,
          style: AppTextDecor.osSemiBold18black,
          textAlign: TextAlign.center,
        ),
        AppSpacerH(35.h),
        AppTextButton(
          width: 300,
          title: S.of(context).signUp,
          onTap: () {
            context.nav.pushNamed(Routes.loginScreen);
          },
        ),
      ],
    );
  }
}
