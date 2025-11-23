class CarpetUsed {
  final int carpetId;
  final int width;
  final int height;
  final int qtyUsed;
  final int qtyRem;
  final int clientOrder;
  final List<Map<String, dynamic>> repeated;

  CarpetUsed({
    required this.carpetId,
    required this.width,
    required this.height,
    required this.qtyUsed,
    required this.qtyRem,
    required this.clientOrder,
    List<Map<String, dynamic>>? repeated,
  }) : repeated = repeated ?? [];

  /// الطول المرجعي = الارتفاع * العدد المستخدم
  int get lengthRef => height * qtyUsed;

  /// حساب المساحة الكلية
  int get area => width * height * qtyUsed;

  /// تحويل إلى قاموس (dict)
  Map<String, dynamic> toJson() {
    return {
      "carpet_id": carpetId,
      "width": width,
      "height": height,
      "qty_used": qtyUsed,
      "qty_rem": qtyRem,
      "length_ref": lengthRef,
      "client_order": clientOrder,
    };
  }

  /// نص مختصر لوصف السجادة المستخدمة
  String summary() {
    return "id:$carpetId | $width*$height";
  }
}
