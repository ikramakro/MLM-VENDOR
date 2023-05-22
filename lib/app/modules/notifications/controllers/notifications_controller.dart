import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/notification_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../root/controllers/root_controller.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  NotificationRepository _notificationRepository;
  final list = [].obs;

  NotificationsController() {
    _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    await getNotifications();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {
      notifications.assignAll(await _notificationRepository.getAll());
      // for (int i = 0; i <= notifications.length; i++) {
      //   if (notifications[i].type == 'App\\Notifications\\NewMessage') {
      //     list.add(i);
      //     Get.log("counter is ${list.length}");
      //   } else {}
      // }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeNotification(Notification notification) async {
    try {
      await _notificationRepository.remove(notification);
      if (!notification.read) {
        --Get.find<RootController>().notificationsCount.value;
      }
      notifications.remove(notification);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future markAsReadNotification(Notification notification) async {
    try {
      if (!notification.read) {
        await _notificationRepository.markAsRead(notification);
        notification.read = true;
        --Get.find<RootController>().notificationsCount.value;
        notifications.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
