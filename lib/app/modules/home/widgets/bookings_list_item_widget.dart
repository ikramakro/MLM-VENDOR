import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../routes/app_routes.dart';
import 'booking_options_popup_menu_widget.dart';

class BookingsListItemWidget extends StatelessWidget {
  BookingsListItemWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;
  var messages = <Message>[];
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel
        ? Get.theme.focusColor
        : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageUrl: _booking.eService.firstImageThumb,
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
                if (_booking.payment != null)
                  Container(
                    width: 70,
                    child: Text(_booking.payment.paymentStatus?.status ?? '',
                        style: Get.textTheme.caption.merge(
                          TextStyle(fontSize: 10),
                        ),
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    decoration: BoxDecoration(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  ),
                Container(
                  width: 70,
                  child: Column(
                    children: [
                      Text("ID ${_booking.id}",
                          maxLines: 1,
                          style: Get.textTheme.bodyText2.merge(
                            TextStyle(
                                color: Get.theme.primaryColor, height: 1.4),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('dd').format(_booking.bookingAt),
                          maxLines: 1,
                          style: Get.textTheme.headline3.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                      Text(DateFormat('MMM').format(_booking.bookingAt),
                          maxLines: 1,
                          style: Get.textTheme.bodyText2.merge(
                            TextStyle(color: Get.theme.primaryColor, height: 1),
                          ),
                          softWrap: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Opacity(
                opacity: _booking.cancel ? 0.3 : 1,
                child: Wrap(
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _booking.eService?.name ?? '',
                            style: Get.textTheme.bodyText2,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                        ),
                        BookingOptionsPopupMenuWidget(booking: _booking),
                      ],
                    ),
                    Divider(height: 1, thickness: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.build_circle_outlined,
                                    size: 18,
                                    color: Get.theme.focusColor,
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      _booking.user?.name ?? 'Unknown',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Get.textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    size: 18,
                                    color: Get.theme.focusColor,
                                  ),
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      _booking.address.address,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Get.textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                listenforMessages(_booking);
                                EProviderRepository _eProviderRepository =
                                    EProviderRepository();
                                List<User> _employees =
                                    await _eProviderRepository
                                        .getEmployees(_booking.eProvider.id);
                                _employees = _employees
                                    .map((e) {
                                      if (_booking
                                          .eProvider.images.isNotEmpty) {
                                        e.avatar = _booking.eProvider.images[0];
                                      } else {
                                        e.avatar = new Media();
                                      }
                                      return e;
                                    })
                                    .toSet()
                                    .toList();
                                _employees.insert(0, _booking.user);
                                Message _message = new Message(_employees,
                                    name: _booking.eProvider.name,
                                    bookingID: _booking.id);
                                Get.toNamed(Routes.CHAT, arguments: _message);

                                // Get.toNamed(Routes.BOOKING,
                                //     arguments: _booking);

                                // await Get.put(BookingController());
                                // BookingController bookingController =
                                //     await Get.find<BookingController>();
                                // bookingController.messages.value = [];
                                // Get.log(_booking.toString());
                                // bool chatExist = await bookingController
                                //     .listenForMessages(_booking);

                                // if (chatExist == false) {
                                //   bookingController.startChat();
                                // }
                                // bookingController.startChat();
                                // Get.to(
                                //   () => MessagesView(),
                                // );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(0.2),
                              padding: EdgeInsets.zero,
                              height: 44,
                              minWidth: 44,
                              child: Icon(
                                Icons.chat_outlined,
                                color: Get.theme.colorScheme.secondary,
                              ),
                              elevation: 0,
                            ),
                            Text('Contact')
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Total".tr,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Ui.getPrice(
                              _booking.getTotal(),
                              style: Get.textTheme.headline6
                                  .merge(TextStyle(color: _color)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future listenforMessages(Booking booking) async {
    final _userMessages = await FirebaseFirestore.instance
        .collection("messages")
        .where('bookingID', isEqualTo: _booking.id)
        .get();
    if (_userMessages.docs.isNotEmpty) {
      _userMessages.docs.forEach((element) {
        messages.add(Message.fromDocumentSnapshot(element));
        Get.toNamed(Routes.CHAT, arguments: messages[0]);
      });
      lastDocument.value = _userMessages.docs.last;
      return true;
    } else {
      return false;
    }
  }
}
