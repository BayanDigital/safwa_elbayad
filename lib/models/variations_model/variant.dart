import 'dart:convert';

class Variant {
  int? id;
  String? name;
  dynamic nameBn;
  String? image;

  Variant({this.id, this.name, this.nameBn,this.image});

  @override
  String toString() => 'Variant(id: $id, name: $name, nameBn: $nameBn,image: $image)';

  factory Variant.fromMap(Map<String, dynamic> data) => Variant(
        id: data['id'] as int?,
        name: data['name'] as String?,
        nameBn: data['name_bn'] as dynamic,
    image: data['image'] as String?,

  );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'name_bn': nameBn,
    'image': image,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Variant].
  factory Variant.fromJson(String data) {
    return Variant.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Variant] to a JSON string.
  String toJson() => json.encode(toMap());

  Variant copyWith({
    int? id,
    String? name,
    dynamic nameBn,
    String? image,
  }) {
    return Variant(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      image: image ?? this.image,
    );
  }
}
