import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request storage permissions based on Android version
  static Future<bool> requestStoragePermission() async {
    // For Android 11+ (API 30+), try manageExternalStorage first
    if (await Permission.manageExternalStorage.status.isDenied) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;
    } else if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // For Android 13+ (API 33+), try media permissions
    final mediaStatus = await [
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ].request();

    if (mediaStatus.values.any((s) => s.isGranted)) {
      return true;
    }

    // Fallback: try regular storage permission
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> isStoragePermissionGranted() async {
    // Check manageExternalStorage first (Android 11+)
    if (await Permission.manageExternalStorage.isGranted) return true;

    // Check media permissions (Android 13+)
    if (await Permission.photos.isGranted ||
        await Permission.videos.isGranted ||
        await Permission.audio.isGranted) {
      return true;
    }

    // Check legacy storage permission
    return await Permission.storage.isGranted;
  }

  /// Open app settings to manually grant permissions
  static Future<void> openSettings() async {
    await openAppSettings();
  }

  /// Get permission status message
  static String getPermissionStatusMessage(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'تم منح الصلاحية';
      case PermissionStatus.denied:
        return 'تم رفض الصلاحية';
      case PermissionStatus.restricted:
        return 'الصلاحية مقيدة';
      case PermissionStatus.limited:
        return 'الصلاحية محدودة';
      case PermissionStatus.permanentlyDenied:
        return 'تم رفض الصلاحية بشكل دائم';
      case PermissionStatus.provisional:
        return 'الصلاحية مؤقتة';
    }
  }
}
