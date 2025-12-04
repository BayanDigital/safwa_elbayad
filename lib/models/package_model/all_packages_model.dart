import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:laundry_customer/models/package_model/data.dart';

class AllPackagesModel {
  String? message;
  Data? data;

  AllPackagesModel({this.message, this.data});

  @override
  String toString() => 'AllPackagesModel(message: $message, data: $data)';

  factory AllPackagesModel.fromMap(Map<String, dynamic> data) {
    return AllPackagesModel(
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
  /// Parses the string and returns the resulting Json object as [AllPackagesModel].
  factory AllPackagesModel.fromJson(String data) {
    return AllPackagesModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AllPackagesModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AllPackagesModel copyWith({
    String? message,
    Data? data,
  }) {
    return AllPackagesModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AllPackagesModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}
