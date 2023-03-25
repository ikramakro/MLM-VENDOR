import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../Albums/controllers/AlbumController.dart';
import '../../Portfolio/View/portfolio.dart';

class PortfolioAndAlbum extends GetView<AlbumController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        decoration: Ui.getBoxDecoration(),
        // width: 200,

        child: Portfolio(),
      ),
    );
  }
}
