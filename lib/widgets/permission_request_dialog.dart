import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';

class PermissionRequestDialog extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionRequestDialog({
    Key? key,
    required this.onPermissionsGranted,
  }) : super(key: key);

  @override
  State<PermissionRequestDialog> createState() =>
      _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog> {
  late Map<String, PermissionStatus> _permissionStatuses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    setState(() => _isLoading = true);
    
    final statuses = await Future.wait([
      Permission.camera.status,
      Permission.storage.status,
      Permission.location.status,
    ]);

    setState(() {
      _permissionStatuses = {
        'camera': statuses[0],
        'storage': statuses[1],
        'location': statuses[2],
      };
      _isLoading = false;
    });
  }

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);

    final statuses = await PermissionService.requestAllPermissions(context);

    setState(() {
      _permissionStatuses = {
        'camera': statuses[Permission.camera] ?? PermissionStatus.denied,
        'storage': statuses[Permission.storage] ?? PermissionStatus.denied,
        'location': statuses[Permission.location] ?? PermissionStatus.denied,
      };
      _isLoading = false;
    });

    if (_allPermissionsGranted()) {
      widget.onPermissionsGranted();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  bool _allPermissionsGranted() {
    return _permissionStatuses.values.every((status) => status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'طلب الصلاحيات المطلوبة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'يحتاج التطبيق إلى الصلاحيات التالية للعمل بشكل صحيح:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  _buildPermissionItem(
                    icon: Icons.camera_alt,
                    title: 'الكاميرا',
                    description: 'لالتقاط صور السجاد',
                    status: _permissionStatuses['camera'] ?? PermissionStatus.denied,
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionItem(
                    icon: Icons.storage,
                    title: 'التخزين',
                    description: 'لحفظ الملفات والتقارير',
                    status: _permissionStatuses['storage'] ?? PermissionStatus.denied,
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionItem(
                    icon: Icons.location_on,
                    title: 'الموقع',
                    description: 'لتحديد موقع المستخدم',
                    status: _permissionStatuses['location'] ?? PermissionStatus.denied,
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'لاحقاً',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _requestPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'منح الصلاحيات',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required PermissionStatus status,
  }) {
    final isGranted = status.isGranted;
    final color = isGranted ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isGranted ? Icons.check_circle : Icons.info,
            color: color,
            size: 24,
          ),
        ],
      ),
    );
  }
}
