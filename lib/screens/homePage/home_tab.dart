import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry_customer/models/package_model/package_model.dart';
import 'package:laundry_customer/screens/homePage/fav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/add_order_model/product.dart';
import 'package:laundry_customer/providers/guest_providers.dart';

import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/cart/my_cart_tab.dart';

import 'package:laundry_customer/screens/homePage/sub_category.dart';
import 'package:laundry_customer/screens/packages/subscribe_screen.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/home_card_special.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  List postCodelist = [];
  bool isShowText = false;
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncPackages = ref.watch(packageListProvider);

    final favorites = ref.watch(favoritesProvider);

    ref.watch(profileInfoProvider);
    ref.watch(settingsProvider).maybeWhen(
          orElse: () {},
          loaded: (_) {
            postCodelist = _.data?.postCode ?? [];
          },
        );
    ref.watch(allServicesProvider);

    return SizedBox(
      width: 375.w,
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.authBox).listenable(),
        builder: (context, Box authBox, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.userBox).listenable(),
            builder: (context, Box box, Widget? child) {
              return Column(
                children: [
                  ClipRRect(
                    child: Container(
                      width: 375.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacerH(44.h),
                          SizedBox(
                            height: 78.h,
                            child: Row(
                              children: [
                                AppSpacerW(15.w),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).hello,
                                      style: AppTextDecor.osSemiBold18black
                                          .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      authBox.get('token') != null
                                          ? '${box.get('name')}'
                                          : S.of(context).plslgin,
                                      style: AppTextDecor.osSemiBold18black
                                          .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                    ),
                                    // Text(
                                    //   address,
                                    //   style: AppTextDecor.osRegular14white,
                                    // )
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                if (authBox.get('token') != null)
                                  GestureDetector(
                                    onTap: () {
                                      context.nav.push(
                                        MaterialPageRoute(
                                          builder: (context) => MyCartTab(),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        color: AppColors.primary,
                                        Icons.shopping_cart_outlined,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () {
                                      context.nav.pushNamed(
                                        Routes.loginScreen,
                                      );
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/images/logout.png",
                                          color: Colors.white,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          width: 375.w,
                          height: 170.h,
                          child: Consumer(
                            builder: (context, ref, child) {
                              return ref.watch(allPromotionsProvider).map(
                                    initial: (_) => const SizedBox(),
                                    loading: (_) => const SizedBox(),
                                    loaded: (_) => CarouselSlider(
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        height: 170.0.h,
                                        viewportFraction: 0.95,
                                      ),
                                      items: _.data.data!.promotions!
                                          .map(
                                            (e) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 9.w,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10.w,
                                                ),
                                                child: Container(
                                                  color: AppColors.white,
                                                  width: 355.w,
                                                  child: Image.network(
                                                    e.imagePath!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    error: (_) =>
                                        ErrorTextWidget(error: _.error),
                                  );
                            },
                          ),
                        ),
                        AppSpacerH(20.h),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Visibility(
                            visible: isShowText,
                            child: Text(
                              S.of(context).srvctgrs,
                              style: AppTextDecor.osSemiBold18black.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        AppSpacerH(20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ref.watch(allServicesProvider).map(
                                  initial: (_) => const SizedBox(),
                                  loading: (_) =>
                                      const LoadingWidget(showBG: true),
                                  loaded: (_) {
                                    Future.delayed(Duration.zero, () {
                                      setState(() {
                                        isShowText = true;
                                      });
                                    });

                                    final services =
                                        _.data.data?.services ?? [];

                                    if (services.isEmpty) {
                                      return MessageTextWidget(
                                          msg: S.of(context).nosrvcavlbl);
                                    }

                                    return SizedBox(
                                      height: 108,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: services.length,
                                          itemBuilder: (context, index) {
                                            final service = services[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: HomeCardSpecial2(
                                                service: service,
                                                ontap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChooseVariantScreen(
                                                              service: service),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  error: (_) => ErrorTextWidget(error: _.error),
                                ),
                            AppSpacerH(15.h),
                            asyncPackages.when(
                              data: (packages) => packages.length == 0
                                  ? SizedBox()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 25.0),
                                      child: Visibility(
                                        visible: isShowText,
                                        child: Text(
                                          S.of(context).offer,
                                          style: AppTextDecor.osSemiBold18black
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                              loading: () => const Center(child: SizedBox()),
                              error: (e, _) => Center(child: SizedBox()),
                            ),
                            asyncPackages.when(
                              data: (packages) => SizedBox(
                                height: 1000,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1.8 / 2,
                                    ),
                                    itemCount: packages.length,
                                    itemBuilder: (context, index) {
                                      final pkg = packages[index];
                                      return Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: const BorderSide(
                                              color: AppColors.primary,
                                              width: 3),
                                        ),
                                        color: const Color(0xFFE5E8EB),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pkg.name??'',
                                                style: AppTextDecor
                                                    .osBold20Black
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            AppColors.primary),
                                                textAlign: TextAlign.right,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                pkg.desc??'',
                                                textAlign: TextAlign.center,
                                                style: AppTextDecor
                                                    .osBold20Black
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .secondaryColor),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                S.of(context).price,
                                                style: AppTextDecor
                                                    .osBold20Black
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .textColor),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${pkg.price} ر.س',
                                                    style: AppTextDecor
                                                        .osBold20Black
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 14,
                                                            color: AppColors
                                                                .primary),
                                                  ),
                                                  AppSpacerW(2.w),
                                                  AppTextButton(
                                                      borderColor: const Color(
                                                          0xFF87CEEB),
                                                      fontSize: 10,
                                                      x: 15,
                                                      height: 30.h,
                                                      width: 100,
                                                      buttonColor: const Color(
                                                          0xFF87CEEB),
                                                      title:
                                                          S.of(context).subNow,
                                                      titleColor:
                                                          AppColors.white,
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                SubscribeScreen(
                                                              package: pkg,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                              error: (e, _) =>
                                  Center(child: Text('حدث خطأ: $e')),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return MessageTextWidget(msg: S.of(context).nosrvcavlbl);
    }

    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: Container(
              height: 250,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gray, width: .6),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> images = [
    'assets/images/dim_00.png',
    'assets/images/dim_01.png',
    'assets/images/dim_02.png',
  ];
}
