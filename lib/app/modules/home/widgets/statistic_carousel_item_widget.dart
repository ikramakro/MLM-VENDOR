import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/statistic.dart';

class StatisticCarouselItemWidget extends StatelessWidget {
  final double marginLeft;
  final Statistic statistic;

  StatisticCarouselItemWidget({Key key, this.marginLeft, this.statistic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
          start: this.marginLeft, end: 10, top: 75, bottom: 75),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: Ui.getBoxDecoration(color: Get.theme.primaryColor),
      height: 100,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (statistic.description == "total_earning")
            Ui.getPrice(double.tryParse(statistic.value),
                style: Get.textTheme.headline2.merge(
                  TextStyle(height: 1),
                ))
          else
            Text(
              statistic.value,
              textAlign: TextAlign.center,
              style: Get.textTheme.headline2.merge(TextStyle(height: 1)),
            ),
          SizedBox(height: 8),
          Text(
            statistic.description.tr,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: Get.textTheme.caption,
          )
        ],
      ),
    );
  }
}
