import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Package {
  final int? id;
  final String? name;
  final String? desc;
  final String? price;
  Package({
    this.id,
    this.name,
    this.desc,
    this.price,
  });

  Package copyWith({
    int? id,
    String? name,
    String? desc,
    String? price,
  }) {
    return Package(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'price': price,
    };
  }

  factory Package.fromJson(Map<String, dynamic> map) {
    return Package(
      id: map['id'] as int?,
      name: map['name'].toString(),
      desc: map['desc'].toString(),
      price: map['price'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Package(name: $name, desc: $desc, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Package &&
        other.id == id &&
        other.name == name &&
        other.desc == desc &&
        other.price == price;
  }

  @override
  int get hashCode =>
      name.hashCode ^ desc.hashCode ^ price.hashCode ^ id.hashCode;
}

class PackageService {
  final Dio _dio = Dio();

  Future<List<Package>> fetchPackages() async {
    final response = await _dio.get('https://safwa.yoofiy.com/api/packages');
    print(response.data);
    if (response.statusCode == 200) {
      final List<dynamic> data =
          response.data['data']['packages'] as List<dynamic>;
      return data
          .map((json) => Package.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('فشل تحميل الباقات');
    }
  }
}

final packageServiceProvider = Provider<PackageService>((ref) {
  return PackageService();
});

final packageListProvider = FutureProvider<List<Package>>((ref) async {
  final service = ref.read(packageServiceProvider);
  return await service.fetchPackages();
});
