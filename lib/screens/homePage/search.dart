import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';

import 'package:laundry_customer/constants/input_field_decorations.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/models/products_model/product.dart';
import 'package:laundry_customer/providers/guest_providers.dart';
import 'package:laundry_customer/screens/homePage/item_details.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  String SearchText = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // AppSpacerH(44.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppNavbar(
                      backgroundColor:  const Color(0xFFF9F9F9),
onBack: (){
                        context.nav.pop();
},
                      title: '',
                    ),
                  ),

                  AppSpacerH(20.h),
                  SizedBox(
                    width: 300.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        elevation: 4,
                        child: FormBuilderTextField(
                          name: 'search',
                          onChanged: (value) {
                            SearchText = value!;
                            setState(() {});
                          },
                          decoration: AppInputDecor.searchPageInputDecor.copyWith(
                              hintText: S.of(context).whatSearch,
                              prefixIcon: const Icon(Icons.search,color:  AppColors.gray,)),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 400.h,
                      child: ref.watch(productsProvider).map(
                        initial: (_) => const SizedBox(),
                        loading: (_) => const LoadingWidget(),
                        loaded: (_) {
                          List<ProductData> data = [];
                          if (SearchText == '') {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/no_login.png',
                                  height: 300.h,
                                  width: 300.w,
                                ),
                                AppSpacerH(20.h),
                                Text(
                                  'لا يوجد بحث ',
                                  style: AppTextDecor.osSemiBold16black,
                                ),
                              ],
                            );
                          } else {
                            data = _.data.data!.products!
                                .where(
                                  (element) =>
                              element.nameBn!
                                  .contains(SearchText) ==
                                  true,
                            )
                                .toList();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 38,vertical: 20),
                              child:
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: data.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1, // عدليه حسب الشكل المناسب
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChooseItemCardDetails(
                                            product: data[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.network(
                                                data[index].imagePath!,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              '${data[index].nameBn}',
                                              style: AppTextDecor.osSemiBold16black,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            );
                          }
                          return const SizedBox();
                        },
                        error: (_) => Column(
                          spacing: 25.h,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/connection_error.png',
                              height: 200.h,
                            ),
                            Text(
                              'خطأ في الاتصال بالانترنت ',
                              style: AppTextDecor.osSemiBold16black,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
