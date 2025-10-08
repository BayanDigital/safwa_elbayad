import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';

import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/products_model/product.dart';

import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/cart/my_cart_tab.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';

import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class ChooseItemCardDetails extends ConsumerWidget {
  const ChooseItemCardDetails({
    super.key,
    required this.product,
  });
  final ProductData product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    int? minimum;
    double? dlvrychrg;
    double? free;
    final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
    ref.watch(settingsProvider).whenOrNull(
      loaded: (data) {
        minimum = data.data!.minimumCost;
        dlvrychrg = data.data!.deliveryCost!.toDouble();
        free = data.data!.feeCost!.toDouble();
      },
    );
    return ScreenWrapper(

      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SizedBox(
            height: 812.h,
            width: 375.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100.h,
                    width: 375.w,
                    decoration: AppBoxDecorations.topBar,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.white,
                            height: 88.h,
                            width: 375.w,
                            child: Column(
                              children: [
                                AppSpacerH(44.h),
                                AppNavbar(
                          backButtionColor: AppColors.primary,
                          onBack: () {
                          context.nav.pop();},

                                  title: S.of(context).dproduct,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppColors.whiteLight,
                          ) ,

                        ],
                      ),
                    ),
                  ),
                  AppSpacerH(20.h),
                  Center(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return CustomCardDetails(
                          product: product,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CustomCardDetails extends StatefulWidget {
  final ProductData product;

  const CustomCardDetails({super.key, required this.product});

  @override
  State<CustomCardDetails> createState() => _CustomCardDetailsState();
}

class _CustomCardDetailsState extends State<CustomCardDetails> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSpacerH(50.h),
            Container(
              height: 130.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(product.imagePath!,),
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
            ),
            AppSpacerH(20.h),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        child: Text(
                          product.nameBn! as String,
                          style: AppTextDecor.osSemiBold16black.copyWith(fontSize: 15,fontWeight:FontWeight.w700 ),
                        ),
                      ),
                    Spacer(),
                      IncDecButton(
                        ontap: decreaseQuantity,
                        icon: Icons.remove,
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        '$quantity',
                        style: AppTextDecor.osBold20Black.copyWith(fontSize: 18),
                      ),
                      SizedBox(width: 20.w),
                      IncDecButton(
                        ontap: increaseQuantity,
                        icon: Icons.add,
                      ),
                    ],
                  ),
                  AppSpacerH(20.h),

                  Text(
                    '${(product.currentPrice! * quantity).toStringAsFixed(2)} جنيها',
                    style: AppTextDecor.osBold14black,
                  ),
                  AppSpacerH(20.h),
                  Text(
                    product.description ??' ',
                    style: AppTextDecor.osBold14black
                        .copyWith(color: AppColors.lightBlack),
                  ),

                  SizedBox(height:30.h),
                  AppTextButton(
                    buttonColor: AppColors.primary,
                    title: 'إضافة إلى السلة',
                    titleColor: AppColors.white,
                    onTap: () {
                      final cartBox = Hive.box(AppHSC.cartBox);

                      final newCartItem = CarItemHiveModel(
                        productsId: product.id!,
                        productsName:   product.nameBn! as String,
                        productsImage: product.imagePath!,
                        productsQTY: quantity,
                        unitPrice: product.currentPrice!.toDouble(),
                        serviceName: product.service!.name!,

                      );

                      bool itemExists = false;

                      for (int i = 0; i < cartBox.length; i++) {
                        final itemRaw = cartBox.getAt(i) as Map<dynamic, dynamic>;
                        final itemMap = itemRaw.map((key, value) => MapEntry(key.toString(), value));
                        final existingItem = CarItemHiveModel.fromMap(itemMap);

                        if (existingItem.productsId == newCartItem.productsId &&
                            existingItem.subproductsId == newCartItem.subproductsId) {
                          final updatedItem = existingItem.copyWith(
                            productsQTY: existingItem.productsQTY + newCartItem.productsQTY,
                          );
                          cartBox.putAt(i, updatedItem.toMap());
                          itemExists = true;
                          break;
                        }
                      }

                      if (!itemExists) {
                        cartBox.add(newCartItem.toMap());
                      }

                      context.nav.push(
                        MaterialPageRoute(
                          builder: (context) => MyCartTab(),
                        ),
                      );
                    },
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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




class IncDecButton extends StatelessWidget {
  const IncDecButton({
    super.key,
    required this.ontap,
    required this.icon,
  });
  final Function() ontap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,

          color: AppColors.gold,
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
