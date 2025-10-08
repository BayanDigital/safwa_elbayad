import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/providers/misc_providers.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WaterOnBoardingScreen extends ConsumerWidget {
  WaterOnBoardingScreen({super.key});

  final List<WaterSliderData> slideData = [
    WaterSliderData(
      image:   'assets/images/Onboarding1.png',

      backgroundImage: 'assets/images/safwa1.png',
      title: "نظافة وانتعاش... تبدأ من هنا",
    ),
    WaterSliderData(
      image:   'assets/images/Onboarding2.png',

      backgroundImage: 'assets/images/safwa2.png',
      title: 'سجّل دخولك... وخلي كل حاجة نظيفة توصلك لباب البيت',
    ),
    WaterSliderData(
      image:   'assets/images/Onboarding3.png',

      backgroundImage: 'assets/images/safwa3.png',
      title: 'كل خدمات الغسيل في مكان واحد... بأسلوب ذكي وسهل',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(waterSliderIndexProvider);
    final imgPageController =
    ref.watch(onBoardingSliderControllerProvider('image'));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
      Positioned.fill(
      child:
          Image.asset(
              slideData[index].image,
              fit: BoxFit.fill
          ),),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      context.nav.pushNamedAndRemoveUntil(
                        Routes.homeScreen,
                            (route) => false,
                      );
                    },
                    child: Text(
                      'تخطي',
                      style: AppTextDecor.osBold14white,
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  reverse: true,

                  controller: imgPageController,
                  itemCount: slideData.length,
                  onPageChanged: (val) {
                    ref.read(waterSliderIndexProvider.notifier).state = val;
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        AppSpacerH(130.h),
                        Image.asset(
                          slideData[index].backgroundImage,
                          fit: BoxFit.cover,
                        ),
                        AppSpacerH(50.h),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width:250,
                            child: Text(
                              slideData[index].title,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: AppTextDecor.osBold14white.copyWith(
                                fontSize: 16.sp,
                                height: 1.8,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),


                        AppSpacerH(50.h),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmoothPageIndicator(
                                textDirection: TextDirection.ltr,
                                controller: imgPageController,
                                count: slideData.length,
                                effect: const ExpandingDotsEffect(
                                  activeDotColor: AppColors.primary,
                                  dotHeight: 12,
                                  spacing: 5,
                                  expansionFactor: 3,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final currentIndex =
                                  ref.read(waterSliderIndexProvider);
                                  if (currentIndex < slideData.length - 1) {
                                    imgPageController.animateToPage(
                                      currentIndex + 1,
                                      duration:
                                      const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutCubic,
                                    );
                                    ref
                                        .read(waterSliderIndexProvider.notifier)
                                        .state = currentIndex + 1;
                                  } else {
                                    final Box appSettingsBox =
                                    Hive.box(AppHSC.appSettingsBox);
                                    appSettingsBox.put(
                                        AppHSC.hasSeenSplashScreen, true);
                                    context.nav.pushNamedAndRemoveUntil(
                                      Routes.homeScreen,
                                          (route) => false,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class WaterSliderData {
  final String image;
  final String backgroundImage;
  final String title;

  WaterSliderData({required this.image,
    required this.backgroundImage,
   required this.title,
  });
}

// Providers
final waterSliderIndexProvider = StateProvider<int>((ref) => 0);
final waterSliderControllerProvider =
    Provider<PageController>((ref) => PageController());
