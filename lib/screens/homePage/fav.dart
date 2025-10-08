import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_box_decoration.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/products_model/product.dart';
import 'package:laundry_customer/screens/homePage/item_details.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/global_functions.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ProductData>>(
      (ref) => FavoritesNotifier()..loadFavorites(),
);

class FavoritesNotifier extends StateNotifier<List<ProductData>> {
  FavoritesNotifier() : super([]);

  static const _prefsKey = 'favorites';

  Future<void> addToFavorites(ProductData product) async {
    if (!state.any((p) => p.id == product.id)) {
      final updated = [...state, product];
      state = updated;
      await _saveToPrefs(updated);
    }
  }

  Future<void> removeFromFavorites(ProductData product) async {
    final updated = state.where((p) => p.id != product.id).toList();
    state = updated;
    await _saveToPrefs(updated);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_prefsKey) ?? [];

    try {
      final favs = jsonList.map((e) => ProductData.fromJson(e)).toList();
      state = favs;
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      state = [];
    }
  }

  Future<void> _saveToPrefs(List<ProductData> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favorites.map((p) => p.toJson()).toList();
    await prefs.setStringList(_prefsKey, jsonList);
  }
}

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: AppBoxDecorations.topBar,
              height: 88.h,
              width: 375.w,
              child: Column(
                children: [
                  AppSpacerH(42.h),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: AppNavbar(
                      showBack: false,
                      title: S.of(context).fav,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.whiteLight,
            ),
            if (favorites.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacerH(150.h),
                  Image.asset("assets/images/no.png"),
                  AppSpacerH(50.h),
                  Center(
                    child: Text(
                      'سله المفضلات فارغه',
                      style: AppTextDecor.osBold20Black,
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 22.w,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 128.w / 210.h,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    return Container(
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              AppSpacerW(20.w),
                              Expanded(
                                child: IconButton(
                                  onPressed: () async {
                                    await ref
                                        .read(favoritesProvider.notifier)
                                        .removeFromFavorites(product);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              AppSpacerW(30.w),
                              Container(
                                width: 25,
                                height: 20,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.black,
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChooseItemCardDetails(product: product),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image.network(
                                product.imagePath ?? '',
                                height: 80.h,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    getLng(
                                      en: product.name,
                                      changeLang: product.nameBn.toString(),
                                    ),
                                    style: AppTextDecor.osSemiBold10black,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                AppSpacerW(20.w),
                                Text(
                                  '${product.currentPrice} جنيها',
                                  style: AppTextDecor.osSemiBold10black.copyWith(fontSize: 8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
