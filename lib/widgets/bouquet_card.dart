import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';

class BouquetCard extends StatelessWidget {
  final TopSellingItem item;

  const BouquetCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gray,
          width: .6,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacerH(5.h),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Image.network(
                'https://rehana.maher.website/${item.image}',
                height: 100,
                width: 100,
              ),
            ),
            AppSpacerH(10.h),
            Container(
              margin: const EdgeInsets.only(right: 60),
              height: 22,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.gold,
              ),
              child: Center(
                child: Text(
                  S.of(context).bestSeller,
                  style: AppTextDecor.osSemiBold10black
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            AppSpacerH(15.h),
            Text(
              item.name,
              style: AppTextDecor.osRegular12black,
            ),
            AppSpacerH(10.h),
            Text(
              "${item.price} جنيها",
              style: AppTextDecor.osBold16black,
            ),
            AppSpacerH(7.h),
            Row(
              children: [
                Text(
                  "${item.totalRevenue} جنيها",
                  style: AppTextDecor.osSemiBold12black,
                ),
                AppSpacerW(7.w),
                Text(
                  "${_calculateDiscount()}%",
                  style: AppTextDecor.osSemiBold12black.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calculateDiscount() {
    final double discount =
        ((item.totalRevenue - item.price) / item.totalRevenue) * 100;
    return discount.toStringAsFixed(0);
  }
}

class TopSellingItem {
  final int id;
  final String name;
  final double price;
  final String image;
  final int totalSold;
  final double totalRevenue;

  TopSellingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.totalSold,
    required this.totalRevenue,
  });

  factory TopSellingItem.fromJson(Map<String, dynamic> json) {
    return TopSellingItem(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      totalSold: int.parse(json['total_sold'] as String),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );
  }
}

class ApiService {
  final Dio _dio = Dio();

  Future<List<TopSellingItem>> fetchTopSelling() async {
    final response =
        await _dio.get('https://rehana.maher.website/api/topSelling');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((item) => TopSellingItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load top selling items');
    }
  }
}

final topSellingProvider = FutureProvider<List<TopSellingItem>>((ref) async {
  return ApiService().fetchTopSelling();
});
