import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart'; 
import 'package:laundry_customer/models/package_model/all_packages_model.dart';
import 'package:laundry_customer/models/package_model/package_details_model.dart';
import 'package:laundry_customer/models/package_model/add_package_model.dart';
import 'package:laundry_customer/models/package_model/package_place_model.dart';
import 'package:laundry_customer/models/schedules_model/schedules_model.dart'; 
import 'package:laundry_customer/services/api_service.dart';

abstract class IPackageRepo {
  Future<AllPackagesModel> getAllPackages(String status);
  Future<AddPackageModel> addPackage(PackagePlaceModel packagePlaceModel); 
  Future<PackageDetailsModel> getPackageDetails(String id); 
}

class PackageRepo implements IPackageRepo {
  final Dio _dio = getDio();

  @override
  Future<AllPackagesModel> getAllPackages(String status) async {
    Map<String, dynamic> qp = {};

    if (status != '') {
      qp = {'status': status};
    }
    final Response response = await _dio.get('/packages', queryParameters: qp);
    return AllPackagesModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<AddPackageModel> addPackage(PackagePlaceModel packagePlaceModel) async {
    final response = await _dio.post(
      '/add_package',
      data: FormData.fromMap(packagePlaceModel.toMap()),
    );
    print(response.data);
    return AddPackageModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<PackageDetailsModel> getPackageDetails(String id) async {
    try {
      final Response response = await _dio.get(
        '/packages/$id/details',
      );
      return PackageDetailsModel.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
 
}
 
