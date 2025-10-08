class BestSeller {
  final int id;
  final String name;
  final String image;
  final double price;

  BestSeller({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  factory BestSeller.fromJson(Map<String, dynamic> json) {
    return BestSeller(
      id: json['id'] as int ,
      name: json['name'] as String ,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
