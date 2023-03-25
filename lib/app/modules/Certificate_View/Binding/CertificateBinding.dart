import 'package:get/get.dart';

import '../Controller/certificate_view_Controller.dart';

class CertificateViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CertificatesViewController>(
      CertificatesViewController(),
    );
  }
}
