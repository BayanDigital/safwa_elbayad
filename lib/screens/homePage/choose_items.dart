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
import 'package:laundry_customer/screens/cart/my_cart_tab.dart';
import 'package:laundry_customer/screens/homePage/fav.dart';
import 'package:laundry_customer/screens/homePage/item_details.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class ChooseItems extends ConsumerWidget {
  const ChooseItems({
    super.key,
    required this.service,
    required this.variant,
  });
  final Service service;
  final String variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(servicesVariationsProvider(service.id.toString()));
    final ProducServiceVariavtionDataModel productFilter =
        ref.watch(productsFilterProvider);
    if (productFilter.servieID == '') {
      Future.delayed(buildDuration).then((value) {
        ref.watch(productsFilterProvider.notifier).update((state) {
          return state.copyWith(servieID: service.id!.toString());
        });
      });
    }

    if (productFilter.variationID == '') {
      ref
          .watch(
            servicesVariationsProvider(service.id.toString()),
          )
          .maybeWhen(
            orElse: () {},
            loaded: (_) {
              Future.delayed(buildDuration).then((value) {
                ref.watch(productsFilterProvider.notifier).update((state) {
                  final List<Variant> variations = _.data!.variants!;
                  variations.sort(
                    (a, b) => a.id!.compareTo(b.id!),
                  );
                  return state.copyWith(
                    variationID: variations.first.id!.toString(),
                  );
                });
              });
            },
          );
    }

    ref.watch(productsProvider);

    final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    int? minimum;
    double? dlvrychrg;
    double? free;
    ref.watch(settingsProvider).whenOrNull(
      loaded: (data) {
        minimum = data.data!.minimumCost;
        dlvrychrg = data.data!.deliveryCost!.toDouble();
        free = data.data!.feeCost!.toDouble();
      },
    );
    return WillPopScope(
      onWillPop: () {
        ref.watch(productsFilterProvider.notifier).state =
            ProducServiceVariavtionDataModel(servieID: '', variationID: '');
        return Future.value(true);
      },
      child: ScreenWrapper(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100.h,
                    width: 375.w,
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Column(
                      children: [
                        AppSpacerH(44.h),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 25.0, bottom: 20),
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
                                variant,
                                style: AppTextDecor.osSemiBold18black.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return ref
                          .watch(
                            productsProvider,
                          )
                          .map(
                            initial: (_) => const SizedBox(),
                            loading: (_) => const LoadingWidget(),
                            loaded: (_) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _.data.data!.products!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final ProductData product =
                                      _.data.data!.products![index];
                                  return ChooseItemCard(
                                    product: product,
                                  );
                                },
                              ),
                            ),
                            error: (_) => ErrorTextWidget(error: _.error),
                          );
                    },
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
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
                        height: 100.h,
                        width: 375.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
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
                                  style: AppTextDecor.osSemiBold16black
                                      .copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '${appSettingsBox.get('currency') ?? '\$'}${calculateTotal(cartItems).toStringAsFixed(2)}',
                                  style: AppTextDecor.osSemiBold16black
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                ),
                                if (AppGFunctions.calculateTotal(
                                      cartItems,
                                    ).toInt() <
                                    free!) ...[
                                  /*Text(
                                    'Delivery Charge is $dlvrychrg',
                                    style: AppTextDecor.osRegular14black,
                                  ),
                                ] else ...[
                                  Text(
                                    'Delivery Charge is$dlvrychrg ',
                                    style: AppTextDecor.osRegular14black,
                                  ),*/
                                ],
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (calculateTotal(cartItems) < minimum!)
                                  Text(
                                    '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum!)}',
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

                                      if (authBox.get(AppHSC.authToken) !=
                                              null &&
                                          authBox.get(AppHSC.authToken) != '') {
                                        if (calculateTotal(cartItems) >=
                                            minimum!) {
                                          ref.refresh(
                                            addresListProvider,
                                          );
                                          context.nav.pushNamed(
                                            Routes.checkOutScreen,
                                          );
                                        } else {
                                          EasyLoading.showError(
                                            '${S.of(context).mnmmordramnt} ${appSettingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(minimum!)}',
                                          );
                                        }
                                      } else {
                                        context.nav
                                            .pushNamed(Routes.loginScreen);
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

class ChooseItemCard extends ConsumerStatefulWidget {
  const ChooseItemCard({
    super.key,
    required this.product,
  });

  final ProductData product;

  @override
  ConsumerState<ChooseItemCard> createState() => _ChooseItemCardState();
}

class _ChooseItemCardState extends ConsumerState<ChooseItemCard> {
  bool inCart = false;
  int quantity = 1;
  int? keyAt;
  void toCart() {
    final cartBox = Hive.box(AppHSC.cartBox);

    final newCartItem = CarItemHiveModel(
      productsId: widget.product.id!,
      productsName: widget.product.nameBn.toString(),
      productsImage: widget.product.imagePath!,
      productsQTY: quantity,
      unitPrice: widget.product.currentPrice!.toDouble(),
      serviceName: widget.product.service!.name!,
    );

    bool itemExists = false;

    for (int i = 0; i < cartBox.length; i++) {
      final itemRaw = cartBox.getAt(i) as Map<dynamic, dynamic>;
      final itemMap =
          itemRaw.map((key, value) => MapEntry(key.toString(), value));
      final existingItem = CarItemHiveModel.fromMap(itemMap);

      if (existingItem.productsId == newCartItem.productsId &&
          existingItem.subproductsId == newCartItem.subproductsId) {
        final updatedItem = existingItem.copyWith(
          productsQTY: existingItem.productsQTY + quantity,
        );
        cartBox.putAt(i, updatedItem.toMap());
        itemExists = true;
        break;
      }
    }

    if (!itemExists) {
      cartBox.add(newCartItem.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة المنتج إلى السلة'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    num unitPrice = widget.product.currentPrice ?? 0;
    num totalPrice = unitPrice * quantity;
    final isFavorite = favorites.any((item) => item.id == widget.product.id);

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

            return InkWell(
                onTap: () {
                  context.nav.push(
                    MaterialPageRoute(
                      builder: (context) => MyCartTab(),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    color: const Color(0xFFF9F9F9),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            widget.product.imagePath ?? '',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.nameBn?.toString() ??
                                    'اسم المنتج',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${totalPrice.toStringAsFixed(2)} ﷼',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                      toCart();
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.teal,
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                    toCart();
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.teal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            19,
          ),
          color: AppColors.primary,
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
