class Carpet {
  final int id;
  final int width;
  final int height;
  final int qty;
  final int clientOrder;
  int remQty;
  final List<Map<String, dynamic>> repeated;

  Carpet({
    required this.id,
    required this.width,
    required this.height,
    required this.qty,
    required this.clientOrder,
    List<Map<String, dynamic>>? repeated,
  })  : remQty = qty,
        repeated = repeated ?? [];

  /// إرجاع المساحة
  int get area => width * height;

  /// خصم عدد القطع المستخدمة
  void consume(int qtyUsed) {
    if (qtyUsed > remQty) {
      throw Exception("Cannot consume $qtyUsed, only $remQty left for $id");
    }
    remQty -= qtyUsed;
  }

  /// التحقق إن كانت السجادة متاحة بعد الاستهلاك
  bool get isAvailable => remQty > 0;

  /// استهلاك كمية من السجادات المكررة فقط (repeated)
  /// دون المساس بالسجادة الأصلية.
  /// ترجع قائمة بالكائنات المستهلكة.
  List<Map<String, dynamic>> consumeFromRepeated(int qtyNeeded) {
    List<Map<String, dynamic>> consumed = [];
    int remaining = qtyNeeded;

    // We iterate over a copy of the list to allow modification during iteration if needed
    // though here we are modifying the objects inside the list or removing them.
    // In Dart, removing from a list while iterating can be tricky, so we'll iterate backwards or use a separate list to remove.
    // The python code uses list(self.repeated) to create a copy for iteration.
    
    List<Map<String, dynamic>> toRemove = [];

    for (var rep in repeated) {
      if (remaining <= 0) {
        break;
      }

      int take = (rep["qty_rem"] as int) < remaining ? (rep["qty_rem"] as int) : remaining;

      if (take > 0) {
        consumed.append({
          "id": rep["id"],
          "qty": take,
          "qty_original": rep["qty_original"],
          "qty_rem": (rep["qty_rem"] as int) - take,
          "client_order": rep["client_order"]
        });

        rep["qty_rem"] = (rep["qty_rem"] as int) - take;
        remaining -= take;
      }

      if ((rep["qty_rem"] as int) == 0) {
        toRemove.add(rep);
      }
    }

    for (var item in toRemove) {
      repeated.remove(item);
    }

    return consumed;
  }
  
  // Helper to append to list since Dart doesn't have append like python list
  // Wait, Dart has add. The python code was consumed.append({...})
  // I used consumed.append in the code above which is wrong for Dart. Fixing it now.

  /// ✅ إعادة الكميات المستهلكة من repeated
  /// تُستخدم عند التراجع عن استهلاك فاشل
  void restoreRepeated(List<Map<String, dynamic>> consumedList) {
    for (var consumedItem in consumedList) {
      var consumedId = consumedItem["id"];
      var qtyToRestore = consumedItem["qty"] as int;

      // البحث عن العنصر في repeated
      bool found = false;
      for (var rep in repeated) {
        if (rep["id"] == consumedId) {
          rep["qty_rem"] = (rep["qty_rem"] as int) + qtyToRestore;
          found = true;
          break;
        }
      }

      // إذا لم يُعثر عليه (تم حذفه لأن qty_rem كان 0)، نعيد إضافته
      if (!found) {
        repeated.add({
          "id": consumedId,
          "qty_original": consumedItem["qty_original"],
          "qty_rem": qtyToRestore,
          "client_order": consumedItem["client_order"]
        });
      }
    }
  }
  /// Create a deep copy of the Carpet
  Carpet clone() {
    return Carpet(
      id: id,
      width: width,
      height: height,
      qty: qty,
      clientOrder: clientOrder,
      repeated: repeated.map((e) => Map<String, dynamic>.from(e)).toList(),
    )..remQty = remQty;
  }
}

extension ListExtension<T> on List<T> {
  void append(T element) => add(element);
}
