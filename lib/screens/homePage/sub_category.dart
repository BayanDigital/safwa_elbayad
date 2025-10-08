import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/all_service_model/service.dart';
import 'package:laundry_customer/notfiers/guest_notfiers.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/screens/homePage/choose_items.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

class ChooseVariantScreen extends ConsumerWidget {
  final Service service;

  const ChooseVariantScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesVariationsProvider(service.id.toString()));

    return Scaffold(
      body: Column(
        children: [
          AppSpacerH(44.h),
          Padding(
            padding: const EdgeInsets.only(right: 25.0,bottom: 20),
            child: Row(
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

                Text( service.nameBn.toString(),style: AppTextDecor.osSemiBold18black.copyWith(
                    color: AppColors.primary,
                  fontWeight: FontWeight.w800
                ),),
              ],
            ),
          )
          ,
          state.when(
            initial: () => const Center(child: Text("مرحبا")),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (variationsModel) {
              final variants = variationsModel.data?.variants ?? [];

              if (variants.isEmpty) {
                return const Center(child: Text('لا توجد أنواع متاحة'));
              }

              return Expanded(
                child: GridView.builder(
                  itemCount: variants.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 3.5/ 2.2,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final variant = variants[index];
                    return GestureDetector(
                      onTap: () {
                        ref.read(productsFilterProvider.notifier).state =
                            ProducServiceVariavtionDataModel(
                              servieID: service.id.toString(),
                              variationID: variant.id.toString(),
                            );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseItems(
                              service: service,
                              variant:variant.nameBn.toString(),
                            ),
                          ),
                        );

                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: AppColors.primary, width: 1),
                        ),
                        color: AppColors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Image.network(
                                    variant.image ?? '',
                                    width: 90,
                                    height:50,
                                  ),
                                ),
                              ),
                              AppSpacerH(5.h),
                              SizedBox(
                                width: 90.w,
                                child: Text(
                                  getLng(
                                    en: variant.name,
                                    changeLang: variant.nameBn.toString(),
                                  ),
                                  style: AppTextDecor.osSemiBold12black.copyWith(
                                      fontWeight: FontWeight.w600,color: AppColors.primary),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            error: (error) => Center(child: Text('خطأ: $error')),
          ),
        ],
      ),
    );
  }
}
