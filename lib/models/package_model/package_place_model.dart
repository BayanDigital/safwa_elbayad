// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PackagePlaceModel {
  String pick_date;
  String pick_hour;
  String delivery_date;
  String delivery_hour;
  String address_id;
  String? package_id;
  String? user_id;
  String? instruction;
  List<String> additional_service_id;
  PackagePlaceModel({
    required this.pick_date,
    required this.pick_hour,
    required this.delivery_date,
    required this.delivery_hour,
    required this.address_id,
    this.package_id,
    this.user_id,
    this.instruction,
    required this.additional_service_id,
  });

  PackagePlaceModel copyWith({
    String? pick_date,
    String? pick_hour,
    String? delivery_date,
    String? delivery_hour,
    String? address_id,
    String? package_id,
    String? user_id,
    String? instruction,
    List<String>? additional_service_id,
  }) {
    return PackagePlaceModel(
      pick_date: pick_date ?? this.pick_date,
      pick_hour: pick_hour ?? this.pick_hour,
      delivery_date: delivery_date ?? this.delivery_date,
      delivery_hour: delivery_hour ?? this.delivery_hour,
      address_id: address_id ?? this.address_id,
      package_id: package_id ?? this.package_id,
      user_id: user_id ?? this.user_id,
      instruction: instruction ?? this.instruction,
      additional_service_id:
          additional_service_id ?? this.additional_service_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pick_date': pick_date,
      'pick_hour': pick_hour,
      'delivery_date': delivery_date,
      'delivery_hour': delivery_hour,
      'address_id': address_id,
      'package_id': package_id,
      'user_id': user_id,
      'instruction': instruction,
      'additional_service_id': additional_service_id,
    };
  }

  factory PackagePlaceModel.fromMap(Map<String, dynamic> map) {
    return PackagePlaceModel(
      pick_date: map['pick_date'] as String,
      pick_hour: map['pick_hour'] as String,
      delivery_date: map['delivery_date'] as String,
      delivery_hour: map['delivery_hour'] as String,
      address_id: map['address_id'] as String,
      package_id:
          map['package_id'] != null ? map['package_id'] as String : null,
      user_id:
          map['user_id'] != null ? map['user_id'] as String : null,
      instruction:
          map['instruction'] != null ? map['instruction'] as String : null,
      additional_service_id: List<String>.from(
        map['additional_service_id'] as List<String>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackagePlaceModel.fromJson(String source) =>
      PackagePlaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PackagePlaceModel(pick_date: $pick_date, pick_hour: $pick_hour, delivery_date: $delivery_date, delivery_hour: $delivery_hour,   address_id: $address_id, package_id: $package_id, instruction: $instruction, additional_service_id: $additional_service_id)';
  }

  @override
  bool operator ==(covariant PackagePlaceModel other) {
    if (identical(this, other)) return true;

    return other.pick_date == pick_date &&
        other.pick_hour == pick_hour &&
        other.delivery_date == delivery_date &&
        other.delivery_hour == delivery_hour &&
        other.address_id == address_id &&
        other.package_id == package_id &&
        other.user_id == user_id &&
        other.instruction == instruction &&
        listEquals(other.additional_service_id, additional_service_id);
  }

  @override
  int get hashCode {
    return pick_date.hashCode ^
        pick_hour.hashCode ^
        delivery_date.hashCode ^
        delivery_hour.hashCode ^
        address_id.hashCode ^
        package_id.hashCode ^
        user_id.hashCode ^
        instruction.hashCode ^
        additional_service_id.hashCode;
  }
}
