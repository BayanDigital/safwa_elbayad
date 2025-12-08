import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/models/all_service_model/service.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/products_model/product.dart';
import 'package:laundry_customer/models/variations_model/variant.dart';
import 'package:laundry_customer/notfiers/guest_notfiers.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/order_update_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/homePage/choose_items.dart';
import 'package:laundry_customer/screens/homePage/subProductBottomSheet/sub_product_bottom_sheet.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/bouquet_card.dart';
import 'package:laundry_customer/widgets/buttons/cart_item_inc_dec_button.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class BestSellerDetails extends ConsumerWidget {
  const BestSellerDetails({
    super.key,
    required this.product,
  });
  final TopSellingItem product;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100.h,
                  width: 400.w,
                  decoration: AppBoxDecorations.topBar,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      AppSpacerH(44.h),
                      AppNavbar(
                        backButtionColor: AppColors.primary,
                        onBack: () {
                          context.nav.pop();
                        },
                      ),
                    ],
                  ),
                ),
                AppSpacerH(20.h),
                Container(
                  height: 270.h,
                  width: 200.w,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return ChooseItemCard(
                        product: product,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Builder(
              builder: (context) {
                return ValueListenableBuilder(
                  valueListenable: Hive.box(AppHSC.cartBox).listenable(),
                  builder: (
                      BuildContext context,
                      Box cartBox,
                      Widget? child,
                      ) {
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

                    return Container(
                      height: 104.h,
                      width: 375.w,
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).ttl,
                                style: AppTextDecor.osSemiBold18black,
                              ),
                              Text(
                                '${appSettingsBox.get('currency') ?? '\$'}${calculateTotal(cartItems).toStringAsFixed(2)}',
                                style: AppTextDecor.osSemiBold18black,
                              ),
                              if (AppGFunctions.calculateTotal(
                                cartItems,
                              ).toInt() <
                                  free!) ...[
                                Text(
                                  'Delivery Charge is ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(dlvrychrg!)}',
                                  style: AppTextDecor.osRegular12black,
                                ),
                              ] else ...[
                                Text(
                                  'Delivery Charge is ${appSettingsBox.get('currency') ?? '\$'}0.00',
                                  style: AppTextDecor.osRegular12black,
                                ),
                              ],
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (calculateTotal(cartItems) < (minimum??0))
                                Text(
                                  '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum??0)}',
                                  style: AppTextDecor.osRegular12red,
                                ),
                              AppSpacerH(5.h),
                              if (ref.read(orderIdProvider) != '')
                                AppTextButton(
                                  height: 45.h,
                                  width: 164.w,
                                  title: 'Done',
                                  onTap: () {
                                    context.nav.pop();
                                    ref
                                        .watch(
                                      homeScreenIndexProvider.notifier,
                                    )
                                        .state = 0;
                                    ref
                                        .watch(
                                      homeScreenPageControllerProvider,
                                    )
                                        .animateToPage(
                                      0,
                                      duration: transissionDuration,
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                )
                              else
                                AppTextButton(
                                  title: S.of(context).ordrnow,
                                  height: 45.h,
                                  width: 164.w,
                                  onTap: () {
                                    final Box authBox = Hive.box(
                                      AppHSC.authBox,
                                    ); //Stores Auth Data

                                    if (authBox.get(AppHSC.authToken) != null &&
                                        authBox.get(AppHSC.authToken) != '') {
                                      if (calculateTotal(cartItems) >=
                                          (minimum??0)) {
                                        ref.refresh(
                                          addresListProvider,
                                        );
                                        context.nav.pushNamed(
                                          Routes.checkOutScreen,
                                        );
                                      } else {
                                        EasyLoading.showError(
                                          '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum??0)}',
                                        );
                                      }
                                    } else {
                                      context.nav.pushNamed(Routes.loginScreen);
                                    }
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showProductBottomSheet(BuildContext context, TopSellingItem product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ProductBottomSheet(product: product);
    },
  );
}

class ProductBottomSheet extends StatefulWidget {
  final TopSellingItem product;

  const ProductBottomSheet({super.key, required this.product});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
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

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://rehana.maher.website/${product.image}',),
                  ),
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(
                      product.name!,
                      style: AppTextDecor.osBold16black,
                    ),

                    SizedBox(height: 15.h),
                    Text(
                      'سعر الباقه',
                      style: AppTextDecor.osBold16black,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(product.price * quantity).toStringAsFixed(2)} جنيها',
                          style: AppTextDecor.osBold14black,
                        ),
                        SizedBox(width: 100.w),
                        IncDecButton(
                          ontap: decreaseQuantity,
                          icon: Icons.remove,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          '$quantity',
                          style: AppTextDecor.osBold16black,
                        ),
                        SizedBox(width: 20.w),
                        IncDecButton(
                          ontap: increaseQuantity,
                          icon: Icons.add,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    AppTextButton(
                      buttonColor: AppColors.primary,
                      title: 'إضافة إلى السلة',
                      titleColor: AppColors.white,
                      onTap: () {
                        final newCartItem = CarItemHiveModel(
                          productsId: product.id!,
                          productsName: product.name!,
                          productsImage: 'https://rehana.maher.website/${product.image}',
                          productsQTY: quantity,
                          unitPrice: product.price.toDouble(),
                          serviceName: product.name!,
                        );
                        Hive.box(AppHSC.cartBox).add(newCartItem.toMap());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class ChooseItemCard extends StatefulWidget {
  const ChooseItemCard({
    super.key,
    required this.product,
  });

  final TopSellingItem product;

  @override
  State<ChooseItemCard> createState() => _ChooseItemCardState();
}

class _ChooseItemCardState extends State<ChooseItemCard> {
  bool inCart = false;
  int? keyAt;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
      builder: (context, Box settingsBox, _) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.cartBox).listenable(),
          builder: (context, Box cartsBox, _) {
            inCart = false;
            for (int i = 0; i < cartsBox.length; i++) {
              final Map<String, dynamic> processedData = {};
              final Map<dynamic, dynamic> unprocessedData =
              cartsBox.getAt(i) as Map<dynamic, dynamic>;
              unprocessedData.forEach((key, value) {
                processedData[key.toString()] = value;
              });
              final data = CarItemHiveModel.fromMap(processedData);
              keyAt = i;
              if (data.productsId == widget.product.id &&
                  data.productsName == widget.product.name) {
                inCart = true;
                break;
              }
            }

            return Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    Padding(
                      padding: const EdgeInsets.only(right: 30, top: 10),
                      child: Image.network(
                        'https://rehana.maher.website/${widget.product.image}',
                        height: 80.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      getLng(
                        en: widget.product.name,
                        changeLang: widget.product.name.toString(),
                      ),
                      style: AppTextDecor.osBold14black,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${widget.product.price} جنيها',
                      style: AppTextDecor.osBold14black,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          "${widget.product.totalRevenue} جنيها",
                          style: AppTextDecor.osSemiBold12black,
                        ),
                        AppSpacerW(7.w),
                        Text(
                          "${_calculateDiscount()}%",
                          style: AppTextDecor.osSemiBold12black.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (inCart) {
                            // إذا كان المنتج موجود في السلة، يمكنك عرض رسالة أو تحديث الكمية
                            EasyLoading.showInfo(
                                'المنتج موجود بالفعل في السلة');
                          } else {
                            _showProductBottomSheet(context, widget.product);
                          }
                        },
                        icon: Icon(
                          inCart ? Icons.check : Icons.add,
                          color: inCart ? Colors.green : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  String _calculateDiscount() {
    final double discount =
        ((widget.product.totalRevenue - widget.product.price) /widget.product.totalRevenue) * 100;
    return discount.toStringAsFixed(0);
  }
}


