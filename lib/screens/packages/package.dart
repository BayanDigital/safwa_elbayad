import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/models/package_model/package_model.dart';

class PackageScreen extends ConsumerWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPackages = ref.watch(packageListProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: SafeArea(
          child: Column(
            children: [
              AppSpacerH(34.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      S.of(context).offer,
                      style: AppTextDecor.osBold20white.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              AppSpacerH(20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    border: Border.all(color:const Color(0xFFB5AFAF)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color:  AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:AppColors.secondaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                    tabs: const [
                      Tab(text: 'الباقات'),
                      Tab(text: 'باقتك الخاصة'),
                    ],
                  ),
                ),
              ),


              AppSpacerH(20.h),

              Expanded(
                child: TabBarView(
                  children: [
                    const Center(child: Text('صفحة باقتك الخاصة')),

                    asyncPackages.when(
                      data: (packages) {
                        if (packages.isEmpty) {
                          return Center(child: Text('لا توجد باقات'));
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical:10 ),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              childAspectRatio: 3.5 / 1.8,
                            ),
                            itemCount: packages.length,
                            itemBuilder: (context, index) {
                              final pkg = packages[index];

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),

                                    ),
                                    color: const Color(0xFFE5E8EB),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:double.infinity,
                                          height: 50,
                                          decoration:const BoxDecoration(
                                        color: AppColors.primary,
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(15))

                                    ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 10),
                                            child: Text(
                                              pkg.name??'',
                                              style: AppTextDecor.osBold16black
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:const Color(0XFFE5E8EB),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            pkg.desc??'',
                                            textAlign: TextAlign.center,
                                            style: AppTextDecor.osBold20Black
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: AppTextButton(
                                              title: S.of(context).subNow,
                                              borderColor: AppColors.primary,
                                              buttonColor:AppColors.primary,
                                              titleColor: AppColors.white,
                                              onTap: () {
                                              },
                                              height: 30.h,
                                              width: 100.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: -10,
                                    left: -10,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration:  BoxDecoration(
                                        border: Border.all(color: AppColors.white,width: 3),
                                        shape: BoxShape.circle,
                                        color: AppColors.primary,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                             Text(
                                              S.of(context).price,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              pkg.price.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                                                                     ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('حدث خطأ: $e')),
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
