import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controllers/auth_controller.dart';

class TermsAndConditionsScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                        value: controller.checkBoxValue.value,
                        onChanged: (value) {
                          controller.checkBoxValue.value =
                              !controller.checkBoxValue.value;
                        }),
                  ),
                  Expanded(
                      child: Text(
                          'I have read and agree to the terms and conditions.')),
                ],
              ),
              SizedBox(height: 16),
              Obx(
                () => ElevatedButton(
                  child: Text('Continue'),
                  onPressed: controller.checkBoxValue.value
                      ? () {
                          Get.back();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
