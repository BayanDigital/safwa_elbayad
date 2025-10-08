import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/misc_global_variables.dart';
import 'package:laundry_customer/providers/auth_provider.dart';
import 'package:laundry_customer/providers/profile_update_provider.dart';
import 'package:laundry_customer/screens/auth/login_screen.dart';
import 'package:laundry_customer/screens/cart/my_cart_tab.dart' show NotSignedInwidget;
import 'package:laundry_customer/screens/message/logic/socket.dart';

import 'package:dio/dio.dart';

import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/buttons/rounder_button.dart';
import 'package:laundry_customer/widgets/custom_tile.dart';


class UsignedUserTab extends ConsumerWidget {
  UsignedUserTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: const Color(0xFFF9F9F9),

      height: 812.h,
      width: 375.w,
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (context, Box userBox, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.authBox).listenable(),
            builder: (context, Box authBox, Widget? child) {
              debugPrint(
                'Stripe Key : ${userBox.get(AppHSC.stripeCustomerID)}',
              );
              return SingleChildScrollView(
                child: Column(
                  children: [
                    AppSpacerH(44.h),
                    AppNavbar(
                      backgroundColor:  const Color(0xFFF9F9F9),
                
                      title: S.of(context).prfl,
                      showBack: false,
                    ),
                    AppSpacerH(14.h),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color:const Color(0xFFF9F9F9),
                
                    ) ,
                    AppSpacerH(14.h),
                
                    if (authBox.get('token') != null)
                      Container()
                    else
                      Container(
                        height: 120.h,
                        width: 355.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFCDDDDC),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            AppSpacerH(36.h),
                            if (authBox.get('token') == null)
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: AppRountedTextButton(
                                  height: 50,
                                  buttonColor: AppColors.primary,
                                  titleColor: AppColors.white,
                                  title: S
                                      .of(context)
                                      .login, // S.of(context).password
                
                                  width: 140.w,
                                  onTap: () {
                                    context.nav.pushNamed(Routes.loginScreen);
                                  },
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      ),
                    SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (authBox.get(AppHSC.authToken) == null)
                              Container()
                            else
                              CustomTile(
                                image: 'assets/images/setting.png',
                                title: S.of(context).edtprfl,
                                hasBorder: authBox.get('token') != null,
                        
                                ontap: () {
                                  context.nav
                                      .pushNamed(Routes.editProfileScreen);
                                },
                              ),
                            if (authBox.get(AppHSC.authToken) == null)
                              Container()
                            else
                              CustomTile(
                                image: 'assets/images/lock.png',
                                title: S.of(context).ChangePassword,
                                hasBorder: authBox.get('token') != null,

                                ontap: () {
                                  context.nav.pushNamed(Routes.changePasswordScreen);
                                },
                              ),
                            if (authBox.get(AppHSC.authToken) == null)
                              Container()
                            else
                              CustomTile(
                                image: 'assets/images/location.png',
                                title: S.of(context).addadrs,
                                hasBorder: authBox.get('token') != null,
                        
                                ontap: () {
                                  context.nav
                                      .pushNamed(Routes.manageAddressScreen);
                                },
                              ),
                            if (authBox.get(AppHSC.authToken) == null)
                              Container()
                            else
                              CustomTile(
                                image: 'assets/images/pakage.png',
                                title: S.of(context).offer,
                                hasBorder: authBox.get('token') != null,
                        
                                ontap: () {
                                  context.nav
                                      .pushNamed(Routes.packageScreen);
                                },
                              ),


                            CustomTile(
                              image: 'assets/images/about.png',
                              title: S.of(context).abtus,

                              ontap: () {
                                context.nav.pushNamed(Routes.aboutUsScreen);
                              },
                            ),
                            CustomTile(
                              image: 'assets/images/Group.png',
                              title: S.of(context).privacyPolicy,
                        
                              ontap: () {
                                context.nav.pushNamed(Routes.privacyPolicyScreen);
                              },
                            ),
                            CustomTile(
                              image: 'assets/images/help.png',
                              title: S.of(context).trmsofsrvc,
                        
                              ontap: () {
                                context.nav.pushNamed(Routes.termsOfServiceScreen);
                              },
                            ),
                            CustomTile(
                              image: 'assets/images/call_us.png',
                              title: S.of(context).cntctus,
                        
                              ontap: () {
                                context.nav.pushNamed(Routes.contactUsScreen);
                              },
                            ),
                        /*
                            CustomTile(
                              image: 'assets/images/language.png',
                              title: S.of(context).language,
                              hasBorder: authBox.get('token') != null,
                              ontap: () {
                                final currentLocale =
                                    Hive.box(AppHSC.appSettingsBox)
                                        .get(AppHSC.appLocal)
                                        .toString();
                        
                                showLanguageDialog(context);
                              },
                            ),*/
                            if (authBox.get('token') != null)
                              CustomTile2(
                                colorIcon: AppColors.primary,
                                title: S.of(context).lgout,
                                color:Colors.black,
                                hasBorder: !(authBox.get('token') != null),
                                ontap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20.w),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          height: 200.h,
                                          width: 335.w,
                                          padding: EdgeInsets.all(20.h),
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              return ref.watch(logOutProvider).map(
                                                    initial: (_) => Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          S.of(context).urabttolgot,
                                                          style: AppTextDecor
                                                              .osSemiBold18black,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        AppSpacerH(10.h),
                                                        Text(
                                                          S.of(context).arusre,
                                                          style: AppTextDecor
                                                              .osRegular14black,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        AppSpacerH(10.h),
                                                        SizedBox(
                                                          height: 50.h,
                                                          width: 335.w,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    AppTextButton(
                                                                  title: S
                                                                      .of(context)
                                                                      .no,
                                                                  buttonColor:
                                                                      AppColors
                                                                          .gray,
                                                                  titleColor:
                                                                      AppColors
                                                                          .black,
                                                                  onTap: () {
                                                                    context.nav
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ),
                                                              AppSpacerW(10.w),
                                                              Expanded(
                                                                child:
                                                                    AppTextButton(
                                                                  title: S
                                                                      .of(context)
                                                                      .y,
                                                                  onTap: () {
                                                                    ref
                                                                        .watch(
                                                                          logOutProvider
                                                                              .notifier,
                                                                        )
                                                                        .logout()
                                                                        .then(
                                                                            (value) {
                                                                      ref
                                                                          .read(
                                                                            socketProvider,
                                                                          )
                                                                          .socket!
                                                                          .dispose();
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    loading: (value) =>
                                                        const LoadingWidget(),
                                                    error: (_) {
                                                      Future.delayed(buildDuration)
                                                          .then((value) {
                                                        ref.refresh(logOutProvider);
                                                      });
                                                      return ErrorTextWidget(
                                                        error: _.error,
                                                      );
                                                    },
                                                    loaded: (value) {
                                                      Future.delayed(buildDuration)
                                                          .then((value) {
                                                        context.nav.pop();
                                                        userBox.clear();
                                                        authBox.clear();
                                                        ref.refresh(
                                                          profileInfoProvider,
                                                        );
                                                        ref.refresh(logOutProvider);
                                                        context.nav.pushNamed(
                                                          Routes.loginScreen,
                                                        );
                                                      });
                                                      return MessageTextWidget(
                                                        msg: S.of(context).lgdot,
                                                      );
                                                    },
                                                  );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (authBox.get('token') != null)
                              CustomTile2(
                                colorIcon: AppColors.primary,
                                title: S.of(context).deleteAccountTitle,
                                color:Colors.red,
                                hasBorder: !(authBox.get('token') != null),
                                ontap: () {

                                  _handleDeleteAccount(context);

                                }, image: "assets/images/delete.png",
                              ),
                          ],
                        ),
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

  Future<bool> deleteAccount({required int userId}) async {
    const String url = 'https://delta.maher.website/api/del_user';
    final Dio dio = Dio();

    try {
      final FormData formData = FormData.fromMap({'user_id': userId});

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print("🔁 Server response: ${response.data}");
      print("📦 Status code: ${response.statusCode}");

      final message = response.data['message']?.toString().toLowerCase().trim();
      print("📨 Extracted message: $message");

      if (response.statusCode == 200 &&
          (message?.contains('delete') == true ||
              message?.contains('حذف') == true)) {
        print("✅ Account deleted successfully");
        return true;
      } else {
        print("❌ Failed to delete account: ${response.statusCode} | $message");
        return false;
      }
    } catch (e) {
      print("⚠️ Error deleting account: $e");
      if (e is DioException) {
        print("DioError: ${e.response?.data ?? e.message}");
      }
      return false;
    }
  }
  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) =>
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/delete.png"),
                    AppSpacerH(25.h),
                    Center(
                      child: Text(S.of(context).deleteAccountPrompt,style: AppTextDecor.osSemiBold18black.copyWith(
                        color: AppColors.red,fontWeight: FontWeight.w700,fontSize: 16
                      ),textAlign: TextAlign.center,),
                    ),
                    AppSpacerH(25.h),
                    Text(S.of(context).deleteAccountWarning,style: AppTextDecor.osSemiBold18black.copyWith(
                        color: AppColors.secondaryColor,fontWeight: FontWeight.w500,fontSize: 14
                    ),
                    textAlign: TextAlign.center,),
                    AppSpacerH(15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style:  TextButton.styleFrom(
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            minimumSize: const Size(120, 30),
                            // Text color
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child:  Text(S.of(context).cancel, style: const TextStyle(color: AppColors.white,fontSize: 16)),
                        ),
                        AppSpacerW(20.w),
                        TextButton(

                          style:  TextButton.styleFrom(
                            minimumSize: const Size(120, 30), // width, height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(color: AppColors.textColor, width: 2), // border color and width

                            // Text color
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child:  Text(S.of(context).delete, style: const TextStyle(color: AppColors.textColor,fontSize: 16,
                          )),
                        ),
                      ],
                    )
                    , ],
                ),


              ),
            ));




    if (confirm == true) {
      final Box userBox = Hive.box(AppHSC.userBox);
      final userId = userBox.get('id') as int?;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في جلب بيانات المستخدم')),
        );
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await deleteAccount(userId: userId);

      Navigator.of(context).pop();

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        await userBox.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الحساب بنجاح')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في حذف الحساب، حاول مرة أخرى')),
        );
      }
    }
  }
  final List<AppLanguage> languages = [
    AppLanguage(name: '🇺🇸 ENG', value: 'en'),
    AppLanguage(name: '🇪🇬 العربية', value: 'ar'),
  ];
  showLanguageDialog(BuildContext context) {
    final currentLang =
        Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal) as String?;

    final selectedLang = languages.firstWhere(
      (lang) => lang.value == currentLang,
      orElse: () => languages.first,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              return ListTile(
                title: Text(
                  lang.name,
                  style: AppTextDecor.osBold14black,
                ),
                onTap: () {
                  Hive.box(AppHSC.appSettingsBox)
                      .put(AppHSC.appLocal, lang.value);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class AppLanguage {
  String name;
  String value;
  AppLanguage({
    required this.name,
    required this.value,
  });
}
