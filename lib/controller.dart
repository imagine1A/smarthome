import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BlynkController extends GetxController {
  final blynkData = ''.obs;
  final blynkData_w = '0.0'.obs;
  final blynkDataLED = '0'.obs;
  static RxBool ledstate = false.obs;
  final ledValue = ''.obs;
  final isLedOn = false.obs;

  final String authToken = "LnbdYpZOLUPSW_libzMp4yRveyBDx3an";
  final qrData = Rxn<Map<String, dynamic>>(); // Reactive QR data

  @override
  void onInit() {
    // getDataFromBlynk();
    super.onInit();

    // Load QR code data from preferences
    loadQRDataFromPreferences().then((_) {
      if (qrData.value != null) {
        print('Loaded QR Data: ${qrData.value}');
      } else {
        print('No QR Data available');
      }
    });

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
          'https://blynk.cloud/external/api/get?token=$authToken&v0'));
      return response.body;
    }).listen((data) {
      blynkData_w.value = data;
    });
  }

  void subscribeToBlynkUpdates_1() {
    final subscription =
        Stream.periodic(Duration(seconds: 1)).asyncMap((_) async {
      final response = await http.get(Uri.parse(
          'https://blynk.cloud/external/api/get?token=$authToken&v1'));
      return response.body;
    }).listen((data) {
      blynkDataLED.value = data;
      isLedOn.value = blynkDataLED.value == '1';
    }); // cancel the subscription when the controller is disposed
    // everDisposed(subscription.cancel);
  }

  void getDataFromBlynk() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    final response = await client.get(
        Uri.parse('https://blynk.cloud/external/api/get?token=$authToken&v3'));

    if (response.statusCode == 200) {
      blynkData.value = response.body;
    } else {
      blynkData.value = 'Error';
      print("Error: ${response.statusCode}");
    }
  }

  void turnOnLamp() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    final url = 'https://blynk.cloud/external/api/update?token=$authToken&v1=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      // handle error
      blynkDataLED.value = '1';
      isLedOn.value = true;
    }
  }

  void turnOffLamp() async {
    // replace the URL and Auth Token with your Blynk IoT cloud details
    final url = 'https://blynk.cloud/external/api/update?token=$authToken&v1=0';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      // handle error
      blynkDataLED.value = '0';
      isLedOn.value = false;
    }
  }

  Future<void> setQRData(String code) async {
    try {
      final decodedData = jsonDecode(code);
      qrData.value = decodedData;
      await _saveQRDataToPreferences();
    } catch (e) {
      print('Error decoding JSON: $e');
      qrData.value = null;
    }
  }

  Future<void> _saveQRDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (qrData.value != null) {
      prefs.setString('qr_data', jsonEncode(qrData.value));
    }
  }

  Future<void> loadQRDataFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('qr_data');
    if (jsonString != null) {
      qrData.value = jsonDecode(jsonString);
    } else {
      qrData.value = null;
    }
  }
}
