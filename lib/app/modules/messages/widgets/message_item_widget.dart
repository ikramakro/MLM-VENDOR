import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

class MessageItemWidget extends StatelessWidget {
  MessageItemWidget({Key key, this.message, this.onDismissed})
      : super(key: key);
  final Message message;
  final ValueChanged<Message> onDismissed;

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Get.find<AuthService>();
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.CHAT, arguments: this.message);
      },
      child: Dismissible(
        key: Key(this.message.hashCode.toString()),
        background: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: Ui.getBoxDecoration(color: Colors.red),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onDismissed: (direction) {
          onDismissed(this.message);
          // Then show a snackbar.
          Get.showSnackbar(Ui.SuccessSnackBar(
              message: "The conversation with %s is dismissed"
                  .trArgs([this.message.name])));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: Ui.getBoxDecoration(
              color:
                  this.message.readByUsers.contains(_authService.user.value.id)
                      ? Get.theme.primaryColor
                      : Get.theme.colorScheme.secondary.withOpacity(0.05)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: this.message.users[0].avatar.thumb ==
                                _authService.user.value.avatar.thumb
                            ? this.message.users[1].avatar.thumb
                            : this.message.users[0].avatar.thumb,
                        // .firstWhere(
                        //     (element) =>
                        //         element.id == _authService.user.value.id,
                        //     orElse: () => User.fromJson({}))
                        // .avatar
                        // .thumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 140,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    width: 12,
                    height: 12,
                    child: Container(
                      decoration: BoxDecoration(
//                        color: widget.message.user.userState == UserState.available
//                            ? Colors.green
//                            : widget.message.user.userState == UserState.away ? Colors.orange : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            this.message.users[0].name ==
                                    _authService.user.value.name
                                ? this.message.users[1].name
                                : this.message.users[0].name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1.merge(TextStyle(
                                fontWeight: this
                                        .message
                                        .readByUsers
                                        .contains(_authService.user.value.id)
                                    ? FontWeight.w400
                                    : FontWeight.w800)),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Users")
                                .where("id",
                                    isEqualTo: this.message.visibleToUsers[0] ==
                                            _authService.user.value.id
                                        ? this.message.visibleToUsers[1]
                                        : this.message.visibleToUsers[0])
                                .snapshots(),
                            builder: (context, snapshot) {
                              // if(snapshot.hasError){
                              //   return SizedBox();
                              // }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox();
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return Text("no data");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Text("done");
                              }
                              if (!snapshot.hasData) {
                                return Text('no has data');
                              }
                              if (snapshot.data.docs.length == 0) {
                                return Text("No Status find");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                Map<String, dynamic> data =
                                    snapshot.data.docs[0].data();
                                Get.log(
                                    "this is the status  ${data.toString()}");
                                return Text(
                                  data['status'] ? "Online" : "Offline",
                                  style: TextStyle(
                                      color: data['status']
                                          ? Colors.green
                                          : Colors.grey),
                                );
                              }
                              return Text("non");
                            }),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            this.message.lastMessage.length >= 15
                                ? "${this.message.lastMessage.substring(0, 15)}...."
                                : this.message.lastMessage,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Get.textTheme.caption.merge(TextStyle(
                                fontWeight: this
                                        .message
                                        .readByUsers
                                        .contains(_authService.user.value.id)
                                    ? FontWeight.w400
                                    : FontWeight.w800)),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('dd-MM-yyyy', Get.locale.toString())
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        this.message.lastMessageTime)),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.caption,
                              ),
                              Text(
                                DateFormat('HH:mm', Get.locale.toString())
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        this.message.lastMessageTime)),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.caption,
                              ),
                            ]),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Booking ID",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.textTheme.caption.merge(TextStyle(
                              fontWeight: this
                                      .message
                                      .readByUsers
                                      .contains(_authService.user.value.id)
                                  ? FontWeight.w400
                                  : FontWeight.w800)),
                        ),
                        Text(
                          this.message.bookingID ?? '-',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Get.textTheme.caption.merge(TextStyle(
                              fontWeight: this
                                      .message
                                      .readByUsers
                                      .contains(_authService.user.value.id)
                                  ? FontWeight.w400
                                  : FontWeight.w800)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
