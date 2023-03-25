import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/certificate_edit.dart';
import '../../../models/e_provider_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class CertificateEditController extends GetxController {
  GlobalKey<FormState> certificateForm;
  final certificateTileList = [];
  final certificateDesList = [];
  final certificateTitle = "".obs;
  final certificateDes = "".obs;
  final certificateUrl = "".obs;
  final certificateId = "".obs;
  UploadRepository _uploadRepository;
  UserRepository _userRepository;
  EProviderRepository _eProviderRepository;
  final eProvider = <EProvider>[].obs;

  CertificateEditController() {
    _userRepository = new UserRepository();
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    certificateTitle.value = arguments['title'];
    certificateDes.value = arguments['des'];
    certificateUrl.value = arguments['url'];
    certificateId.value = arguments['id'];
    await loadEProviders();
    // loadEProviders();
    super.onInit();
  }

  // Future refreshProfile({bool showMessage}) async {
  //
  //   if (showMessage == true) {
  //     Get.showSnackbar(Ui.SuccessSnackBar(
  //         message: "List of faqs refreshed successfully".tr));
  //   }
  // }

  void loadEProviders() async {
    try {
      List<EProvider> eProviders = [];
      print("this is the load eprovider call");

      eProviders = await _eProviderRepository.getEProviders(page: 1);

      if (eProviders.isNotEmpty) {
        eProvider.value = eProviders;
      } else {}
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> certificates() async {
    // await loadEProviders();
    Get.focusScope.unfocus();

    if (certificateForm.currentState.validate()) {
      certificateForm.currentState.save();
      try {
        final _certificate = new CertificateEdit(
          desc: certificateDes.value,
          title: certificateTitle.value,
          e_provider_id: eProvider.value[0].id,
        );
        print("check this details $certificateDesList");
        print("check this details $certificateTileList");
        await _eProviderRepository.certificateEdit(
            _certificate, certificateId.value);
        await Get.offAndToNamed(Routes.CertificatesView);
        // await Get.toNamed(Routes.ROOT, arguments: 0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }
}
