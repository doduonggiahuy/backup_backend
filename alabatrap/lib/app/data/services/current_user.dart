import 'dart:convert';
import 'package:get/get.dart';

import '../../core/util/func/parse_data_string.dart';
import '../../routes/app_pages.dart';
import '../models/user.dart';
import 'firebase_service.dart';
import 'storage_manager.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  final Rxn<User> _currentUser = Rxn<User>();

  factory CurrentUser() {
    return _instance;
  }

  CurrentUser._internal();

  Future<void> init() async {
    String? userData = Storage.get('user_data');
    if (userData != null) {
      Map<String, dynamic> userMap = parseDataString(userData);
      _currentUser.value = User.fromJson(userMap);
    }
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser.value = user;
    String userData = jsonEncode(user.toJson());
    await Storage.set('user_data', userData);
  }

  User? get currentUser => _currentUser.value;

  String? get id => _currentUser.value?.id;
  String? get username => _currentUser.value?.username;
  String? get email => _currentUser.value?.email;
  String? get password => _currentUser.value?.password;
  String? get phone => _currentUser.value?.phone;
  String? get birthday => _currentUser.value?.birthday;
  int? get addressId => _currentUser.value?.addressId;
  Address? get address => _currentUser.value?.address;
  String? get addressDetail => _currentUser.value?.addressDetail;
  Location? get location => _currentUser.value?.location;
  String? get medicalStory => _currentUser.value?.medicalStory;
  RxString? get avatarUrl => _currentUser.value?.avatarUrl?.obs;
  double? get averageRating => _currentUser.value?.averageRating;
  int? get postTotal => _currentUser.value?.postTotal;
  int? get favoriteTotal => _currentUser.value?.favoriteTotal;
  int? get contribution => _currentUser.value?.contribution;
  int? get volumnTotal => _currentUser.value?.volumnTotal;
  int? get roleCode => _currentUser.value?.roleCode;
  String? get refreshToken => _currentUser.value?.refreshToken;
  String? get deviceKey => _currentUser.value?.deviceKey;
  DateTime? get createdAt => _currentUser.value?.createdAt;
  DateTime? get updatedAt => _currentUser.value?.updatedAt;

  Future<void> clearCurrentUser() async {
    _currentUser.value = null;
    Storage.remove('user_data');
  }

  Future<void> updateAvatar(String avatarUrl) async {
    if (_currentUser.value != null) {
      _currentUser.value!.avatarUrl = avatarUrl;
      String userData = jsonEncode(_currentUser.value!.toJson());
      await Storage.set('user_data', userData);
      _currentUser.refresh();
    }
  }

  Future<void> logout() async {
    CurrentUser().clearCurrentUser();
    FirebaseServices().googleSignOut();
    FirebaseServices().facebookSignOut();
    Get.toNamed(Routes.AUTH);
  }
}
