import 'dart:convert';

import 'package:laundry_customer/models/package_model/data.dart';

 
class AddPackageModel {
  String? message;
  Data? data;

  AddPackageModel({this.message, this.data});

  factory AddPackageModel.fromMap(Map<String, dynamic> data) => AddPackageModel(
        message: data['msg'] as String?,
        data: data['data'] == null
            ? null
            : Data.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AddPackageModel].
  factory AddPackageModel.fromJson(String data) {
    return AddPackageModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AddPackageModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
