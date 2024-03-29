import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/AlbumPortfolio_model.dart';
import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  LaravelApiClient _laravelApiClient;
  FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> login(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<PortfolioAlbum> portfolioAlbum(
    PortfolioAlbum portfolio,
  ) {
    return _laravelApiClient.portfolioAlbumCreate(portfolio);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> checkOldPassword(String password) {
    Get.log('User repo Checking Old Passord ');
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.checkOldPassword(password);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

  Future<void> deleteCurrentUser() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _laravelApiClient.deleteUser(Get.find<AuthService>().user.value);
    await _firebaseProvider.deleteCurrentUser();
    Get.find<AuthService>().user.value = new User();
    GetStorage().remove('current_user');
  }

  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future<String> checkNum(String num) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUserPhone(num);
  }

  Future<String> checkEmail(String email) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUserEmail(email);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
