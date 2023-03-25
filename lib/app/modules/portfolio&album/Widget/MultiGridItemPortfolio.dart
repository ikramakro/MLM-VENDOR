import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';

class GridItemPortfolio extends StatefulWidget {
  final Key key;
  final Media item;
  final ValueChanged<bool> isSelected;

  GridItemPortfolio({this.item, this.isSelected, this.key});

  @override
  _GridItemPortfolioState createState() => _GridItemPortfolioState();
}

class _GridItemPortfolioState extends State<GridItemPortfolio> {
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
              imageUrl: widget.item.url,
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
