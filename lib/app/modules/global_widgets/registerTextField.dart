/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/ui.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  PasswordTextFieldWidget(
      {Key key,
      this.onSaved,
      this.controller,
      this.readOnly,
      this.onChanged,
      this.validator,
      this.keyboardType,
      this.initialValue,
      this.hintText,
      this.captionText,
      this.errorText,
      this.iconData,
      this.labelText,
      this.obscureText,
      this.suffixIcon,
      this.isFirst,
      this.isLast,
      this.style,
      this.textAlign,
      this.suffix,
      this.valdte,
      this.isemail})
      : super(key: key);

  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String initialValue;
  final String hintText;
  final TextEditingController controller;
  final String captionText;
  final String errorText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool readOnly;
  final bool isLast;
  final Widget suffixIcon;
  final Widget suffix;
  final AutovalidateMode valdte;
  bool isemail;

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool isrequired = false;
  bool lenghtcheck = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool hasCapitalLetter = false;
  bool hasLowerCase = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(
          left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: widget.textAlign ?? TextAlign.start,
          ),
          Text(
            widget.captionText ?? "",
            style: Get.textTheme.caption,
            textAlign: widget.textAlign ?? TextAlign.center,
          ),
          TextFormField(
            autovalidateMode: widget.valdte,
            readOnly: widget.readOnly ?? false,
            maxLines: widget.keyboardType == TextInputType.multiline ? null : 1,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            onSaved: widget.onSaved,
            onChanged: !widget.isemail
                ? (val) {
                    if (val.length >= 8) {
                      setState(() {
                        lenghtcheck = true;
                      });
                    } else if (val.length <= 7) {
                      setState(() {
                        lenghtcheck = false;
                      });
                    }
                    containsNumber = RegExp(r'\d+').hasMatch(val);
                    containsSpecialChar =
                        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(val);
                    hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(val);
                    hasLowerCase = RegExp(r'[a-z]').hasMatch(val);
                  }
                : widget.onChanged,
            validator: widget.validator,
            controller: widget.controller,
            style: widget.style ?? Get.textTheme.bodyText2,
            obscureText: widget.obscureText ?? false,
            textAlign: widget.textAlign ?? TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: widget.hintText ?? '',
              iconData: widget.iconData,
              suffixIcon: widget.suffixIcon,
              suffix: widget.suffix,
              errorText: widget.errorText,
            ),
          ),
          !widget.isemail
              ? Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Icon(
                        lenghtcheck ? Icons.done : Icons.close,
                        color: lenghtcheck ? Colors.green : Colors.red,
                        size: 10,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Password Must be 8 char',
                        style: GoogleFonts.cormorant(
                            fontSize: 10,
                            color: lenghtcheck ? Colors.green : Colors.red))
                  ],
                )
              : Text(''),
          !widget.isemail
              ? Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Icon(
                        hasCapitalLetter ? Icons.done : Icons.close,
                        color: hasCapitalLetter ? Colors.green : Colors.red,
                        size: 10,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Contains 1 UpperCase',
                        style: GoogleFonts.cormorant(
                            fontSize: 10,
                            color:
                                hasCapitalLetter ? Colors.green : Colors.red))
                  ],
                )
              : Text(''),
          !widget.isemail
              ? Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Icon(
                        hasLowerCase ? Icons.done : Icons.close,
                        color: hasLowerCase ? Colors.green : Colors.red,
                        size: 10,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Contains 1 LowerCase',
                        style: GoogleFonts.cormorant(
                            fontSize: 10,
                            color: hasLowerCase ? Colors.green : Colors.red))
                  ],
                )
              : Text(''),
          !widget.isemail
              ? Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Icon(
                        containsSpecialChar ? Icons.done : Icons.close,
                        color: containsSpecialChar ? Colors.green : Colors.red,
                        size: 10,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Contains 1 SpecialCharecter',
                        style: GoogleFonts.cormorant(
                            fontSize: 10,
                            color: containsSpecialChar
                                ? Colors.green
                                : Colors.red))
                  ],
                )
              : Text(''),
          !widget.isemail
              ? Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: Icon(
                        containsNumber ? Icons.done : Icons.close,
                        color: containsNumber ? Colors.green : Colors.red,
                        size: 10,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Contains 1 Number',
                        style: GoogleFonts.cormorant(
                            fontSize: 10,
                            color: containsNumber ? Colors.green : Colors.red))
                  ],
                )
              : Text(''),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (widget.isFirst != null && widget.isFirst) {
      return BorderRadius.vertical(top: Radius.circular(10));
    }
    if (widget.isLast != null && widget.isLast) {
      return BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (widget.isFirst != null &&
        !widget.isFirst &&
        widget.isLast != null &&
        !widget.isLast) {
      return BorderRadius.all(Radius.circular(0));
    }
    return BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((widget.isFirst != null && widget.isFirst)) {
      return 20;
    } else if (widget.isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((widget.isLast != null && widget.isLast)) {
      return 10;
    } else if (widget.isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
