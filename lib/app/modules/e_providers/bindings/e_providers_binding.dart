import 'package:get/get.dart';

import '../../Albums/controllers/AlbumController.dart';
import '../../Portfolio/controllers/portfolioController.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/e_provider_form_controller.dart';
import '../controllers/e_providers_controller.dart';

class EProvidersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EProvidersController>(
      EProvidersController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<EProviderFormController>(
      () => EProviderFormController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
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
