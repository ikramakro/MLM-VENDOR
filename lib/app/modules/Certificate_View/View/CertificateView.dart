import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../Certificates/View/Certificates.dart';
import '../Controller/certificate_view_Controller.dart';
import '../widgets/muiltSelectCertificate.dart';

class CertificateView extends GetView<CertificatesViewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          // actions: [
          //   Obx(
          //     () => controller.selectedList.length == 1 &&
          //             controller.isDeletable.isTrue
          //         ? IconButton(
          //             icon: new Icon(Icons.edit, color: Colors.blueAccent),
          //             onPressed: () {
          //               controller.isDeletable.value = false;

          //               Get.offAndToNamed(Routes.CERTIFICATEEDIT, arguments: {
          //                 'title': controller.selectedList[0].title,
          //                 'des': controller.selectedList[0].description,
          //                 'url': controller.selectedList[0].images[0].url,
          //                 'id': controller.selectedList[0].id,
          //               });
          //               controller.selectedList.value = [];
          //             },
          //           )
          //         : SizedBox(),
          //   ),
          //   Obx(
          //     () => controller.isDeletable.isTrue &&
          //             controller.selectedList.length > 0
          //         ? IconButton(
          //             icon: new Icon(Icons.delete, color: Colors.blueAccent),
          //             onPressed: () {
          //               controller.delExperiences();
          //               controller.isDeletable.value = false;
          //             },
          //           )
          //         : SizedBox(),
          //   )
          // ],
          title: Text("Certificates"),
          // backgroundColor: Get.theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: new IconButton(
              icon:
                  new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
              onPressed: () => Get.back()),
        ),
        floatingActionButtonLocation: controller.isDeletable.isFalse
            ? FloatingActionButtonLocation.miniEndFloat
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.add, size: 28, color: Get.theme.primaryColor),
          onPressed: () {
            Get.toNamed(Routes.Certificates);
            // Get.to(() => Certificates());
            Get.log('preess');
          }
          // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
          // Get.toN,
          ,
          backgroundColor: Get.theme.colorScheme.secondary,
        )
        // : IconButton(
        //     icon: new Icon(Icons.cancel_rounded,
        //         size: 35, color: Colors.blueAccent),
        //     onPressed: () => controller.isDeletable.value = false,
        //   ),
        ,
        body: Obx(() => controller.isDeletable.isFalse
            ? RefreshIndicator(
                onRefresh: () => controller.getExperiences(),
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.experiences.length,
                    scrollDirection: Axis.vertical,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3,
                    //     mainAxisExtent: 160,
                    //     crossAxisSpacing: 5.0,
                    //     mainAxisSpacing: 5.0),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Hero(
                          tag: 'certificate' + controller.experiences[index].id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                              imageUrl:
                                  controller.experiences[index].images[0].url,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.fill,
                                width: double.infinity,
                                // height: 120,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        title: Text(
                          controller.experiences[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text(
                          controller.experiences[index].description,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 10),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              controller.delExperiences(
                                  controller.experiences[index].id,
                                  controller.eProvider.value.id);
                            },
                            icon: Icon(Icons.delete)),
                      ).paddingAll(5);
                      // return GestureDetector(
                      //   onLongPress: () {
                      //     controller.selectedList.value = [];
                      //     controller.isDeletable.value = true;
                      //   },
                      //   onTap: () {
                      //     print(
                      //         "this is the description of image ${controller.experiences[index]}");
                      //   },
                      //   child: Column(
                      //     children: [
                      // Hero(
                      //   tag: 'certificate' +
                      //       controller.experiences[index].id,
                      //   child: ClipRRect(
                      //     borderRadius:
                      //         BorderRadius.all(Radius.circular(10)),
                      //     child: CachedNetworkImage(
                      //       height: 120,
                      //       width: double.infinity,
                      //       fit: BoxFit.fill,
                      //       imageUrl: controller
                      //           .experiences[index].images[0].url,
                      //       placeholder: (context, url) => Image.asset(
                      //         'assets/img/loading.gif',
                      //         fit: BoxFit.fill,
                      //         width: double.infinity,
                      //         height: 120,
                      //       ),
                      //       errorWidget: (context, url, error) =>
                      //           Icon(Icons.error_outline),
                      //     ),
                      //   ),
                      // ).paddingAll(5),
                      //       Text(controller.experiences[index].title)
                      //           .paddingOnly(top: 5)
                      //     ],
                      //   ),
                      // );
                    },
                  ).paddingOnly(top: 15),
                ),
              )
            : Obx(
                () => Column(
                  children: [
                    Text("Select a Image to Edit or Select Multiples to remove",
                            style: Get.textTheme.caption)
                        .paddingOnly(top: 15, bottom: 10),
                    Expanded(
                      child: GridView.builder(
                          itemCount: controller.experiences.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 160,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0),
                          itemBuilder: (context, index) {
                            return GridItemCertificate(
                                item: controller.experiences[index],
                                isSelected: (bool value) {
                                  if (value) {
                                    controller.selectedList
                                        .add(controller.experiences[index]);
                                  } else {
                                    controller.selectedList
                                        .remove(controller.experiences[index]);
                                  }

                                  print("$index : $value");
                                },
                                key: Key(controller
                                    .experiences[index].description
                                    .toString()));
                          }),
                    )
                  ],
                ),
              ))));
  }
}
