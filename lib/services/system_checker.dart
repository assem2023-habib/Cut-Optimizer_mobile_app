import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemChecker {
  static Future<Map<String, dynamic>> runFullCheck() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final android = await deviceInfo.androidInfo;

      // فحص الإنترنت
      final connectivity = await Connectivity().checkConnectivity();
      final hasInternet = connectivity != ConnectivityResult.none;

      // فحص الصلاحيات
      final cameraPermission = await Permission.camera.status;
      final storagePermission = await Permission.storage.status;
      final locationPermission = await Permission.location.status;

      return {
        "device": android.model,
        "androidVersion": android.version.release,
        "internet": hasInternet ? "Available" : "Not Connected",
        "cameraPermission": cameraPermission.isGranted,
        "storagePermission": storagePermission.isGranted,
        "locationPermission": locationPermission.isGranted,
      };
    } catch (e) {
      return {
        "error": "Failed to run system check: $e",
      };
    }
  }
}
