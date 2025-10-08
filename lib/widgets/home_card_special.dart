import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/models/all_service_model/service.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class HomeCardSpecial extends ConsumerWidget {
  const HomeCardSpecial({
    super.key,
    required this.service,
    this.ontap,
  });
  final Service service;
  final Function()? ontap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(servicesVariationsProvider(service.id!.toString()));
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
      builder: (BuildContext context, Box appSettingsBox, Widget? child) {
        final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
        return GestureDetector(
          onTap: ontap,
          child: Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(15),
               border: Border.all(
                 color: const Color(0xFFEDECEC)

               )
             ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 35,
                margin: const EdgeInsets.only(left: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppColors.black
                ),
                  child: Center(child: IconButton(
                    padding: EdgeInsets.zero,
                      onPressed:ontap, icon: const Icon(Icons.arrow_back,color: AppColors.white,size: 18,)))),
             Padding(
               padding: const EdgeInsets.only(right: 18.0,top: 10),
               child: Image.network(
                 width: 120,
                 height: 90,
                 service.imagePath!,

               ),
             ),
              AppSpacerH(15.h),
              SizedBox(
                width: 80.w,
                child: Text(
                  getLng(
                    en: service.name,
                    changeLang: service.nameBn.toString(),
                  ),
                  style: AppTextDecor.osBold14black,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
                          ),
          ),
        );
      },
    );
  }
}
class HomeCardSpecial2 extends ConsumerWidget {
  const HomeCardSpecial2({
    super.key,
    required this.service,
    this.ontap,
  });
  final Service service;
  final Function()? ontap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(servicesVariationsProvider(service.id!.toString()));
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
      builder: (BuildContext context, Box appSettingsBox, Widget? child) {
        final selectedLocal = appSettingsBox.get(AppHSC.appLocal);
        return
          Card(
            shape: const CircleBorder(),
            elevation: 4,
            child: Container(
              decoration:   const BoxDecoration(
                 shape: BoxShape.circle,
                  color:AppColors.white
              ),
              child: GestureDetector(
                onTap: ontap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.network(
                        width: 90,
                        height: 40,
                        service.imagePath!,

                      ),
                    ),
                    SizedBox(
                      width: 90.w,
                      child: Text(
                        getLng(
                          en: service.name,
                          changeLang: service.nameBn.toString(),
                        ),
                        style: AppTextDecor.osSemiBold12black.copyWith(fontWeight: FontWeight.w600,fontSize: 10,color: AppColors.primary),
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
    );
  }
}