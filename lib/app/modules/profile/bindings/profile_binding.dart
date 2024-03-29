import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../e_providers/controllers/e_provider_availability_form_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut(() => EProviderAvailabilityFormController());
  }
}
