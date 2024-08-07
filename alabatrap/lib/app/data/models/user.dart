import '../../core/util/func/gen_address.dart';

class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phone;
  String? birthday;
  int? addressId;
  Address? address;
  String? addressDetail;
  Location? location;
  String? medicalStory;
  String? avatarUrl;
  double? averageRating;
  int? postTotal;
  int? favoriteTotal;
  int? contribution;
  int? volumnTotal;
  int? roleCode;
  String? refreshToken;
  String? deviceKey;
  DateTime? createdAt;
  DateTime? updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.phone,
      this.birthday,
      this.addressId,
      this.address,
      this.addressDetail,
      this.location,
      this.medicalStory,
      this.avatarUrl,
      this.averageRating,
      this.postTotal,
      this.favoriteTotal,
      this.contribution,
      this.volumnTotal,
      this.roleCode,
      this.refreshToken,
      this.deviceKey,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    username = json['username'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'].toString();
    birthday = json['birthday'];
    addressId = json['address_id'];
    address = json['address'] is Map<String, dynamic>
        ? Address.fromJson(json['address'])
        : null;
    addressDetail = generateAddressDetail(address);
    location = json['location'] is Map<String, dynamic>
        ? Location.fromJson(json['location'])
        : null;
    medicalStory = json['medical_story'];
    avatarUrl = json['avatar_url'];
    averageRating = json['average_rating']?.toDouble();
    postTotal = json['post_total'];
    favoriteTotal = json['favorite_total'];
    contribution = json['contribution'];
    volumnTotal = json['volumn_total'];
    roleCode = json['role_code'];
    refreshToken = json['refresh_token'];
    deviceKey = json['device_key'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['birthday'] = birthday;
    data['address_id'] = addressId;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['medical_story'] = medicalStory;
    data['avatar_url'] = avatarUrl;
    data['average_rating'] = averageRating;
    data['post_total'] = postTotal;
    data['favorite_total'] = favoriteTotal;
    data['contribution'] = contribution;
    data['volumn_total'] = volumnTotal;
    data['role_code'] = roleCode;
    data['refresh_token'] = refreshToken;
    data['device_key'] = deviceKey;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}

class Location {
  double? lat;
  double? long;

  Location({this.lat, this.long});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class Address {
  int? id;
  String? city;
  String? district;
  String? ward;
  String? detail;

  Address({this.id, this.city, this.district, this.ward, this.detail});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    district = json['district'];
    ward = json['ward'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['district'] = district;
    data['ward'] = ward;
    data['detail'] = detail;
    return data;
  }
}
