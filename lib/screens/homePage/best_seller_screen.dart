import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/screens/homePage/best_seller_detilas.dart';
import 'package:laundry_customer/widgets/bouquet_card.dart';

class BestSellerScreen extends ConsumerStatefulWidget {

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends ConsumerState<BestSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).bestSeller),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Consumer(
          builder: (context, ref, child) {
            final topSellingAsyncValue =
            ref.watch(topSellingProvider);

            return topSellingAsyncValue.when(
              data: (items) => GridView.builder(
    padding: const EdgeInsets.all(10),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 15,
    crossAxisSpacing: 15,
    childAspectRatio: 130 / 200,
    ),
    itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BestSellerDetails(
                                  product:
                                  items[index])),
                    );
                  },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5.h, horizontal: 5.w),
                      child:
                      BouquetCard(item: items[index]),
                    ),
                  );
                },
              ),
              loading: () => const Center(
                  child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Error: $error')),
            );
          },
        ),

      ),
    );
  }}


