import 'package:wifi_scan/wifi_scan.dart';
import 'package:get/get.dart';

class TrackScreenController extends GetxController {
  var accessPoints = <WiFiAccessPoint>[].obs;
  void updateAccessPoints(List<WiFiAccessPoint> newAccessPoints) {
    accessPoints.value = newAccessPoints;
    print("updated");
  }

  var currAp = Rx<WiFiAccessPoint?>(null);

  void updateCurrAp(WiFiAccessPoint newAccessPoint) {
    currAp.value = newAccessPoint;
    print("updated");
  }
}
