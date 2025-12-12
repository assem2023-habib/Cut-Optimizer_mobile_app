import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemChecker {
  static Future<Map<String, dynamic>> runFullCheck() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final android = await deviceInfo.androidInfo;

      // فحص صلاحية التخزين فقط
      final storagePermission = await Permission.storage.status;

      return {
        "device": android.model ?? "Unknown",
        "androidVersion": android.version.release ?? "Unknown",
        "storagePermission": storagePermission.isGranted,
      };
    } catch (e) {
      return {
        "error": "Failed to run system check: $e",
      };
    }
  }
}
