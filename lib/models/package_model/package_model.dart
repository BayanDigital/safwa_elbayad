import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Package {
  final String name;
  final String desc;
  final String price;

  Package({required this.name, required this.desc, required this.price});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      name: json['name'] as String,
      desc: json['desc'] as String,
      price: json['price'].toString(),
    );
  }
}

class PackageService {
  final Dio _dio = Dio();

  Future<List<Package>> fetchPackages() async {
    final response = await _dio.get('https://safwa.yoofiy.com/api/packages');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['packages'] as List<dynamic>;
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
