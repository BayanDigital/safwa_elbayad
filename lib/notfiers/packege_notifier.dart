import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_customer/models/package_model/add_package_model.dart';
import 'package:laundry_customer/models/package_model/all_packages_model.dart';
import 'package:laundry_customer/models/package_model/package_details_model.dart';
 import 'package:laundry_customer/models/package_model/package_place_model.dart';
 import 'package:laundry_customer/repos/package_repo.dart';
import 'package:laundry_customer/services/api_state.dart';
import 'package:laundry_customer/services/network_exceptions.dart';

class AllPackageNotifier extends StateNotifier<ApiState<AllPackagesModel>> {
  AllPackageNotifier(this._repo, this._filter)
      : super(const ApiState.initial()) {
    getAllPackages();
  }
  final IPackageRepo _repo;
  final String _filter;
  Future<void> getAllPackages() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.getAllPackages(_filter));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class PackegaDetailsNotifier extends StateNotifier<ApiState<PackageDetailsModel>> {
  PackegaDetailsNotifier(this._repo, this._id) : super(const ApiState.initial()) {
    getPackegaDetails();
  }
  final IPackageRepo _repo;
  final String _id;
  Future<void> getPackegaDetails() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.getPackageDetails(_id));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class PlacePackegeNotifier extends StateNotifier<ApiState<AddPackageModel>> {
  PlacePackegeNotifier(
    this._repo,
  ) : super(const ApiState.initial());
  final IPackageRepo _repo;

 
  Future<void> addPackege(PackagePlaceModel packagePlaceModel) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.addPackage(packagePlaceModel));
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
 
 
 