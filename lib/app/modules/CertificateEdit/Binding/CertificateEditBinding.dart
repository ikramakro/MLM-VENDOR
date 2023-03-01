import 'package:get/get.dart';

import '../Controller/Certificate_Edit_Controller.dart';

class CertificateEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificateEditController>(
      () => CertificateEditController(),
    );
  }
}
