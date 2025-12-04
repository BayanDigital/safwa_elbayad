import 'dart:convert';

 import 'package:laundry_customer/models/package_model/package_model.dart';

class Data {
  Package? package;

  Data({this.package});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        package: data['package'] == null
            ? null
            : Package.fromJson(data['package'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'package': package?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
