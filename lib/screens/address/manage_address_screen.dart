import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundry_customer/constants/app_colors.dart';
import 'package:laundry_customer/constants/app_text_decor.dart';
import 'package:laundry_customer/generated/l10n.dart';
import 'package:laundry_customer/misc/global_functions.dart';
import 'package:laundry_customer/models/addres_list_model/address.dart';
import 'package:laundry_customer/providers/address_provider.dart';
import 'package:laundry_customer/utils/context_less_nav.dart';
import 'package:laundry_customer/utils/routes.dart';
import 'package:laundry_customer/widgets/buttons/full_width_button.dart';
import 'package:laundry_customer/widgets/misc_widgets.dart';
import 'package:laundry_customer/widgets/nav_bar.dart';
import 'package:laundry_customer/widgets/screen_wrapper.dart';

class ManageAddressScreen extends ConsumerStatefulWidget {
  const ManageAddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageAddressScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(addresListProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,

        child: Stack(
          children: [
            SizedBox(
              height: 812.h,
              width: 375.w,
              child: Column(
                children: [
                  Container(

                    height: 88.h,
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
                                Text(S.of(context).mngadrs,style: AppTextDecor.osBold20white
                                    .copyWith(fontSize: 18, color: AppColors.primary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]


                          ),


                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: ref.watch(addresListProvider).map(
                      initial: (_) => const SizedBox(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) => SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._.data.data!.addresses!.map(
                                  (e) => AddressCard(address: e),
                            ),
                          ],
                        ),
                      ),
                      error: (_) => ErrorTextWidget(error: _.error),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 34.h,
              child: SizedBox(
                width: 375.w,
                height: MediaQuery.of(context).size.height/18,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AppTextButton(
                    title: S.of(context).adadres,
                    onTap: () {
                      context.nav.pushNamed(Routes.addOrUpdateAddressScreen);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends ConsumerStatefulWidget {
  const AddressCard({
    super.key,
    required this.address,
  });
  final Address address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressCardState();
}

class _AddressCardState extends ConsumerState<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 2,
        child: Container(
          height: MediaQuery.of(context).size.height/11,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppColors.primary
            ),
            borderRadius: BorderRadius.circular(10.h),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset('assets/images/location.png',width: 25,),
                  )),
              AppSpacerW(20.w),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: widget.address.addressName != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(widget.address.addressName.toString()),
                    ),

                    Text(
                    processAddess(),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.nav.pushNamed(
              Routes.addOrUpdateAddressScreen,
              arguments: widget.address,
            );
          },
          child: Image.asset("assets/images/uil_edit.png",width: 25,),
        ),
        ],
      ),
    ),
    ),
    );
  }

  String processAddess() {
    String address = '';

    if (widget.address.addressLine2 == null) {
      address =
      " ${widget.address.area}, ${widget.address.postCode}";
    } else {
      address =
      " ${widget.address.area},${widget.address.addressLine2},ٍ${S.of(context).bet}${widget.address.addressLine ?? ''}";
    }
    return address;
  }
}

class AddressCardv2 extends ConsumerWidget {
  const AddressCardv2({
    super.key,
    required this.address,
    required this.isSelected,
  });
  final Address address;
  final bool isSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: MediaQuery.of(context).size.height/3,
        width: MediaQuery.of(context).size.width*10,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.h),
          border: Border.all(color: AppColors.gray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_pin,
              color: AppColors.black,
              size: 24.h,
            ),
            AppSpacerW(8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: address.addressName != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [

                  Text(
                    AppGFunctions.processAdAddess(address),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 15.h,
              ),
          ],
        ),
      ),
    );
  }
}
