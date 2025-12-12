import 'package:flutter/material.dart';
import '../../../services/system_checker.dart';

class CheckerScreen extends StatefulWidget {
  const CheckerScreen({super.key});

  @override
  State<CheckerScreen> createState() => _CheckerScreenState();
}

class _CheckerScreenState extends State<CheckerScreen> {
  Map<String, dynamic>? report;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    runChecker();
  }

  void runChecker() async {
    final result = await SystemChecker.runFullCheck();
    setState(() {
      report = result;
      isLoading = false;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("فحص النظام"),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
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
              : ListView(
                  padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        runChecker();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("إعادة الفحص"),
                    ),
                  ],
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
