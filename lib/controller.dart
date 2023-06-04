import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BlynkController extends GetxController {
  final blynkData = ''.obs;
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
    subscribeToBlynkUpdates();
    subscribeToBlynkUpdates_1();

    // debounce(
    //   blynkData,
    //   (_) => getDataFromBlynk(),
    //   time: const Duration(seconds: 1),
    // );

    ever(blynkData, (_) => getDataFromBlynk());
  }

  void subscribeToBlynkUpdates() {
    final subscription =
        Stream.periodic(Duration(seconds: 5)).asyncMap((_) async {
      final response = await http.get(Uri.parse(
          'https://blynk.cloud/external/api/get?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v3'));
      return response.body;
    }).listen((data) {
      blynkData.value = data;
    }); // cancel the subscription when the controller is disposed
    // everDisposed(subscription.cancel);
  }

  void subscribeToBlynkUpdates_1() {
    final subscription =
        Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      final response = await http.get(Uri.parse(
          'https://blynk.cloud/external/api/get?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v1'));
      return response.body;
    }).listen((data) {
      blynkDataLED.value = data;
      isLedOn.value = blynkDataLED.value == '1';
    }); // cancel the subscription when the controller is disposed
    // everDisposed(subscription.cancel);
  }

  static var client = http.Client();

  void getDataFromBlynk() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    final response = await client.get(Uri.parse(
        'https://blynk.cloud/external/api/get?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v3'));

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
        'https://blynk.cloud/external/api/update?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v1=1';
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
        'https://blynk.cloud/external/api/update?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v1=0';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      // handle error
      blynkDataLED.value = '0';
      isLedOn.value = false;
    }
  }

  // Future<void> checkLEDstate() async {
  //   // replace the URL and Auth Token with your Blynk IoT cloud details
  //   final response = await client.get(Uri.parse(
  //       'https://blynk.cloud/external/api/get?token=NFygYG0MwW3i10T3XoANUAjY0gSkS6wc&v1'));

  //   if (response.statusCode == 200) {
  //     blynkDataLED.value = response.body;

  //     ledValue.value = jsonDecode(response.body)[1].toString();
  //     isLedOn.value = ledValue == '1';
  //   } else {
  //     blynkDataLED.value = 'Error';
  //     print("Error: ${response.statusCode}");
  //   }

  //    bool get isLedOn => _isLedOn
  // }
}
