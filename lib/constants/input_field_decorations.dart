import 'package:flutter/material.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';

class AppInputDecor {
  AppInputDecor._(); // This class is not meant to be instantiated.
  static InputDecoration loginPageInputDecor = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColors.grayColor, fontSize: 16),

    errorStyle: AppTextDecor.formErrorTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: AppColors.grayColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: AppColors.grayColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: AppColors.grayColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: AppColors.red),
    ),
  );
  static InputDecoration searchPageInputDecor = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColors.grayColor, fontSize: 16),
    filled: true,
    fillColor: AppColors.white,
    errorStyle: AppTextDecor.formErrorTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.white),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.red),
    ),
  );

  static InputDecoration pageInputDecor = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColors.gray, fontSize: 16),
    filled: true,
    fillColor: AppColors.white,
    errorStyle: AppTextDecor.formErrorTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.lightgray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.lightgray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.lightgray),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color:AppColors.lightgray),
    ),
  );
  static InputDecoration searchInputDecor = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(color: AppColors.gray, fontSize: 16),
    filled: true,
    fillColor: AppColors.white,
    errorStyle: AppTextDecor.formErrorTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.gray),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.red),
    ),
  );

}
