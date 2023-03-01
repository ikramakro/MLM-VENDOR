import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';
import '../../portfolio&album/Widget/MultiGridItemPortfolio.dart';
import '../controllers/PortfolioViewController.dart';

class PortfolioView extends GetView<AlbumViewController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PortfolioViewController());
    return Obx(() => Scaffold(
        floatingActionButtonLocation: controller.isDeletablePortfolio.isFalse
            ? FloatingActionButtonLocation.miniEndFloat
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => controller.isDeletablePortfolio.isFalse
              ? FloatingActionButton(
                  child: new Icon(Icons.add,
                      size: 28, color: Get.theme.primaryColor),
                  onPressed: () => {
                    controller.index.value = 0,
                    Get.toNamed(Routes.PortfolioAlbum, arguments: {'index': 0})
                    // Get.toN,
                  },
                  backgroundColor: Get.theme.colorScheme.secondary,
                )
              : IconButton(
                  icon: new Icon(Icons.cancel_rounded,
                      size: 35, color: Colors.blueAccent),
                  onPressed: () =>
                      controller.isDeletablePortfolio.value = false,
                ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: new Icon(Icons.add, size: 28, color: Get.theme.primaryColor),
        //   onPressed: () => {
        //     controller.index.value = 0,
        //     Get.toNamed(Routes.PortfolioAlbum, arguments: {'index': 0})
        //     // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
        //     // Get.toN,
        //   },
        //   backgroundColor: Get.theme.colorScheme.secondary,
        // ),
        body: Obx(() => controller.isDeletablePortfolio.isFalse
            ? RefreshIndicator(
                onRefresh: () => controller.getPortfolio(),
                child: Obx(() => GridView.builder(
                      itemCount: controller.galleries.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 110,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            controller.selectedListPortfolio.value = [];
                            controller.isDeletablePortfolio.value = true;
                          },
                          onTap: () {
                            print(
                                "this is the description of image ${controller.galleries[index]}");
                            Get.toNamed(Routes.Edit_Portfolio, arguments: {
                              'gallery': controller.galleries[index],
                              'hero': 'portfolio',
                              'eProvider': controller.eProvider.value
                            });
                          },
                          child: Hero(
                            tag: 'portfolio' + controller.galleries[index].id,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: controller.galleries[index].url,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 80,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error_outline),
                              ),
                            ),
                          ),
                        );
                      },
                    ).paddingOnly(top: 15)))
            : Obx(
                () => Column(
                  children: [
                    Text("Select a Image to Edit or Select Multiples to remove",
                            style: Get.textTheme.caption)
                        .paddingOnly(top: 15, bottom: 10),
                    Expanded(
                      child: GridView.builder(
                          itemCount: controller.galleries.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 160,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0),
                          itemBuilder: (context, index) {
                            return GridItemPortfolio(
                                item: controller.galleries[index],
                                isSelected: (bool value) {
                                  if (value) {
                                    controller.selectedListPortfolio
                                        .add(controller.galleries[index]);
                                  } else {
                                    controller.selectedListPortfolio
                                        .remove(controller.galleries[index]);
                                  }

                                  print("$index : $value");
                                },
                                key: Key(controller.galleries[index].name
                                    .toString()));
                          }),
                    )
                  ],
                ),
              ))));
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
