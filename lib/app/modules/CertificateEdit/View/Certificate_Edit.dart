import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/CertificateEditTextField.dart';
import '../../global_widgets/CertificateTextField.dart';
import '../Controller/Certificate_Edit_Controller.dart';

class CertificateEdit extends GetView<CertificateEditController> {
  final bool hideAppBar;

  CertificateEdit({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    controller.certificateForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Certificate".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    controller.certificates();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.certificateForm,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Certificate Edit".tr,
                                  style: Get.textTheme.headline5)
                              .paddingOnly(
                                  top: 25, bottom: 0, right: 22, left: 22),
                          Text(
                                  "Edit Title and Description of your Certificates"
                                      .tr,
                                  style: Get.textTheme.caption)
                              .paddingSymmetric(horizontal: 22, vertical: 5),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    // height: controller.size.value.toDouble(),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 20, right: 20),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 0),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        children: [
                          Container(
                              height: 500,
                              child: ListView.builder(
                                itemCount: 1,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: CachedNetworkImage(
                                                height: 170,
                                                width: 170,
                                                fit: BoxFit.fill,
                                                imageUrl: controller
                                                    .certificateUrl.value,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  'assets/img/loading.gif',
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  height: 130,
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Icon(Icons.error_outline),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Obx(
                                        () => CertificateTitleTextFieldWidget(
                                          initialValue:
                                              controller.certificateTitle.value,
                                          isFirst: false,

                                          onSaved: (input) {
                                            controller.certificateTitle.value =
                                                input;
                                          },
                                          validator: (input) => input.length < 3
                                              ? "Should be more than 3 characters"
                                                  .tr
                                              : null,
                                          keyboardType: TextInputType.multiline,
                                          // initialValue: controller.eProvider.value.description,
                                          hintText:
                                              "Title for Certificate Image".tr,
                                          labelText: "*Title".tr,
                                        ),
                                      ),
                                      CertificateTextFieldWidget(
                                        isFirst: false,
                                        initialValue:
                                            controller.certificateDes.value,

                                        onSaved: (input) {
                                          controller.certificateDes.value =
                                              input;
                                        },
                                        validator: (input) => input.length < 3
                                            ? "Should be more than 3 characters"
                                                .tr
                                            : null,
                                        keyboardType: TextInputType.multiline,
                                        // initialValue: controller.eProvider.value.description,
                                        hintText:
                                            "Description for Certificate Image"
                                                .tr,
                                        labelText: "*Description".tr,
                                      ),
                                    ],
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
