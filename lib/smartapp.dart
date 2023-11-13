import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get/get.dart';
import 'controller.dart';

class smarthome_app extends StatefulWidget {
  @override
  State<smarthome_app> createState() => _smarthome_appState();
}

class _smarthome_appState extends State<smarthome_app> {
  bool _isToggled = false;

  // String _ledStateText = 'Off';
  // late Color _ledStateColor;

  final BlynkController blynkController = Get.put(BlynkController());

  // void initState() {
  //   super.initState();

  //   blynkController.checkLEDstate().then((_) {
  //     setState(() {
  //       _ledStateText = blynkController.ledValue ? 'ON' : 'OFF';
  //       // _ledStateColor = blynkController.ledValue ? Colors.green : Colors.red;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blynk IoT Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text('Blynk Data: ${blynkController.blynkData.value}')),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => blynkController.getDataFromBlynk(),
                child: Text('Refresh'),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    _isToggled = !_isToggled;

                    _isToggled
                        ? blynkController.turnOnLamp()
                        : blynkController.turnOffLamp();
                  },
                  child:
                      // Obx(
                      //   () =>
                      Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: blynkController.isLedOn.value
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child:
                        //Obx(
                        //() =>
                        Text(
                      blynkController.isLedOn.value ? 'Toggled' : 'Not Toggled',
                      style: TextStyle(color: Colors.white),
                    ),
                    // ),
                  ),
                ),
                // ),
              ),
              Obx(() => Text(
                  'LED State: ${blynkController.isLedOn.value ? 'On' : 'Off'}')),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Obx(
                    () => Container(
                      child: CircularPercentIndicator(
                        // animation: true,
                        animationDuration: 1000,
                        radius: 110,
                        lineWidth: 20,
                        percent:
                            double.parse(blynkController.blynkData_w.value) /
                                500,
                        // double.parse(blynkController.blynkData.value),
                        progressColor: Colors.amber,
                        backgroundColor: Color.fromARGB(225, 199, 253, 245),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Center(
                          child: Text(
                            blynkController.blynkData_w.value,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Obx(
                      () => Text(
                        '${blynkController.blynkData_w.value}',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  Obx(
                    () =>
                        // Text(
                        //     'Blynk Data Widget: ${blynkController.blynkData_w.value}'),

                        Container(
                      height: 200,
                      width: 200,
                      child: RadialGauge(
                        track: RadialTrack(
                          start: 0,
                          end: 500,
                          thickness: 15,
                          trackStyle: TrackStyle(
                            showPrimaryRulers: false,
                            showSecondaryRulers: false,
                            showLabel: false,
                            showFirstLabel: true,
                            showLastLabel: true,
                          ),
                        ),
                        valueBar: [
                          RadialValueBar(
                            value:
                                double.parse(blynkController.blynkData_w.value),
                            valueBarThickness: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () =>
                    // Text(
                    //     'Blynk Data Widget: ${blynkController.blynkData_w.value}'),

                    Container(
                  height: 300,
                  width: double.maxFinite,
                  child: Center(
                    child: LinearGauge(
                      start: 0,
                      end: 500,
                      linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                        thickness: 70,
                        borderRadius: 24,
                      ),
                      customLabels: [
                        CustomRulerLabel(text: "0 Empty", value: 0),
                        CustomRulerLabel(text: "500 Full", value: 500),
                      ],
                      gaugeOrientation: GaugeOrientation.vertical,
                      rulers: RulerStyle(
                        rulerPosition: RulerPosition.center,
                        showPrimaryRulers: false,
                        showSecondaryRulers: false,
                        labelOffset: 28,
                      ),
                      valueBar: [
                        ValueBar(
                          value:
                              double.parse(blynkController.blynkData_w.value),
                          valueBarThickness: 70,
                          position: ValueBarPosition.center,
                          color: Colors.amber,
                          borderRadius: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
