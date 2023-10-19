import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BlynkController extends GetxController {
  final blynkData = ''.obs;
  final blynkData_w = '0.0'.obs;
  final blynkDataLED = '0'.obs;
  static RxBool ledstate = false.obs;
  final ledValue = ''.obs;
  final isLedOn = false.obs;

  @override
  void onInit() {
    // getDataFromBlynk();
    super.onInit();

    getDataFromBlynk();
    // checkLEDstate();
    getDataSensorWidget();
    subscribeToBlynkUpdates_1();

    // debounce(
    //   blynkData,
    //   (_) => getDataFromBlynk(),
    //   time: const Duration(seconds: 1),
    // );

    ever(blynkData, (_) => getDataFromBlynk());
    ever(blynkData_w, (_) => getDataSensorWidget());
  }

  // set up HTTP client
  static final client = http.Client();

  // subscribe to Blynk Widget every 1 seconds
  void getDataSensorWidget() {
    Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      final response = await client.get(Uri.parse(
          'https://blynk.cloud/external/api/get?token=LnbdYpZOLUPSW_libzMp4yRveyBDx3an&v0'));
      return response.body;
    }).listen((data) {
      blynkData_w.value = data;
    });
  }

  void subscribeToBlynkUpdates_1() {
    final subscription =
        Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      final response = await http.get(Uri.parse(
          'https://blynk.cloud/external/api/get?token=LnbdYpZOLUPSW_libzMp4yRveyBDx3an&v1'));
      return response.body;
    }).listen((data) {
      blynkDataLED.value = data;
      isLedOn.value = blynkDataLED.value == '1';
    }); // cancel the subscription when the controller is disposed
    // everDisposed(subscription.cancel);
  }

  void getDataFromBlynk() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    final response = await client.get(Uri.parse(
        'https://blynk.cloud/external/api/get?token=LnbdYpZOLUPSW_libzMp4yRveyBDx3an&v3'));

    if (response.statusCode == 200) {
      blynkData.value = response.body;
    } else {
      blynkData.value = 'Error';
      print("Error: ${response.statusCode}");
    }
  }

  void turnOnLamp() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    const url =
        'https://blynk.cloud/external/api/update?token=LnbdYpZOLUPSW_libzMp4yRveyBDx3an&v1=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      // handle error
      blynkDataLED.value = '1';
      isLedOn.value = true;
    }
  }

  void turnOffLamp() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    const url =
        'https://blynk.cloud/external/api/update?token=LnbdYpZOLUPSW_libzMp4yRveyBDx3an&v1=0';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      // handle error
      blynkDataLED.value = '0';
      isLedOn.value = false;
    }
  }
}
