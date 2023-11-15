import 'package:wifi_scan/wifi_scan.dart';
import 'package:get/get.dart';

class TrackScreenController extends GetxController {
  var accessPoints = <WiFiAccessPoint>[].obs;
  void updateAccessPoints(List<WiFiAccessPoint> newAccessPoints) {
    accessPoints.value = newAccessPoints;
  }
}
