import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/system_checker.dart';

class CheckerScreen extends StatefulWidget {
  final bool showContinueButton;
  final VoidCallback? onContinue;

  const CheckerScreen({
    super.key,
    this.showContinueButton = false,
    this.onContinue,
  });

  @override
  State<CheckerScreen> createState() => _CheckerScreenState();
}

class _CheckerScreenState extends State<CheckerScreen> {
  Map<String, dynamic>? report;
  bool isLoading = true;
  bool allPermissionsGranted = false;

  @override
  void initState() {
    super.initState();
    runChecker();
  }

  void runChecker() async {
    final result = await SystemChecker.runFullCheck();
    
    // Check if storage permission is granted
    final storageGranted = result['storagePermission'] == true;
    
    setState(() {
      report = result;
      isLoading = false;
      allPermissionsGranted = storageGranted;
    });
  }

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    setState(() {
      allPermissionsGranted = status.isGranted;
    });
  }

  Color _getStatusColor(dynamic value) {
    if (value is bool) {
      return value ? Colors.green : Colors.red;
    }
    if (value is String) {
      if (value.contains("Available")) return Colors.green;
      if (value.contains("Not Connected")) return Colors.red;
    }
    return Colors.grey;
  }

  IconData _getStatusIcon(dynamic value) {
    if (value is bool) {
      return value ? Icons.check_circle : Icons.cancel;
    }
    if (value is String) {
      if (value.contains("Available")) return Icons.check_circle;
      if (value.contains("Not Connected")) return Icons.cancel;
    }
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : report == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text("فشل فحص النظام"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        runChecker();
                      },
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (report!.containsKey("error"))
                        Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.error, color: Colors.red.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "خطأ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  report!["error"].toString(),
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...report!.entries.map((e) {
                          final color = _getStatusColor(e.value);
                          final icon = _getStatusIcon(e.value);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(icon, color: color),
                              title: Text(
                                _translateKey(e.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                _formatValue(e.value),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: _buildStatusBadge(e.value),
                            ),
                          );
                        }).toList(),
                      const SizedBox(height: 24),
                      // Permission request button if storage permission is not granted
                      if (!allPermissionsGranted)
                        ElevatedButton.icon(
                          onPressed: _requestStoragePermission,
                          icon: const Icon(Icons.lock_open),
                          label: const Text("منح صلاحية التخزين"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      const SizedBox(height: 12),
                      // Re-check button
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          runChecker();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("إعادة الفحص"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      // Continue button (only shown if showContinueButton is true)
                      if (widget.showContinueButton) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: allPermissionsGranted
                              ? widget.onContinue
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("متابعة"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: allPermissionsGranted
                                ? Colors.blue
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
  }

  String _translateKey(String key) {
    final translations = {
      "device": "الجهاز",
      "androidVersion": "إصدار Android",
      "internet": "الإنترنت",
      "cameraPermission": "صلاحية الكاميرا",
      "storagePermission": "صلاحية التخزين",
      "locationPermission": "صلاحية الموقع",
    };
    return translations[key] ?? key;
  }

  String _formatValue(dynamic value) {
    if (value is bool) {
      return value ? "✓ مفعل" : "✗ معطل";
    }
    return value.toString();
  }

  Widget _buildStatusBadge(dynamic value) {
    if (value is bool) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: value ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value ? "✓" : "✗",
          style: TextStyle(
            color: value ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
