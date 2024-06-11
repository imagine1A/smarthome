import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:smarthome/resultPage.dart';
// import 'package:qrscanner/resultsPage1.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isScanCompleted = false;
  MobileScannerController cameraController = MobileScannerController();

  void closeScreen() {
    setState(() {
      isScanCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        leading: IconButton(
            style: ButtonStyle(
                iconSize: const WidgetStatePropertyAll(30),
                iconColor: WidgetStatePropertyAll(Colors.amber.shade900),
                backgroundColor: const WidgetStatePropertyAll(Colors.white70)),
            onPressed: () {},
            icon: const Icon(Icons.qr_code_scanner)),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Gap(10),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in designated area",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Let the scan do the magic - It starts on its own!",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  )
                ],
              ),
            ),
            const Gap(
              20,
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (BarcodeCapture result) {
                      if (!isScanCompleted) {
                        isScanCompleted = true;
                        String code = result.barcodes.first.rawValue ?? "---";
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return QRResult1(
                              code: code,
                              closeScreen: closeScreen,
                            );
                          }),
                        ).then((_) => closeScreen());
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: Colors.black26,
                    borderColor: Colors.amber.shade900,
                    borderRadius: 16,
                    borderStrokeWidth: 6,
                    scanAreaWidth: 250,
                    scanAreaHeight: 250,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
