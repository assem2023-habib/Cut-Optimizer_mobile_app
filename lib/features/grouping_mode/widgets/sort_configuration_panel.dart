import 'package:flutter/material.dart';
import '../../../core/enums.dart';

class SortConfigurationPanel extends StatelessWidget {
  final SortType selectedSortType;
  final ValueChanged<SortType> onChanged;

  const SortConfigurationPanel({
    super.key,
    required this.selectedSortType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF5F8), // Pale Pink
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.sort, color: Color(0xFF6B4EEB), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sort Configuration',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Radio Buttons
          _buildRadioOption(SortType.sortByWidth, 'Width'),
          SizedBox(height: 12),
          _buildRadioOption(SortType.sortByQuantity, 'Quantity'),
          SizedBox(height: 12),
          _buildRadioOption(SortType.sortByHeight, 'Height'),
        ],
      ),
    );
  }

  Widget _buildRadioOption(SortType value, String label) {
    final isSelected = selectedSortType == value;

    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Color(0xFF6B4EEB) : Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF6B4EEB),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
        ],
      ),
    );
  }
}
