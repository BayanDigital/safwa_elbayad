import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:laundry_customer/models/package_model/add_package_model.dart';
import 'package:laundry_customer/models/package_model/package_details_model.dart'; 
 import 'package:laundry_customer/notfiers/packege_notifier.dart'; 
import 'package:laundry_customer/repos/package_repo.dart';
import 'package:laundry_customer/services/api_state.dart';

final packageRepoProvider = Provider<IPackageRepo>((ref) {
  return  PackageRepo() ;
});

 
 
// final packegeDetailsProvider = StateNotifierProvider.autoDispose
//     .family<PackageDetailsNotifier, ApiState<PackageDetailsModel>, String>(
//         (ref, id) {
//   return PackageDetailsNotifier(
//     ref.watch(packageRepoProvider),
//     id,
//   );
// });

final placePackagesProvider = StateNotifierProvider.autoDispose<
    PlacePackegeNotifier, ApiState<AddPackageModel>>((ref) {
  return PlacePackegeNotifier(
    ref.watch(packageRepoProvider),
  );
});

 
final packageProcessingProvider = StateProvider<bool>((ref) {
  return false;
});
