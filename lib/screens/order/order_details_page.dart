import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/models/order_details_model/product.dart';
import 'package:laundry_customer/providers/order_providers.dart';
import 'package:laundry_customer/screens/order/order_dialouges.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/buttons/order_cancel_button.dart';
import 'package:laundry_customer/widgets/dashed_line.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class OrderDetails extends ConsumerStatefulWidget {
  const OrderDetails({
    super.key,
    required this.orderID,
    required this.orderStatus,
  });
  final String orderID;
  final String orderStatus;

  @override
  ConsumerState<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails> {
  final Box cartsBox = Hive.box(AppHSC.cartBox);
  final List<String> orderStatuses = [
    'pending',
    'order confirmed',
    'picked your order',
    'processing',
    'delivered',
    'cancelled',
  ];


  bool isChatAble = false;
  // late int? driverId;
  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
    final userBox = Hive.box(AppHSC.userBox);
    final Map<dynamic, dynamic> userData = userBox.toMap();
    final int userId = userData['id'] as int;
    ref.watch(orderDetailsProvider(widget.orderID));
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,


        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(

                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    children: [
                      AppSpacerH(44.h),
                      Row(
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
                            Text(S.of(context).ordrdtls,style: AppTextDecor.osBold20white
                                .copyWith(fontSize: 18, color: AppColors.primary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]


                      ),
                      AppSpacerH(14.h),

                    ],
                  ),
                ),
              ),

              Container(
                height: 724.h,
                
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ref.watch(orderDetailsProvider(widget.orderID)).map(
                      initial: (_) => const LoadingWidget(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        Future.delayed(const Duration(milliseconds: 50), () {
                          setState(() {
                            isChatAble = _.data.data!.order!.isChatAble!;
                          });
                        });
                        // if (_.data.data!.order!.drivers!.driverId != null) {
                        //   setState(() {
                        //     driverId = _.data.data!.order!.drivers!.driverId;
                        //   });
                        // }
                        final List<OrderDetailsTile> orderWidgets = [];
                        final List<CarItemHiveModel> products = [];
                        for (var i = 0;
                            i < _.data.data!.order!.products!.length;
                            i++) {
                          var subproductprice = 0;
                          for (final subproduct
                              in _.data.data!.order!.products![i].sbproducts!) {
                            for (final orderedsubproduct
                                in _.data.data!.order!.orderSubProduct!) {
                              if (subproduct.id == orderedsubproduct.id) {
                                subproductprice = orderedsubproduct.price!;
                              }
                            }
                          }
                          orderWidgets.add(
                            OrderDetailsTile(
                              product: _.data.data!.order!.products![i],
                              qty: _.data.data!.order!.quantity!.quantity[i]
                                  .quantity,
                              subprice: subproductprice,
                            ),
                          );
                          if (_.data.data!.order!.orderStatus == 'Pending') {
                            cartsBox.clear();
                          }
                          final CarItemHiveModel product = CarItemHiveModel(
                            productsId:
                                _.data.data!.order!.products![i].id ?? 0,
                            productsName:
                                _.data.data!.order!.products![i].name ?? '',
                            productsImage:
                                _.data.data!.order!.products![i].imagePath ??
                                    '',
                            productsQTY: _.data.data!.order!.quantity!
                                .quantity[i].quantity,
                            unitPrice:
                                _.data.data!.order!.products![i].currentPrice ??
                                    0.0,
                            serviceName: _.data.data!.order!.products![i]
                                    .service!.name ??
                                '',
                          );
                          products.add(product);
                        }
                        return ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            AppSpacerH(10.h),
                            Card(
                              elevation:5,
                              color:const Color(0xFFF8F5F5),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 15.h,
                                ),
                                decoration: AppBoxDecorations.pageCommonCard,
                                child:  Column(
                                    children: orderWidgets,
                                  ),
                                ),
                            ),
                            AppSpacerH(15.h),
                            Text(
                              S.of(context).shpngadr,
                              style: AppTextDecor.osBold14black.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            AppSpacerH(15.h),
                            Card(
                              elevation:5,
                                                           color:const Color(0xFFF8F5F5),

                              child: Container(
                                width: 335.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 15.h,
                                ),
                                decoration: AppBoxDecorations.pageCommonCard,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [

                                        AppSpacerW(10.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("الاسم:",style:
                                                  AppTextDecor.osRegular14black,),
                                                AppSpacerW(10),
                                                Text(
                                                  _.data.data!.order!.customer!.user!
                                                      .name!,
                                                  style:
                        AppTextDecor.osRegular12black.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w800),                                                ),
                                              ],
                                            ),
                                            if (_.data.data!.order!.customer!
                                                    .user!.mobile ==
                                                null)
                                              const SizedBox()
                                            else
                                              Row(
                                                children: [
                                                  Text("رقم الموبايل: ",style:
                                                  AppTextDecor.osRegular14black,),
                                                  AppSpacerW(10),

                                                  Text(
                                                    _.data.data!.order!.customer!
                                                        .user!.mobile!,
                                                    style:
                                                        AppTextDecor.osRegular12black.copyWith(
                                                          color: AppColors.secondaryColor,
                                                          fontWeight: FontWeight.w800
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              children: [
                                                Text("العنوان  :",style:
                                                AppTextDecor.osRegular14black,),

                                                  SizedBox(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        1.6,
                                                    child: Text(
                                                      "${_.data.data!.order!.address!.addressName}, ${_.data.data!.order!.address!.area}, ${_.data.data!.order!.address!.addressLine2 ?? ''} - ${_.data.data!.order!.address!.postCode}",
                                                      style:

                                                        AppTextDecor.osRegular12black.copyWith(
                                                        color: AppColors.secondaryColor,
                                                        fontWeight: FontWeight.w800
                                                    ),
                                                  ),

                                                  )],
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSpacerH(15.h),
                            Card(
                              elevation: 5,
                              color:const Color(0xFFF8F5F5),

                              child: Container(
                                width: 335.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 15.h,
                                ),
                                decoration: AppBoxDecorations.pageCommonCard,
                                child: Column(
                                  children: [
                                    Table(
                                      children: [
                                        AppGFunctions.tableTitleTextRow(
                                          title: S.of(context).ordrid,
                                          data: '#${_.data.data!.order!.orderCode}',
                                        ),

                                        AppGFunctions.tableTextRow(
                                          title: S.of(context).ordrstats,
                                          data: getLng(
                                            en: _.data.data!.order!.orderStatus,
                                            changeLang: _.data.data!.order!.orderStatusbn.toString(),
                                          ),
                                        ),

                                        AppGFunctions.tableTextRow(
                                          title: S.of(context).sbttl,
                                          data: '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.amount!)}',
                                        ),
                                        AppGFunctions.tableTextRow(
                                          title: S.of(context).dlvrychrg, //
                                          data: '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.deliveryCharge!)}',
                                        ),
                                        AppGFunctions.tableDiscountTextRow(
                                          title: S.of(context).dscnt, //
                                          data: '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(_.data.data!.order!.discount!)}',
                                        ),
                                      ],
                                    ),
                                    const MySeparator(),
                                    AppSpacerH(8.5.h),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          S.of(context).ttl, //
                                          style: AppTextDecor.osBold12black.copyWith(
                                            color: AppColors.textColor
                                          ),
                                        ),
                                        Text(
                                          '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(
                                              _.data.data!.order!.amount! +
                                                  _.data.data!.order!.deliveryCharge! -
                                                  _.data.data!.order!.discount!
                                          )}',
                        style: AppTextDecor.osBold14black.copyWith(color: AppColors.secondaryColor,fontSize: 12,fontWeight: FontWeight.w800),

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSpacerH(15.h),
                            Text(
                              "تابع طلبك من هنا",
                              style: AppTextDecor.osBold14black.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800
                              ),
                            ),
                            AppSpacerH(15.h),
                            Column(
                              children: orderStatuses.map((status) {
                                final color = getOrderTrackingColor(
                                  currentStatus: _.data.data?.order?.orderStatus ?? '',
                                  statusToCheck: status,
                                );

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        status,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),


                            if (_.data.data?.order?.orderStatus ==
                                    'Delivered' &&
                                _.data.data?.order?.rating == null)
                              CancelOrderButton(
                                title: S.of(context).rateurexprnc,
                                onTap: () {
                                  AppOrderDialouges.orderFeedBackDialouge(
                                    context: context,
                                    orderID: _.data.data!.order!.id.toString(),
                                    ref: ref,
                                  );
                                },
                              ),
                            AppSpacerH(8.h),
                          ],
                        );
                      },
                      error: (_) => ErrorTextWidget(
                        error: _.error,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Color getOrderTrackingColor({
    required String currentStatus,
    required String statusToCheck,
  }) {
    final List<String> orderStatuses = [
      'pending',
      'order confirmed',
      'picked your order',
      'processing',
      'delivered',
      'cancelled',
    ];

    int currentIndex = orderStatuses.indexOf(currentStatus.toLowerCase().trim());
    int checkIndex = orderStatuses.indexOf(statusToCheck.toLowerCase().trim());

    if (checkIndex <= currentIndex && checkIndex != -1) {
      return AppColors.primary;
    } else {
      return Colors.grey.shade300;
    }
  }

}
class OrderDetailsTile extends StatelessWidget {
  const OrderDetailsTile({
    super.key,
    required this.product,
    required this.qty,
    this.subprice,
  });

  final Product product;
  final int qty;
  final int? subprice;

  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box(AppHSC.appSettingsBox);

    final unitPrice = product.currentPrice! + (subprice ?? 0);
    final totalPrice = unitPrice * qty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        width: 297.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imagePath!,
              height: 60.h,
              width: 70.w,
              fit: BoxFit.cover,
            ),
            AppSpacerW(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nameBn.toString(),
                    style: AppTextDecor.osBold12black,
                  ),
                  AppSpacerH(5.h),
                  Text(
                    '$qty قطع',
                    style: AppTextDecor.osBold12black,
                  ),
                  AppSpacerH(5.h),
                  Text(
                    'سعر القطعة :   ${settingsBox.get('currency') ??
                        'ج.م'}${AppGFunctions.convertToFixedTwo(unitPrice)}',
                    style: AppTextDecor.osBold12black,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );

  }

}


