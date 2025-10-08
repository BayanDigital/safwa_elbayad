
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';

import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/add_order_model/product.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/providers/settings_provider.dart';
import 'package:laundry_customer/screens/homePage/sub_category.dart';

import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/home_card_special.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

class  CategoryTab extends ConsumerStatefulWidget {
  const  CategoryTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryTabState();
}

class _CategoryTabState extends ConsumerState< CategoryTab> {
  List postCodelist = [];
  bool isShowText = false;
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
   ;
  }


  @override
  Widget build(BuildContext context) {
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
              return SingleChildScrollView(
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
                            showBack: false,
                            title: S.of(context).cts,
                          ),
                        ],
                      ),
                    ),
                 
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: ref.watch(allServicesProvider).map(
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
                
                          return
                            GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              itemCount: services.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio: 2 / 2.5,
                              ),
                              itemBuilder: (context, index) {
                                final service = services[index];
                                return HomeCardSpecial(
                                  service: service,
                                  ontap: () {
                                    ref.refresh(
                                      servicesVariationsProvider(service.id.toString()),
                                    );
                                    ref.refresh(productsFilterProvider);

                                    ref.watch(itemSelectMenuIndexProvider.notifier).state = 0;

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>  ChooseVariantScreen(service: service),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                        },
                        error: (_) =>
                            ErrorTextWidget(error: _.error),
                      ),
                    ),
                  ],
                ),
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
