import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../Controller/EditPorfolioController.dart';

class EditPortfolioView extends GetView<EditPortfolioController> {
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(
      () => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Hero(
            tag: controller.heroTag.value + controller.current.value.id,
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 1.0,
                height: double.infinity,
                initialPage: controller.media.indexOf(controller.current.value),
                onPageChanged: (index, reason) {
                  controller.current.value = controller.media.elementAt(index);
                  controller.galleries.value =
                      controller.media.elementAt(index);
                },
              ),
              items: controller.media.map((Media _media) {
                return InteractiveViewer(
                  scaleEnabled: true,
                  panEnabled: true,
                  // Set it to false to prevent panning.
                  minScale: 0.5,
                  maxScale: 4,
                  child: Container(
                    width: double.infinity,
                    alignment: AlignmentDirectional.center,
                    // child: Stack(
                    //   children: [
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.contain,
                        imageUrl: _media.url,
                        placeholder: (context, url) =>
                            CircularLoadingWidget(height: 200),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ).marginSymmetric(horizontal: 20),
                    //     Align(
                    //       alignment: Alignment.center,
                    //       child: Text(
                    //         controller.current.value.name ?? '',
                    //         maxLines: 2,
                    //         style: Get.textTheme.bodyText2.merge(
                    //           TextStyle(
                    //             color: Get.theme.primaryColor,
                    //             shadows: <Shadow>[
                    //               Shadow(
                    //                 offset: Offset(0, 1),
                    //                 blurRadius: 6.0,
                    //                 color: Get.theme.hintColor.withOpacity(0.6),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              return Text(
                controller.current.value.name ?? '',
                maxLines: 2,
                style: Get.textTheme.bodyText2.merge(
                  TextStyle(
                    color: Get.theme.primaryColor,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 6.0,
                        color: Get.theme.hintColor.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          // Obx(
          //   () => Padding(
          //     padding: controller.editable.value
          //         ? EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 360)
          //         : EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 450),
          //     child: Container(
          //       height: 130,
          //       child: Form(
          //         key: controller.portfolioEditForm,
          //         child: TextFieldWidget(
          //           readOnly: !controller.editable.value,
          //           initialValue: controller.galleries.value.name,
          //           isFirst: false,
          //           onSaved: (input) {
          //             controller.description.value = input;
          //           },
          //           validator: (input) =>
          //               input.isEmpty ? "Should be more than 3 letters".tr : null,
          //           keyboardType: TextInputType.multiline,
          //           // initialValue: controller.eProvider.value.description,
          //           // hintText: "Description for Portfolio Image".tr,
          //           labelText: "*Description".tr,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            right: 300,
            bottom: 300,
            child: MaterialButton(
              minWidth: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.orange,
              onPressed: () {
                _controller.previousPage();
              },
              child: Icon(Icons.arrow_left),
            ),
          ),
          Positioned(
            left: 300,
            bottom: 300,
            child: MaterialButton(
              minWidth: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.orange,
              onPressed: () {
                _controller.nextPage();
              },
              child: Icon(Icons.arrow_right),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Get.toNamed(Routes.Edit_Portfolio, arguments: {
                    'gallery': controller.galleries,
                    'hero': 'portfolio',
                    'eProvider': controller.eProvider.value,
                  });
                },
                child: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
