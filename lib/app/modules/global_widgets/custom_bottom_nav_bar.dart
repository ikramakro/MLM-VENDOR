import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/auth_service.dart';
import '../messages/controllers/messages_controller.dart';

const Color PRIMARY_COLOR = Colors.blueAccent;
const Color BACKGROUND_COLOR = Color(0xffE2E7F2);

class CustomBottomNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;
  bool ischat;

  CustomBottomNavigationBar(
      {this.backgroundColor = BACKGROUND_COLOR,
      this.itemColor = PRIMARY_COLOR,
      this.currentIndex = 0,
      @required this.children,
      this.onChange,
      this.ischat = false});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    if (widget.onChange != null) {
      if (index == 3) {
        widget.onChange(2);
        widget.onChange(index);
      } else {
        widget.onChange(index);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MessagesController message = Get.find<MessagesController>();
    AuthService _authService = Get.find<AuthService>();
    return Container(
      height: 60,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.children.map((item) {
          var color = item.color ?? widget.itemColor;
          var icon = item.icon;
          var label = item.label;
          var ischat = item.ischat;
          int index = widget.children.indexOf(item);
          return GestureDetector(
            onTap: () {
              _changeIndex(index);
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                      color: widget.currentIndex == index
                          ? color.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: widget.currentIndex == index
                            ? color
                            : color.withOpacity(0),
                      )),
                  child: ischat
                      ? Badge(
                          label: !message.message.value.readByUsers
                                  .contains(_authService.user.value.id)
                              ? Container(
                                  decoration:
                                      BoxDecoration(color: Colors.transparent),
                                )
                              : null,
                          child: Icon(
                            icon,
                            color: widget.currentIndex == index
                                ? color
                                : color.withOpacity(0.5),
                            size: 20,
                          ),
                        )
                      : Icon(
                          icon,
                          color: widget.currentIndex == index
                              ? color
                              : color.withOpacity(0.5),
                          size: 20,
                        ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: widget.currentIndex == index
                        ? color
                        : Color.fromARGB(140, 1, 1, 1),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color color;
  bool ischat;

  CustomBottomNavigationItem(
      {@required this.icon,
      @required this.label,
      this.color,
      this.ischat = false});
}



// AnimatedContainer(
// duration: Duration(milliseconds: 200),
// width: widget.currentIndex == index ? MediaQuery.of(context).size.width / widget.children.length + 20 : 50,
// padding: EdgeInsets.only(left: 10, right: 10),
// margin: EdgeInsets.only(top: 10, bottom: 10),
// alignment: Alignment.center,
// decoration: BoxDecoration(color: widget.currentIndex == index ? color.withOpacity(0.2) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: <Widget>[
// Icon(
// icon,
// size: 24,
// color: widget.currentIndex == index ? color : color.withOpacity(0.5),
// ),
// widget.currentIndex == index
// ? Expanded(
// flex: 2,
// child: Text(
// label ?? '',
// overflow: TextOverflow.ellipsis,
// textAlign: TextAlign.center,
// style: TextStyle(color: widget.currentIndex == index ? color : color.withOpacity(0.5)),
// ),
// )
//     : Container()
// ],
// ),
// )