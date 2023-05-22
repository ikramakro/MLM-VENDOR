import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../Controller/EditPorfolioController.dart';

class EditPortfolio extends GetView<EditPortfolioController> {
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Obx(
      //   () => controller.editable.value == true
      //       ? SizedBox()
      //       : new FloatingActionButton(
      //           child: new Icon(Icons.edit,
      //               size: 28, color: Get.theme.primaryColor),
      //           onPressed: () => {
      //             controller.editable.value = true,
      //             // controller.editable.value == false
      //             //     ? controller.editable.value = true
      //             //     : controller.deletePortfolio(controller.galleries.value.id),
      //             // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
      //             // Get.toN,
      //           },
      //           backgroundColor: Get.theme.colorScheme.secondary,
      //         ).paddingOnly(bottom: 0),
      // ),
      appBar: AppBar(
        title: Text(
          "Portfolio".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
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
                  controller.updatePortfolio();
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

      // body: SafeArea(
      //     child: Stack(
      //   // alignment: AlignmentDirectional.bottomCenter,
      //   children: [
      //     Positioned(
      //       bottom: controller.editable.value ? 200 : 100,
      //       top: 0,
      //       left: 0,
      //       right: 0,
      //       child: Hero(
      //         tag: controller.heroTag.value + controller.current.value.id,
      //         child: CarouselSlider(
      //           carouselController: _controller,
      //           options: CarouselOptions(
      //             autoPlay: false,
      //             viewportFraction: 1.0,
      //             height: double.infinity,
      //             initialPage:
      //                 controller.media.indexOf(controller.current.value),
      //             onPageChanged: (index, reason) {
      //               controller.current.value =
      //                   controller.media.elementAt(index);
      //               controller.galleries.value =
      //                   controller.media.elementAt(index);
      //             },
      //           ),
      //           items: controller.media.map((Media _media) {
      //             return InteractiveViewer(
      //               scaleEnabled: true,
      //               panEnabled: true,
      //               // Set it to false to prevent panning.
      //               minScale: 0.5,
      //               maxScale: 4,
      //               child: Container(
      //                 width: double.infinity,
      //                 alignment: AlignmentDirectional.center,
      //                 child:
      //                     // Stack(
      //                     //   children: [
      //                     ClipRRect(
      //                   borderRadius: BorderRadius.all(Radius.circular(10)),
      //                   child: CachedNetworkImage(
      //                     width: double.infinity,
      //                     fit: BoxFit.contain,
      //                     imageUrl: _media.url,
      //                     placeholder: (context, url) =>
      //                         CircularLoadingWidget(height: 200),
      //                     errorWidget: (context, url, error) =>
      //                         Icon(Icons.error_outline),
      //                   ),
      //                 ).marginSymmetric(horizontal: 20),
      //                 // Text(
      //                 //   controller.current.value.name ?? '',
      //                 //   maxLines: 2,
      //                 //   style: Get.textTheme.bodyText2.merge(
      //                 //     TextStyle(
      //                 //       color: Get.theme.primaryColor,
      //                 //       shadows: <Shadow>[
      //                 //         Shadow(
      //                 //           offset: Offset(0, 1),
      //                 //           blurRadius: 6.0,
      //                 //           color: Get.theme.hintColor.withOpacity(0.6),
      //                 //         ),
      //                 //       ],
      //                 //     ),
      //                 //   ),
      //                 // )
      //                 //   ],
      //                 // ),
      //               ),
      //             );
      //           }).toList(),
      //         ),
      //       ),
      //     ),
      //     Obx(
      //       () => Padding(
      //         padding: controller.editable.value
      //             ? EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 360)
      //             : EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 450),
      //         child: Container(
      //           height: 130,
      //           child: Form(
      //             key: controller.portfolioEditForm,
      //             child: TextFieldWidget(
      //               readOnly: !controller.editable.value,
      //               initialValue: controller.galleries.value.name,
      //               isFirst: false,
      //               onSaved: (input) {
      //                 controller.description.value = input;
      //               },
      //               validator: (input) => input.isEmpty
      //                   ? "Should be more than 3 letters".tr
      //                   : null,
      //               keyboardType: TextInputType.multiline,
      //               // initialValue: controller.eProvider.value.description,
      //               // hintText: "Description for Portfolio Image".tr,
      //               labelText: "*Description".tr,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     MaterialButton(
      //       minWidth: 20,
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(20.0)),
      //       color: Colors.orange,
      //       onPressed: () {
      //         _controller.previousPage();
      //       },
      //       child: Icon(Icons.arrow_left),
      //     ),
      //     Positioned(
      //       left: 300,
      //       child: MaterialButton(
      //         minWidth: 20,
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20.0)),
      //         color: Colors.orange,
      //         onPressed: () {
      //           _controller.nextPage();
      //         },
      //         child: Icon(Icons.arrow_right),
      //       ),
      //     ),
      //   ],
      // )),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              Hero(
                tag: controller.heroTag + controller.galleries.value.id,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      // borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                      border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.05))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height / 100 * 50,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      imageUrl: controller.galleries.value.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 100,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
              Form(
                key: controller.portfolioEditForm,
                child: TextFieldWidget(
                  // readOnly: !controller.editable.value,
                  initialValue: controller.galleries.value.name,
                  isFirst: false,
                  onSaved: (input) {
                    controller.description.value = input;
                  },
                  validator: (input) =>
                      input.isEmpty ? "Should be more than 3 letters".tr : null,
                  keyboardType: TextInputType.multiline,
                  // initialValue: controller.eProvider.value.description,
                  // hintText: "Description for Portfolio Image".tr,
                  labelText: "*Description".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
