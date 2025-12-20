import 'package:flutter/material.dart';
import '../../../models/config.dart';

/// القسم 1: إعدادات النول
/// يشمل: قائمة الأنوال + نموذج الإضافة + التعديل + الحذف
class LoomSettings extends StatefulWidget {
  final List<MachineSize> machineSizes;
  final Function(List<MachineSize>) onUpdate;

  const LoomSettings({
    super.key,
    required this.machineSizes,
    required this.onUpdate,
  });

  @override
  State<LoomSettings> createState() => _LoomSettingsState();
}

class _LoomSettingsState extends State<LoomSettings> {
  bool _showAddForm = false;
  int? _editingIndex;

  final _nameController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _toleranceController = TextEditingController();
  final _pathLengthController = TextEditingController();
  PairOddMode _selectedPairOddMode = PairOddMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _toleranceController.dispose();
    _pathLengthController.dispose();
    super.dispose();
  }

  void _toggleAddForm() {
    setState(() {
      _showAddForm = !_showAddForm;
      if (!_showAddForm) {
        _clearForm();
      }
    });
  }

  void _clearForm() {
    _nameController.clear();
    _minController.clear();
    _maxController.clear();
    _toleranceController.clear();
    _pathLengthController.clear();
    _selectedPairOddMode = PairOddMode.disabled;
  }

  void _addLoom() {
    if (_nameController.text.isEmpty ||
        _minController.text.isEmpty ||
        _maxController.text.isEmpty ||
        _pathLengthController.text.isEmpty) {
      return;
    }

    final newLoom = MachineSize(
      name: _nameController.text,
      minWidth: int.tryParse(_minController.text) ?? 0,
      maxWidth: int.tryParse(_maxController.text) ?? 0,
      tolerance: int.tryParse(_toleranceController.text) ?? 0,
      pathLength: int.tryParse(_pathLengthController.text) ?? 0,
    );

    final updated = List<MachineSize>.from(widget.machineSizes)..add(newLoom);
    widget.onUpdate(updated);

    setState(() {
      _showAddForm = false;
      _clearForm();
    });
  }

  void _startEdit(int index) {
    final loom = widget.machineSizes[index];
    _nameController.text = loom.name;
    _minController.text = loom.minWidth.toString();
    _maxController.text = loom.maxWidth.toString();
    _toleranceController.text = loom.tolerance.toString();
    _pathLengthController.text = loom.pathLength.toString();

    setState(() {
      _editingIndex = index;
      _selectedPairOddMode = loom.pairOddMode;
    });
  }

  void _saveEdit() {
    if (_editingIndex == null) return;

    final updatedLoom = MachineSize(
      name: _nameController.text,
      minWidth: int.tryParse(_minController.text) ?? 0,
      maxWidth: int.tryParse(_maxController.text) ?? 0,
      tolerance: int.tryParse(_toleranceController.text) ?? 0,
      pathLength: int.tryParse(_pathLengthController.text) ?? 0,
    );

    final updated = List<MachineSize>.from(widget.machineSizes);
    updated[_editingIndex!] = updatedLoom;
    widget.onUpdate(updated);

    setState(() {
      _editingIndex = null;
      _clearForm();
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _clearForm();
    });
  }

  void _deleteLoom(int index) {
    final updated = List<MachineSize>.from(widget.machineSizes)
      ..removeAt(index);
    widget.onUpdate(updated);
  }

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
          // العنوان مع زر الإضافة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إعدادات النول',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              GestureDetector(
                onTap: _toggleAddForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _showAddForm
                        ? const Color(0xFFEFF6FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showAddForm ? Icons.close : Icons.add,
                        size: 16,
                        color: const Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showAddForm ? 'إلغاء' : 'إضافة نول',
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // نموذج الإضافة
          if (_showAddForm)
            AddLoomForm(
              nameController: _nameController,
              minController: _minController,
              maxController: _maxController,
              toleranceController: _toleranceController,
              pathLengthController: _pathLengthController,
              selectedPairOddMode: _selectedPairOddMode,
              onPairOddChanged: (mode) {
                setState(() {
                  _selectedPairOddMode = mode;
                });
              },
              onAdd: _addLoom,
              onCancel: _toggleAddForm,
            ),

          if (_showAddForm) const SizedBox(height: 16),

          // قائمة الأنوال
          ...widget.machineSizes.asMap().entries.map((entry) {
            final index = entry.key;
            final loom = entry.value;
            final isEditing = _editingIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: isEditing
                  ? EditLoomForm(
                      nameController: _nameController,
                      minController: _minController,
                      maxController: _maxController,
                      toleranceController: _toleranceController,
                      selectedPairOddMode: _selectedPairOddMode,
                      onPairOddChanged: (mode) {
                        setState(() {
                          _selectedPairOddMode = mode;
                        });
                      },
                      onSave: _saveEdit,
                      onCancel: _cancelEdit,
                    )
                  : LoomCard(
                      loom: loom,
                      onEdit: () => _startEdit(index),
                      onDelete: () => _deleteLoom(index),
                    ),
            );
          }),
        ],
      ),
    );
  }
}

/// نموذج إضافة نول
class AddLoomForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController minController;
  final TextEditingController maxController;
  final TextEditingController toleranceController;
  final TextEditingController pathLengthController;
  final PairOddMode selectedPairOddMode;
  final Function(PairOddMode) onPairOddChanged;
  final VoidCallback onAdd;
  final VoidCallback onCancel;

  const AddLoomForm({
    super.key,
    required this.nameController,
    required this.minController,
    required this.maxController,
    required this.toleranceController,
    required this.pathLengthController,
    required this.selectedPairOddMode,
    required this.onPairOddChanged,
    required this.onAdd,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إضافة نول جديد',
            style: TextStyle(
              color: Color(0xFF1E40AF), // blue-800
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildTextField('اسم النول', nameController),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'الحد الأدنى',
                  minController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'الحد الأقصى',
                  maxController,
                  isNumber: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _buildTextField('السماحية', toleranceController, isNumber: true),

          const SizedBox(height: 12),
          _buildTextField('طول المسار', pathLengthController, isNumber: true),

          const SizedBox(height: 16),
          _buildPairOddDropdown(selectedPairOddMode, onPairOddChanged),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('إضافة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('إلغاء'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF374151),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPairOddDropdown(
    PairOddMode selected,
    Function(PairOddMode) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نظام الأزواج (زوجي/فردي)',
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PairOddMode>(
              value: selected,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              onChanged: (mode) {
                if (mode != null) onChanged(mode);
              },
              items: [
                DropdownMenuItem(
                  value: PairOddMode.disabled,
                  child: Text('معطل', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: PairOddMode.pair,
                  child: Text(
                    'زوجي (الكمية / 2)',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: PairOddMode.odd,
                  child: Text('فردي (كما هي)', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// نموذج تعديل نول
class EditLoomForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController minController;
  final TextEditingController maxController;
  final TextEditingController toleranceController;
  final PairOddMode selectedPairOddMode;
  final Function(PairOddMode) onPairOddChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditLoomForm({
    super.key,
    required this.nameController,
    required this.minController,
    required this.maxController,
    required this.toleranceController,
    required this.selectedPairOddMode,
    required this.onPairOddChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSmallField('الاسم', nameController),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallField('أدنى', minController, isNumber: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallField('أقصى', maxController, isNumber: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSmallField(
                  'سماحية',
                  toleranceController,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPairOddDropdown(selectedPairOddMode, onPairOddChanged),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('حفظ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('إلغاء'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E7EB),
                    foregroundColor: const Color(0xFF374151),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildPairOddDropdown(
    PairOddMode selected,
    Function(PairOddMode) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نظام الأزواج (زوجي/فردي)',
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PairOddMode>(
              value: selected,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              onChanged: (mode) {
                if (mode != null) onChanged(mode);
              },
              items: [
                DropdownMenuItem(
                  value: PairOddMode.disabled,
                  child: Text('معطل', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: PairOddMode.pair,
                  child: Text(
                    'زوجي (الكمية / 2)',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: PairOddMode.odd,
                  child: Text('فردي (كما هي)', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// بطاقة نول (عرض فقط)
class LoomCard extends StatelessWidget {
  final MachineSize loom;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LoomCard({
    super.key,
    required this.loom,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loom.name,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoCell(
                  label: 'الحد الأدنى',
                  value: loom.minWidth.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoCell(
                  label: 'الحد الأقصى',
                  value: loom.maxWidth.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoCell(
                  label: 'السماحية',
                  value: loom.tolerance.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoCell(
                  label: 'زوجي/فردي',
                  value: _getPairOddLabel(loom.pairOddMode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPairOddLabel(PairOddMode mode) {
    switch (mode) {
      case PairOddMode.disabled:
        return 'معطل';
      case PairOddMode.pair:
        return 'زوجي';
      case PairOddMode.odd:
        return 'فردي';
    }
  }
}

/// خلية معلومات
class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
