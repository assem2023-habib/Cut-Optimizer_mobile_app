import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/config.dart';
import '../../../core/constants/app_routes.dart';

/// شاشة خيارات المعالجة (Processing Options)
/// تسمح باختيار النول وخيارات الترتيب قبل بدء المعالجة
class ProcessingOptionsScreen extends StatefulWidget {
  final String fileName;
  final int fileSize;

  const ProcessingOptionsScreen({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  State<ProcessingOptionsScreen> createState() =>
      _ProcessingOptionsScreenState();
}

class _ProcessingOptionsScreenState extends State<ProcessingOptionsScreen> {
  final Config _config = Config.defaultConfig();
  int? _selectedLoomIndex;
  String _sortOption = 'length'; // length, width, quantity
  String _repeatMain = 'repeat'; // repeat, no-repeat

  void _startProcessing() {
    if (_selectedLoomIndex == null) return;

    // TODO: Save selected options and navigate to processing
    Navigator.of(context).pushNamed(AppRoutes.processing);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: 'upload', // Still on upload flow
      showBottomNav: false, // Hide during processing setup
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان
            const Text(
              'خيارات المعالجة',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'اختر النول المناسب وحدد خيارات الترتيب',
              style: TextStyle(color: Color(0xFF4B5563), fontSize: 14),
            ),

            const SizedBox(height: 24),

            // 1. Success Card
            _SuccessCard(fileName: widget.fileName, fileSize: widget.fileSize),

            const SizedBox(height: 24),

            // 2. Loom Selection
            _LoomSelection(
              looms: _config.machineSizes,
              selectedIndex: _selectedLoomIndex,
              onSelect: (index) {
                setState(() {
                  _selectedLoomIndex = index;
                });
              },
            ),

            const SizedBox(height: 16),

            // 3. Selected Loom Details
            if (_selectedLoomIndex != null)
              _SelectedLoomDetails(
                loom: _config.machineSizes[_selectedLoomIndex!],
              ),

            if (_selectedLoomIndex != null) const SizedBox(height: 24),

            // 4. Sort Options
            _SortOptions(
              selected: _sortOption,
              onSelect: (option) {
                setState(() {
                  _sortOption = option;
                });
              },
            ),

            const SizedBox(height: 24),

            // 5. Repeat Main Option
            _RepeatMainOption(
              selected: _repeatMain,
              onSelect: (option) {
                setState(() {
                  _repeatMain = option;
                });
              },
            ),

            const SizedBox(height: 24),

            // 6. Action Buttons
            Row(
              children: [
                // زر الرجوع
                Expanded(
                  child: _BackButton(onTap: () => Navigator.of(context).pop()),
                ),

                const SizedBox(width: 12),

                // زر بدء المعالجة
                Expanded(
                  flex: 2,
                  child: _ProcessButton(
                    enabled: _selectedLoomIndex != null,
                    onTap: _startProcessing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 1. Success Card - بطاقة النجاح الخضراء
class _SuccessCard extends StatelessWidget {
  final String fileName;
  final int fileSize;

  const _SuccessCard({required this.fileName, required this.fileSize});

  @override
  Widget build(BuildContext context) {
    final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF22C55E), // green-500
            Color(0xFF16A34A), // green-600
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة زجاجية
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تم رفع الملف بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$fileName ($fileSizeKB كيلوبايت)',
                  style: const TextStyle(
                    color: Color(0xFFDCFCE7), // green-100
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. Loom Selection - اختيار النول
class _LoomSelection extends StatelessWidget {
  final List<MachineSize> looms;
  final int? selectedIndex;
  final Function(int) onSelect;

  const _LoomSelection({
    required this.looms,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر النول',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...looms.asMap().entries.map((entry) {
            final index = entry.key;
            final loom = entry.value;
            final isSelected = selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEFF6FF) // blue-50
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2563EB) // blue-600
                          : const Color(0xFFE5E7EB), // gray-200
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Radio Button
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loom.name,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF1E40AF) // blue-800
                                    : const Color(0xFF1F2937), // gray-800
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${loom.minWidth} - ${loom.maxWidth} سم | سماحية: ${loom.tolerance} سم',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF2563EB) // blue-600
                                    : const Color(0xFF6B7280), // gray-500
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 3. Selected Loom Details - تفاصيل النول المختار
class _SelectedLoomDetails extends StatelessWidget {
  final MachineSize loom;

  const _SelectedLoomDetails({required this.loom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل النول المختار',
            style: TextStyle(
              color: Color(0xFF1E40AF), // blue-800
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _DetailCell(
                  label: 'الحد الأدنى',
                  value: '${loom.minWidth} سم',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCell(
                  label: 'الحد الأقصى',
                  value: '${loom.maxWidth} سم',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCell(
                  label: 'السماحية',
                  value: '${loom.tolerance} سم',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;

  const _DetailCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2563EB), // blue-600
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E40AF), // blue-800
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4. Sort Options - خيارات الترتيب
class _SortOptions extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const _SortOptions({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ترتيب القطع',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _SortOption(
            label: 'حسب الطول',
            value: 'length',
            isSelected: selected == 'length',
            onTap: () => onSelect('length'),
          ),

          const SizedBox(height: 12),

          _SortOption(
            label: 'حسب العرض',
            value: 'width',
            isSelected: selected == 'width',
            onTap: () => onSelect('width'),
          ),

          const SizedBox(height: 12),

          _SortOption(
            label: 'حسب الكمية',
            value: 'quantity',
            isSelected: selected == 'quantity',
            onTap: () => onSelect('quantity'),
          ),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEFF6FF) // blue-50
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB) // blue-600
                : const Color(0xFFE5E7EB), // gray-200
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF1D4ED8) // blue-700
                    : const Color(0xFF4B5563), // gray-600
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 5. Repeat Main Option - أولوية التكرار
class _RepeatMainOption extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const _RepeatMainOption({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أولوية التكرار',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _RepeatCard(
                type: 'repeat',
                isSelected: selected == 'repeat',
                onTap: () => onSelect('repeat'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RepeatCard(
                type: 'no-repeat',
                isSelected: selected == 'no-repeat',
                onTap: () => onSelect('no-repeat'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // صندوق التوضيح
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected == 'repeat'
                ? const Color(0xFFF0FDF4) // green-50
                : const Color(0xFFFFF7ED), // orange-50
            border: Border.all(
              color: selected == 'repeat'
                  ? const Color(0xFFBBF7D0) // green-200
                  : const Color(0xFFFED7AA), // orange-200
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                selected == 'repeat' ? '📋' : '🚫',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selected == 'repeat'
                      ? 'سيتم تكرار القطع الرئيسية أولاً لتحقيق أفضل كفاءة'
                      : 'سيتم الدمج بدون تكرار القطع الرئيسية',
                  style: TextStyle(
                    color: selected == 'repeat'
                        ? const Color(0xFF166534) // green-800
                        : const Color(0xFF9A3412), // orange-800
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RepeatCard extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _RepeatCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRepeat = type == 'repeat';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isRepeat
                    ? const Color(0xFFF0FDF4) // green-50
                    : const Color(0xFFFFF7ED)) // orange-50
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? (isRepeat
                      ? const Color(0xFF16A34A) // green-600
                      : const Color(0xFFEA580C)) // orange-600
                : const Color(0xFFE5E7EB), // gray-200
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // دائرة الأيقونة
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRepeat
                    ? const Color(0xFFDCFCE7) // green-100
                    : const Color(0xFFFFEDD5), // orange-100
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRepeat ? Icons.repeat : Icons.block,
                color: isRepeat
                    ? const Color(0xFF16A34A) // green-600
                    : const Color(0xFFEA580C), // orange-600
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              isRepeat ? 'تكرار' : 'بدون تكرار',
              style: TextStyle(
                color: isRepeat
                    ? const Color(0xFF166534) // green-800
                    : const Color(0xFF9A3412), // orange-800
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              isRepeat ? 'كفاءة أعلى' : 'تنوع أكبر',
              style: TextStyle(
                color: isRepeat
                    ? const Color(0xFF16A34A) // green-600
                    : const Color(0xFFEA580C), // orange-600
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            // علامة التحديد
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isRepeat
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFEA580C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 6. Action Buttons - أزرار الإجراءات
class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB), // gray-200
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward, // ArrowRight for RTL
                color: Color(0xFF374151), // gray-700
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'رجوع',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ProcessButton({required this.enabled, required this.onTap});

  @override
  State<_ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<_ProcessButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB), // gray-300
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'بدء المعالجة',
              style: TextStyle(
                color: Color(0xFF6B7280), // gray-500
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.play_arrow, color: Color(0xFF6B7280), size: 20),
          ],
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFF2563EB), // blue-600
                Color(0xFF1D4ED8), // blue-700
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'بدء المعالجة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
