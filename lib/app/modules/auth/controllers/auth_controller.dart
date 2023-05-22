import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/single_select_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey;
  final eProvider = EProvider().obs;
  final eProviderTypes = <EProviderType>[].obs;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final selectedCategory = <Category>[Category(id: '1')].obs;
  final selectedCategoryName = "".obs;
  final selectedCategoryId = "".obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  CategoryRepository _categoryRepository;
  UserRepository _userRepository;
  final categories = <Category>[].obs;
  final SelectedCategoryName = "".obs;
  final SelectedCategoryId = "".obs;
  EProviderRepository _eProviderRepository;
  final checkBoxValue = false.obs;

  AuthController() {
    _userRepository = UserRepository();
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
  }
  List<SingleSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    return categories.map((element) {
      return SingleSelectDialogItem(element, element.name);
    }).toList();
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviderTypes() async {
    try {
      eProviderTypes.assignAll(await _eProviderRepository.getEProviderTypes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<EProviderType>> getSelectProviderTypesItems() {
    return eProviderTypes.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  @override
  void onInit() async {
    await getCategories();
    await getEProviderTypes();
    // TODO: implement onInit
    super.onInit();
  }

  Future createEProviderForm() async {
    // Get.focusScope.unfocus();
    eProvider.value.name = currentUser.value.name;
    eProvider.value.phoneNumber = currentUser.value.phoneNumber;
    eProvider.value.employees = [currentUser.value];

    print("creating provider ${eProvider.value.toString()}");
    try {
      final _eProvider = await _eProviderRepository.create(eProvider.value);
      eProvider.value.id = _eProvider.id;
      // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM,
      //     arguments: {'eProvider': _eProvider});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  // void updateEProviderForm() async {
  //   print("updateEProvider is trigger");
  //   Get.focusScope.unfocus();
  //   try {
  //     await _eProviderRepository.update(eProvider.value);
  //     await SendEmail();
  //
  //     // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM,
  //     //     arguments: {'eProvider': _eProvider});
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {}
  // }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();

        currentUser.value = await _userRepository.login(currentUser.value);
        if (currentUser.value != null) {
          await _userRepository.signInWithEmailAndPassword(
              currentUser.value.email, currentUser.value.apiToken);
          loading.value = false;
          if (Get.find<ProfileController>().user.value.isProvider) {
            await Get.find<HomeController>().refreshHome();
          }

          await Get.toNamed(Routes.ROOT, arguments: 0);
        } else {
          loginFormKey.currentState.reset();
          loading.value = false;
        }
      } catch (e) {
        if (e.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Account not Found"));
        }
        Get.showSnackbar(Ui.ErrorSnackBar(
            message:
                'These credential donot match our records. Please check the details and try again'));
      } finally {
        loading.value = false;
      }
    }
  }

  // Future<bool> checkIfEmailExists(String email) async {
  //   final response = await http.get(
  //       Uri.parse('https://admin.mylocalmesh.co.uk/api/check_email$email'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return data['data'];
  //   } else {
  //     throw Exception('Failed to check email existence');
  //   }
  // }
  Future saveUserData(String uid, String id) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection('Vendors').doc(uid).set({
      'uid': uid,
      'id': id,
      'status': false,
    }).catchError((e) {
      print('error');
      print(e.toString());
    });
  }

  Future register() async {
    print("register is trigger");
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      if (checkBoxValue.value) {
        String isvalidemail =
            await _userRepository.checkEmail(currentUser.value.email);
        if (isvalidemail == "True") {
          Get.showSnackbar(Ui.ErrorSnackBar(
              message:
                  'an account already exist with this email.please try another email or login with existing account'));
        } else {
          String checkNum =
              await _userRepository.checkNum(currentUser.value.phoneNumber);
          print("status phone num $checkNum");
          if (checkNum == "False") {
            loading.value = true;
            try {
              if (Get.find<SettingsService>().setting.value.enableOtp) {
                print("this is running first");
                await _userRepository.sendCodeToPhone();
                loading.value = false;
                await Get.toNamed(Routes.PHONE_VERIFICATION);
              } else {
                print("this is running second");
                await Get.find<FireBaseMessagingService>().setDeviceToken();
                currentUser.value =
                    await _userRepository.register(currentUser.value);
                await _userRepository.signUpWithEmailAndPassword(
                    currentUser.value.email, currentUser.value.apiToken);
                // await SendEmail();

                loading.value = false;
              }
            } catch (e) {
              Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
            } finally {
              loading.value = false;
            }
          } else {
            Get.showSnackbar(Ui.ErrorSnackBar(message: "Number already used"));
          }
        }
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Check Terms & Condition'));
      }
    }
  }

  // Future SendEmail() async {
  //   try {
  //     await _eProviderRepository.sendEmail(currentUser.value.email);
  //     // await Get.offAllNamed(Routes.LOGIN);
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email, currentUser.value.apiToken);
      // await createEProviderForm();

      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              "E-Mail verification link was sent successfully to your MailBox"));

      loading.value = false;
      await Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      loading.value = false;
      Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  void acceptGoogleTerms() {
    checkBoxValue.value = false;
    Get.defaultDialog(
      radius: 10,
      title: "Accept Terms & Conditions",
      middleText: "This is compulsory to create account.",
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  LauchUrlAddress("https://eziec.com/terms");
                },
                child: Text(
                  'Terms & Conditions',
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Obx(() => Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(
                      Get.theme.colorScheme.secondary),
                  value: checkBoxValue.value,
                  onChanged: (v) {
                    checkBoxValue.value = v;
                    if (v == true) {
                      signInWithGoogle1();
                    }
                    Get.back();
                  })),
            ],
          ),
        ),
      ],
    );
  }

  Future signInWithGoogle1() async {
    if (await GoogleSignIn().isSignedIn()) {
      print("google already loginid");
      await GoogleSignIn().signOut();
    }

    final GoogleSignInAccount googleSignInAccount = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    ).signIn();

    // assert(!user.isAnonymous);
    // assert(await user.getIdToken() != null);
    //
    // final User currentUser = FirebaseAuth.instance.currentUser;
    // assert(user.uid == currentUser.uid);

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final auth.OAuthCredential credential =
          auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final auth.UserCredential authResult =
          await auth.FirebaseAuth.instance.signInWithCredential(credential);
      final auth.User user = authResult.user;

      currentUser.value.password = "123";
      currentUser.value.email = user.email;
      currentUser.value.name = user.displayName ?? '';
      String randomnumber = "";
      Random random = new Random();
      for (int i = 0; i < 10; i++) {
        int n = random.nextInt(10);
        randomnumber = randomnumber + "" + n.toString();
      }
      currentUser.value.phoneNumber =
          user.phoneNumber ?? '+92' + randomnumber.toString();
      // currentUser.value.phoneNumber = user.phoneNumber??'+920000000000';

      UserLoginInMSQL();
    } else {
      print("cannot verify");
    }
  }

  Future RegisterOnMYSQL() async {
    currentUser.value = await _userRepository.register(currentUser.value);
    currentUser.value.password = "123";
    currentUser.value = await _userRepository.login(currentUser.value);
    if (currentUser.value.hasData) {
      print("Login successfull");
      try {
        Get.lazyPut(() => RootController());
        await Get.find<RootController>().changePage(0);
      } catch (e) {
        // print(e);
        loading.value = false;
      }
    }
  }

  Future UserLoginInMSQL() async {
    loading.value = true;
    try {
      currentUser.value.password = "123";

      print("-----------");
      print(currentUser.value.email);
      print(currentUser.value.password);
      // Get.log(currentUser.value.roles.toString());
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      Get.log(' Current User rrrrrrrrrrrrrr  ${currentUser.value.toString()}');
      currentUser.value = await _userRepository.login(currentUser.value);
      if (currentUser.value.hasData) {
        print("Login successfull");
        try {
          Get.lazyPut(() => RootController());
          await Get.find<RootController>().changePage(0);
        } catch (e) {
          // print(e);
          loading.value = false;
        }
      }
    } catch (e) {
      print(e);
      // Get.showSnackbar(Ui.ErrorSnackBar(message: "Email or Password is Incorrect."));
      RegisterOnMYSQL();
    } finally {
      loading.value = false;
    }
  }

  Future<void> LauchUrlAddress(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
