import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../Portfolio_view/controllers/PortfolioViewController.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';

class PortfolioViewAllForBusniss extends GetView<AlbumViewController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PortfolioViewController());
    return Scaffold(
        appBar: AppBar(
          title: Text('Portfolio'),
        ),
        backgroundColor: Colors.grey[300],
        body: Obx(() => GridView.builder(
              itemCount: controller.galleries.length,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 110,
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 7.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(
                        "this is the description of image ${controller.galleries[index]}");
                    var _media = controller.galleries.elementAt(index);
                    Get.toNamed(Routes.Edit_Portfolio_View, arguments: {
                      'gallery': controller.galleries[index],
                      'hero': 'portfolio',
                      'eProvider': controller.eProvider.value,
                      'media': controller.galleries,
                      'current': _media,
                    });
                  },
                  child: Hero(
                    tag: 'portfolio' + controller.galleries[index].id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
            ).paddingOnly(top: 15)));
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
