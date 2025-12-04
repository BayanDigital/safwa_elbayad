import 'dart:convert';

import 'package:laundry_customer/models/order_details_model/data.dart';

class PackageDetailsModel {
  String? message;
  Data? data;

  PackageDetailsModel({this.message, this.data});

  factory PackageDetailsModel.fromMap(Map<String, dynamic> data) {
    return PackageDetailsModel(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PackageDetailsModel].
  factory PackageDetailsModel.fromJson(String data) {
    return PackageDetailsModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PackageDetailsModel] to a JSON string.
  String toJson() => json.encode(toMap());

  PackageDetailsModel copyWith({
    String? message,
    Data? data,
  }) {
    return PackageDetailsModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
