import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBookingRowWidget extends StatelessWidget {
  const CustomBookingRowWidget({
    Key key,
    @required this.description,
    this.value,
    this.bookingID,
    this.valueStyle,
    this.hasDivider,
    this.des,
    this.child,
    this.onclick,
    this.descriptionFlex,
    this.valueFlex,
  }) : super(key: key);

  final String description;
  final int descriptionFlex;
  final int bookingID;
  final Function onclick;
  final int valueFlex;
  final String value;
  final String des;
  final Widget child;
  final TextStyle valueStyle;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: descriptionFlex ?? 1,
              child: Text(
                this.description,
                style: Get.textTheme.bodyText1,
              ),
            ),
            Expanded(
                flex: valueFlex ?? 1,
                child: child ??
                    Text(
                      value,
                      style: valueStyle ?? Get.textTheme.bodyText2,
                      maxLines: 3,
                      textAlign: TextAlign.end,
                    )),
            (bookingID < 6)
                ? MaterialButton(
                    elevation: 0,
                    onPressed: onclick,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.hintColor.withOpacity(0.1),
                    child: Text("Edit".tr, style: Get.textTheme.bodyText2),
                  )
                : SizedBox(),
          ],
        ),
        if (hasDivider != null && hasDivider) Divider(thickness: 1, height: 25),
        if (hasDivider != null && !hasDivider) SizedBox(height: 6),
      ],
    );
  }
}
