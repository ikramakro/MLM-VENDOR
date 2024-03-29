import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../e_providers/controllers/e_providers_controller.dart';
import '../../e_services/controllers/e_services_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../reviews/controllers/review_controller.dart';
import '../../reviews/controllers/reviews_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RootController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.lazyPut<BookingController>(
      () => BookingController(),
    );
    Get.put<EServicesController>(
      EServicesController(),
    );
    Get.put<EProvidersController>(
      EProvidersController(),
    );

    Get.lazyPut<ReviewsController>(
      () => ReviewsController(),
    );
    Get.lazyPut<ReviewController>(
      () => ReviewController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
      fenix: true,
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
    Get.lazyPut<EProvidersController>(
      () => EProvidersController(),
    );
  }
}
