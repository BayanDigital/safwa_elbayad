import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_customer/models/schedule_model.dart';

final isAppLive = Provider<bool>((ref) => true);

final onBoardingSliderIndexProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});
//OneSignal Player ID Provider
final onesignalDeviceIDProvider = StateProvider<String>((ref) {
  return '';
});

final onBoardingSliderControllerProvider =
    Provider.family.autoDispose<PageController, String>((ref, name) {
  return PageController();
});

final homeScreenIndexProvider = StateProvider<int>((ref) => 0);

final homeScreenPageControllerProvider =
    Provider.autoDispose<PageController>((ref) {
  return PageController(initialPage: 4);
});

final tempSignProvider = StateProvider<bool>((ref) {
  return false;
});
final itemSelectMenuIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final dateProvider = StateProvider.family<DateTime?, String>((ref, id) => null);

// final imageProvider = StateProvider.autoDispose<File?>((ref) => null);

final addressIDProvider = StateProvider.autoDispose<String>((ref) => '');
final scheduleProvider =
    StateProvider.family.autoDispose<ScheduleModel?, String>((ref, id) => null);

final calculateTotalProvider = StateProvider<double>((ref) {
  return 0.00;
});
