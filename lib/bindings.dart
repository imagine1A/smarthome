import 'package:get/get.dart';

import 'controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    //create an instance of controller class using put method
    Get.put(BlynkController());
  }
}
