import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_provider/app/modules/auth/views/terms_&_condition.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class EmailVerification extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Form(
        key: controller.loginFormKey,
        child: ListView(
          primary: true,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 180,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.secondary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.focusColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _settings.providerAppName,
                          style: Get.textTheme.headline6.merge(TextStyle(
                              color: Get.theme.primaryColor, fontSize: 24)),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Welcome to the best service provider system!".tr,
                          style: Get.textTheme.caption
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                          textAlign: TextAlign.center,
                        ),
                        // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: Ui.getBoxDecoration(
                    radius: 14,
                    border: Border.all(width: 5, color: Get.theme.primaryColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.loading.isTrue)
                return CircularLoadingWidget(height: 300);
              else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        'We sent an Email to your Email Address check yoour Mail inbox also spam and varify first then log in to our App ')
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
