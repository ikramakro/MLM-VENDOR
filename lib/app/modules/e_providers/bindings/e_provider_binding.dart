import 'package:get/get.dart';

import '../../Albums/controllers/AlbumController.dart';
import '../../Portfolio/View/portfolio.dart';
import '../../Portfolio/controllers/portfolioController.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';
import '../controllers/e_provider_addresses_form_controller.dart';
import '../controllers/e_provider_availability_form_controller.dart';
import '../controllers/e_provider_controller.dart';
import '../controllers/e_provider_e_services_controller.dart';
import '../controllers/e_provider_form_controller.dart';

class EProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EProviderController>(
      () => EProviderController(),
    );
    Get.lazyPut<EProviderFormController>(
      () => EProviderFormController(),
    );
    Get.lazyPut<EProviderAddressesFormController>(
      () => EProviderAddressesFormController(),
    );
    Get.lazyPut<EProviderAvailabilityFormController>(
      () => EProviderAvailabilityFormController(),
    );
    Get.lazyPut<EProviderEServicesController>(
      () => EProviderEServicesController(),
    );
    Get.lazyPut<AlbumController>(
      () => AlbumController(),
    );
    Get.lazyPut<PortfolioController>(
      () => PortfolioController(),
    );
    Get.lazyPut<AlbumViewController>(
      () => AlbumViewController(),
    );
  }
}
