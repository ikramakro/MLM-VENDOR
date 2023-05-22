import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';

class AlbumViewAllForBusniss extends GetView<AlbumViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Albums'),
        ),
        body: Obx(() => GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.album.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 135,
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    controller.selectedList.value = [];
                    controller.isDeletable.value = true;
                    // controller.selectedList.add(controller.album[index]);
                  },
                  onTap: () {
                    print(
                        "this is the Album of image ${controller.album[index].images}");
                    var _media = controller.album.elementAt(index);
                    controller.isEditable.isFalse
                        ? Get.toNamed(Routes.View_SubAlbum, arguments: {
                            'album': controller.album[index].images,
                            'hero': 'AlbumView',
                            'eProvider': controller.eProvider.value,
                            'albumname': controller.album[index].name,
                            'gallery': controller.album[index],
                            'media': controller.album,
                            'current': _media,
                          })
                        : Get.offAndToNamed(Routes.Edit_Album, arguments: {
                            'album': controller.album[index],
                          });
                    controller.isEditable.value = false;
                  },
                  child: Column(
                    children: [
                      Hero(
                        tag: 'AlbumView' + controller.album[index].id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            imageUrl:
                                controller.album[index].images[0].media[0].url,
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
                      Expanded(
                        child: Text(controller.album[index].name)
                            .paddingOnly(top: 5),
                      )
                    ],
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
