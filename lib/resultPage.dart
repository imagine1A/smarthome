// qr_result1.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarthome/controller.dart';

class QRResult1 extends StatelessWidget {
  final String code;
  final VoidCallback closeScreen;

  const QRResult1({required this.code, required this.closeScreen, super.key});

  @override
  Widget build(BuildContext context) {
    // Get the BlynkController instance
    final BlynkController blynkController = Get.find();

    // Store the scanned QR code data
    blynkController.setQRData(code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scanned QR Code:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              code,
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                closeScreen();
                Navigator.pop(context);
              },
              child: const Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
