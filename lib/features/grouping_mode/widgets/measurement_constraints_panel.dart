import 'package:flutter/material.dart';

class MeasurementConstraintsPanel extends StatelessWidget {
  final TextEditingController minWidthController;
  final TextEditingController maxWidthController;
  final TextEditingController toleranceController;

  const MeasurementConstraintsPanel({
    super.key,
    required this.minWidthController,
    required this.maxWidthController,
    required this.toleranceController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF3F6FF), // Pale Blue
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
              Icon(Icons.straighten, color: Color(0xFF6B4EEB), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Measurement Constraints',
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

          // Min Width
          _buildInputField('Min Width', minWidthController),
          SizedBox(height: 16),

          // Max Width
          _buildInputField('Max Width', maxWidthController),
          SizedBox(height: 16),

          // Tolerance
          _buildInputField('Tolerance', toleranceController),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
