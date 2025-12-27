import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SystemChecker {
  static Future<Map<String, dynamic>> runFullCheck() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final android = await deviceInfo.androidInfo;

      // فحص صلاحية التخزين
      bool isStorageGranted = false;

      // Android 11+
      if (await Permission.manageExternalStorage.status.isGranted) {
        isStorageGranted = true;
      } else if (await Permission.storage.status.isGranted) {
        // Legacy or when managed external storage not needed/available
        isStorageGranted = true;
      } else {
        // Android 13+ media permissions (fallback check)
        final mediaStatuses = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ].request(); // Just check status would be better but request returns status effectively

        if (mediaStatuses.values.any((s) => s.isGranted)) {
          isStorageGranted = true;
        }
      }

      return {
        "device": android.model ?? "Unknown",
        "androidVersion": android.version.release ?? "Unknown",
        "storagePermission": isStorageGranted,
      };
    } catch (e) {
      return {"error": "Failed to run system check: $e"};
    }
  }
}
