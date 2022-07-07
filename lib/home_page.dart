import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart';
import 'package:trackme_host/location_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackMe Host'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(() =>
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('GPS Location Tracker',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                const SizedBox(height: 30),
                Text('Latitude',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.lat.value}'),
                const SizedBox(height: 15),
                Text('Longitude',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.lon.value}'),
                const SizedBox(height: 15),
                Text('Heading',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.hea.value}'),
                const SizedBox(height: 15),
                Text('Speed',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.vel.value}'),
                const SizedBox(height: 15),
                Text('Altitude',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.alt.value}'),
                const SizedBox(height: 15),
                Text('Accuracy',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Text('${locationController.acc.value}'),
                const SizedBox(height: 25),
              ])),
        ),
      )),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Obx(() => ElevatedButton(
            onPressed: () {
              if (locationController.isTracking.value) {
                _stopTracking();
              } else {
                _getPermissions();
              }
            },
            child: locationController.isTracking.value == false
                ? const Text('Start Tracker')
                : const Text('Stop Tracker'))),
      ),
    );
  }

  _getPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.isTracking.value = true;
    location.enableBackgroundMode(enable: true);
    LocationData locationData = await location.getLocation();
    //locationController.insertLocationData(locationData);

    location.onLocationChanged.listen((LocationData currentLocation) async {
      locationController.lon.value = currentLocation.longitude as double;
      locationController.lat.value = currentLocation.latitude as double;
      locationController.vel.value = currentLocation.speed as double;
      locationController.acc.value = currentLocation.accuracy as double;
      locationController.hea.value = currentLocation.heading as double;
      locationController.alt.value = currentLocation.altitude as double;

      locationController.updateLocationData(currentLocation);
    });
  }

  _stopTracking() async {}
}
