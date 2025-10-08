import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/notifications_model/notification.dart'
    as nt;
import 'package:laundry_customer/providers/notification_providers.dart';
import 'package:laundry_customer/screens/cart/my_cart_tab.dart'
    show NotSignedInwidget;
import 'package:laundry_customer/screens/notifications/notification_function.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

// ignore: must_be_immutable
class MyNotificationsTab extends ConsumerWidget {
  MyNotificationsTab({super.key});

  List<nt.Notification> notifications = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationListProvider).maybeWhen(
          loaded: (_) {
            notifications = _.data?.notification ?? [];
          },
          orElse: () {},
        );
    return Container(
      height: 812.h,
      width: 375.w,
      child: Column(
        children: [
          Container(
            height: 108.h,
            width: 375.w,
            child: Column(
              children: [
                AppSpacerH(44.h),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: Text( S.of(context).ntfctn,style: AppTextDecor.osSemiBold18black.copyWith(
                        color: AppColors.primary
                    ),),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.authBox).listenable(),
              builder: (BuildContext context, Box authbox, Widget? child) {
                return Builder(
                  builder: (context) {
                    final isSignedIn = authbox.get(AppHSC.authToken) != null &&
                        authbox.get(AppHSC.authToken) != '';

                    if (!isSignedIn) {
                      return const NotSignedInwidget();
                    }

                    if (notifications.isEmpty) {
                      return const NoNotificationWidget();
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notfication = notifications[index];
                        final isRead = notfication.isRead == 1;

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/safwa.png"),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notfication.title ?? '',
                                            style: AppTextDecor.osBold14black.copyWith(
                                              color: AppColors.secondaryColor,
                                              fontWeight: FontWeight.w800
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            notfication.message ?? '',
                                            style: AppTextDecor.osRegular14black.copyWith(
                                              fontSize: 10,
                                              color: AppColors.textColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: const Icon(
                                Icons.mark_email_read,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              NotificationFunctions.readNotification(
                                notificationID: notfication.id.toString(),
                              ).then(
                                (_) => ref.refresh(notificationListProvider),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.primary,
                                      width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width:50,
                                      height: 50,
                                      decoration:BoxDecoration(

                                        color: const Color(0xFFCDDDDC),
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset("assets/images/log.png",width: 25,height: 20),
                                        )),
                                    AppSpacerW(20.w),
                                    Column(

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [


                                        Text(
                                          notfication.title ?? '',
                                          style: isRead
                                              ? AppTextDecor.osRegular14Navy.copyWith(color: AppColors.secondaryColor,fontWeight: FontWeight.w800)
                                              : AppTextDecor.osSemiBold14black..copyWith(color: AppColors.secondaryColor,fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          notfication.message ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextDecor.osRegular12navy.copyWith(
                                            color: AppColors.textColor,
                                            fontSize: 10
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         Image.asset("assets/images/no_no.png"),
             Text(S.of(context).noNotification,style:AppTextDecor.osBold20Black.copyWith(
               color: AppColors.secondaryColor
             ) ,)
            
          ],
        ),
      ),
    );
  }
}
