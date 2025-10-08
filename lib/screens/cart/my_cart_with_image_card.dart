import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/constants/hive_contants.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/hive_cart_item_model.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class MyCartItemImageCard extends ConsumerStatefulWidget {
  const MyCartItemImageCard({
    super.key,
    required this.carItemHiveModel,
  });

  final CarItemHiveModel carItemHiveModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyCartItemImageCardState();
}

class _MyCartItemImageCardState extends ConsumerState<MyCartItemImageCard> {
  final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
  final Box cartsBox = Hive.box(AppHSC.cartBox);

  int? keyAt;

  @override
  void initState() {
    super.initState();
    checkProduct();
  }

  void checkProduct() {
    for (int i = 0; i < cartsBox.length; i++) {
      final raw = cartsBox.getAt(i) as Map<dynamic, dynamic>;
      final itemMap = raw.map((key, value) => MapEntry(key.toString(), value));
      final item = CarItemHiveModel.fromMap(itemMap);

      if (item.productsId == widget.carItemHiveModel.productsId &&
          item.subproductsId == widget.carItemHiveModel.subproductsId) {
        keyAt = i;
        break;
      }
    }
    setState(() {});
  }

  void updateQuantity(int delta) {
    if (keyAt == null) return;

    final raw = cartsBox.getAt(keyAt!) as Map<dynamic, dynamic>;
    final itemMap = raw.map((key, value) => MapEntry(key.toString(), value));
    final currentItem = CarItemHiveModel.fromMap(itemMap);

    final newQty = currentItem.productsQTY + delta;

    if (newQty <= 0) {
      cartsBox.deleteAt(keyAt!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف المنتج من السلة')),
      );
    } else {
      final updatedItem = currentItem.copyWith(productsQTY: newQty);
      cartsBox.putAt(keyAt!, updatedItem.toMap());
    }

    checkProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: ValueListenableBuilder(
        valueListenable: cartsBox.listenable(),
        builder: (context, Box cartbox, Widget? child) {
          if (keyAt == null) return const SizedBox();

          final raw = cartsBox.getAt(keyAt!) as Map<dynamic, dynamic>;
          final itemMap = raw.map((key, value) => MapEntry(key.toString(), value));
          final item = CarItemHiveModel.fromMap(itemMap);

          final totalPrice = item.unitPrice * item.productsQTY;

          return
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.primary, width: 1),
              ),
              color: const Color(0xFFF9F9F9),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      item.productsImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image),
                    ),
                  ),

                  AppSpacerW(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.productsName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cartsBox.deleteAt(keyAt!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم حذف المنتج من السلة'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, color: AppColors.red),
                              tooltip: 'حذف',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${settingsBox.get('currency') ?? '\$'}${AppGFunctions.convertToFixedTwo(totalPrice)}',
                              style: AppTextDecor.osBold14black.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryColor,
                              ),

                            ),
                            const Expanded(child: SizedBox()),

                            GestureDetector(
                              onTap: () => updateQuantity(-1),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration:  BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(Icons.remove,color: AppColors.white,size: 18),
                              )
                            ),
                            AppSpacerW(8.w),
                            Text('${item.productsQTY}', style: AppTextDecor.osSemiBold14black.copyWith(color: AppColors.primary)),
                            AppSpacerW(8.w),
                            GestureDetector(
                              onTap: () => updateQuantity(1),
                              child:
                             Container(
                               width: 20,
                               height: 20,
                               decoration:  BoxDecoration(
                                 color: AppColors.primary,
                                 borderRadius: BorderRadius.circular(10)
                               ),
                               child: const Icon(Icons.add,color: AppColors.white,size: 18,),
                             )
                            ),
                            AppSpacerW(10)
                          ],
                        ),
                        AppSpacerH(10)

                      ],
                    ),
                  )
                ],
              ),

          );
        },
      ),
    );
  }
}
