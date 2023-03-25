import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/experience_model_View.dart';

class GridItemCertificate extends StatefulWidget {
  final Key key;
  final ExperienceView item;
  final ValueChanged<bool> isSelected;

  GridItemCertificate({this.item, this.isSelected, this.key});

  @override
  _GridItemCertificateState createState() => _GridItemCertificateState();
}

class _GridItemCertificateState extends State<GridItemCertificate> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              height: 130,
              width: double.infinity,
              fit: BoxFit.fill,
              imageUrl: widget.item.images[0].url,
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.fill,
                width: double.infinity,
                height: 130,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ).paddingAll(5),
          isSelected
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
