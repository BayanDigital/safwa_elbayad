import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/screens/homePage/best_seller_detilas.dart';
import 'package:laundry_customer/screens/homePage/item_details.dart';
import 'package:laundry_customer/widgets/bouquet_card.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class ValentineFlowerScreen extends ConsumerStatefulWidget {

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValentineFlowerScreenState();
}

class _ValentineFlowerScreenState extends ConsumerState<ValentineFlowerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("باقات زهور عيد  الحب"),
          centerTitle: true,
        ),
        body:Column(
          children: [
            ref.watch(productsProviderData).map(
              initial: (_) => const SizedBox(),
              loading: (_) =>
              const LoadingWidget(showBG: true),
              loaded: (_) {
                final allProducts =
                    _.data.data?.products ?? [];

                final filteredProducts =
                allProducts.where((product) {
                  final variantMatch =
                      product.variant?.name == "Valentine's Day";
                  return variantMatch;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return MessageTextWidget(
                      msg: S.of(context).nosrvcavlbl);
                }

                return SizedBox(
                  height: 270,
                  child: GridView.builder(
                    itemCount:  filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 130 / 200,),
                    itemBuilder: (context, index) {
                      final product =
                      filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChooseItemCardDetails(
                                        product:
                                        product)),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 10.w),
                          child: Container(
                            height: 250,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  10),
                              border: Border.all(
                                  color: AppColors.gray,
                                  width: .6),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.all(
                                  8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  AppSpacerH(5.h),
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .only(
                                        right: 15,
                                        left: 15),
                                    child: Image.network(
                                      product.imagePath ??
                                          '',
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  AppSpacerH(10.h),
                                  AppSpacerH(15.h),
                                  Text(
                                    product.nameBn
                                        .toString(),
                                    style: AppTextDecor
                                        .osRegular12black,
                                  ),
                                  AppSpacerH(10.h),
                                  Text(
                                    "${product.oldPrice} جنيها ",
                                    style: AppTextDecor
                                        .osBold16black,
                                  ),
                                  AppSpacerH(7.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              error: (_) =>
                  ErrorTextWidget(error: _.error),
            ),
          ],
        )
    );
  }}