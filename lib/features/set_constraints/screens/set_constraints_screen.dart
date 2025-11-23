import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../../sorting_options/screens/sorting_options_screen.dart';

class SetConstraintsScreen extends StatelessWidget {
  const SetConstraintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue.shade900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SET CONSTRAINTS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: "Max Width",
                initialValue: "100",
                suffixText: "cm",
              ),
              const SizedBox(height: 24),
              const CustomTextField(
                label: "Min Width",
                initialValue: "10",
                suffixText: "cm",
              ),
              const SizedBox(height: 24),
              const CustomTextField(
                label: "Allowed Width",
                initialValue: "50",
                suffixText: "cm",
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SortingOptionsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1), // Corporate Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Next >",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
