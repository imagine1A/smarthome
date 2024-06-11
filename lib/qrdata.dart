import 'dart:convert';

class QRData {
  // Singleton pattern
  static final QRData _instance = QRData._internal();

  factory QRData() {
    return _instance;
  }

  QRData._internal();

  // Variable to store the scanned QR code data
  Map<String, dynamic>? _data;

  void setCode(String code) {
    try {
      _data = jsonDecode(code);
    } catch (e) {
      print('Error decoding JSON: $e');
      _data = null;
    }
  }

  Map<String, dynamic>? get data => _data;
}
