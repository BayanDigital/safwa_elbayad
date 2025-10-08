import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';

class IncDecButtonWithValueV2 extends ConsumerWidget {
  const IncDecButtonWithValueV2({
    super.key,
    this.width,
    this.height,
    required this.value,
    required this.onInc,
    required this.onDec,
  });
  final int value;
  final Function() onInc;
  final Function() onDec;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.w),
      ),
      height: height ?? 25.h,
      width: width ?? 150.w,
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onDec,
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
          Text(
            value.toString(),
            style: AppTextDecor.osSemiBold12black.copyWith(
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onInc,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
