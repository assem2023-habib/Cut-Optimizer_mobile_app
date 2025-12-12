import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static const String _permissionsGrantedKey = 'app_permissions_granted';

  /// Request all required permissions
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions(
    BuildContext context,
  ) async {
    final permissions = [
      Permission.camera,
      Permission.storage,
      Permission.location,
    ];

    final statuses = await permissions.request();
    return statuses;
  }

  /// Request camera permission
  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  /// Request storage permission
  static Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }

  /// Request location permission
  static Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> isStoragePermissionGranted() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Check all permissions status
  static Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'camera': await isCameraPermissionGranted(),
      'storage': await isStoragePermissionGranted(),
      'location': await isLocationPermissionGranted(),
    };
  }

  /// Open app settings to manually grant permissions
  static Future<void> openAppSettings() async {
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
