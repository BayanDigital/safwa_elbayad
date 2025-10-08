








































import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';


import 'package:laundry_customer/screens/auth/login_screen.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppSpacerH(34.h),
            AppNavbar(
              backgroundColor: const Color(0xFFF9F9F9),
               backButtionColor: AppColors.primary,
              title:  'إعدادات الحساب',
              onBack: () {
                context.nav.pop();
              },
            ),
            AppSpacerH(14.h),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.whiteLight,
            ) ,
            AppSpacerH(14.h),

            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'تعديل الحساب',
              iconColor: AppColors.black,
              onTap: () {
                context.nav.pushNamed(Routes.editProfileScreen);
              },
            ),
            AppSpacerH(10.h),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.grayBG,
            ) ,
            AppSpacerH(10.h),/*
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: 'تغيير كلمة السر',
              iconColor: AppColors.black,
              onTap: () {
                context.nav.pushNamed(Routes.changePasswordScreen);
              },
            ),
            AppSpacerH(10.h),*/
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.grayBG,
            ) ,
            AppSpacerH(10.h),
            _buildSettingTile(
              icon: Icons.person_remove_outlined,
              title: 'حذف الحساب',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                _handleDeleteAccount(context);
              },
            ),
          ],
        ),
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
                mainAxisSize: MainAxisSize.min, // عشان يحجم على المحتوى بس
                children: [
                  Image.asset("assets/images/delete.png"),
                  AppSpacerH(15.h),
                  Text('هل  تريد حذف حسابك ؟',style: AppTextDecor.osBold14black,),
                  AppSpacerH(15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style:  TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                      minimumSize: const Size(120, 30),
                          // Text color
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('إلغاء', style: TextStyle(color: AppColors.white,fontSize: 16)),
                      ),
                      AppSpacerW(20.w),
                      TextButton(

                        style:  TextButton.styleFrom(
                          minimumSize: const Size(120, 30), // width, height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: AppColors.primary, width: 2), // border color and width

                          // Text color
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('حذف', style: TextStyle(color: AppColors.primary,fontSize: 16,
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

      // عرض دائرة تحميل أثناء الحذف
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await deleteAccount(userId: userId);

      // إغلاق دائرة التحميل
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
