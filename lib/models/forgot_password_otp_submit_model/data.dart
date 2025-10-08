import 'dart:convert';

class Data {
  String? otp;
  String? token;

  Data({this.otp, this.token});

  @override
  String toString() => 'Data(otp: $otp, token: $token)';

  factory Data.fromMap(Map<String, dynamic> data) => Data(
    otp: data['otp']?.toString(),
    token: data['token'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'otp': otp,
    'token': token,
  };

  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());
}
