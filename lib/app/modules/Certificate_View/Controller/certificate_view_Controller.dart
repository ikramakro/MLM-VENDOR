import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/experience_model_View.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';

class CertificatesViewController extends GetxController {
  UploadRepository _uploadRepository;
  final eProvider = EProvider().obs;
  final experiences = <ExperienceView>[].obs;
  final isDeletable = false.obs;
  final selectedList = <ExperienceView>[].obs;

  UserRepository _userRepository;
  EProviderRepository _eProviderRepository;

  CertificatesViewController() {
    _userRepository = new UserRepository();
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    // loadEProviders();
    await loadEProviders();
    await getExperiences();
    super.onInit();
  }

  Future refreshCertificate({bool showMessage}) async {
    print("this is running refreshing crtificate");
    await getExperiences();
    if (showMessage == true) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Certificate refreshed successfully".tr));
    }
  }

  void loadEProviders() async {
    try {
      List<EProvider> eProviders = [];
      print("this is the load eprovider call");

      eProviders = await _eProviderRepository.getEProviders(page: 1);

      if (eProviders.isNotEmpty) {
        eProvider.value = eProviders[0];
        print("eprovider id is${eProviders[0].id}");
        await getExperiences();
        // await getEProvider(_eProviders[0].id);
      } else {}
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getExperiences() async {
    try {
      experiences.assignAll(
          await _eProviderRepository.getCertificate(eProvider.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future delExperiences(String certID, String eProviderId) async {
    try {
      await _eProviderRepository.delCertificate(certID, eProviderId);

      await getExperiences();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Certificate Removed Successfully"));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
