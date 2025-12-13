// screens/profile_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/button_widgets.dart';

import '../../../core/constants/assets_const.dart';
import '../../../core/utils/app_svg.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Yellow AppBar with back + avatar
      appBar: AppBar(
        backgroundColor: Color(0xFFE0E400),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0, bottom: 7),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: AppSvg(
                asset: Images.logo,
                height: 24,
                width: 24,
                color: Colors.black,
              ),
            ),
          ),

        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Profile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            Text(
              "Edit your details below",
              style: TextStyle(fontSize: 16.5, color: Colors.black, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 40),

            // Editable Name Field
            _buildEditableField(
              controller: _nameController,
              hintText: "Enter your name",
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

            // Editable Phone Field
            _buildEditableField(
              controller: _phoneController,
              hintText: "Enter phone number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Editable City Field
            _buildEditableField(
              controller: _cityController,
              hintText: "Enter your city",
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 60),

            Container(height:90,child: SecondaryButton(text: 'Save Details',)),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    const double borderRadiusValue = 112.0; // Change this value to adjust the roundness

    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        // Optional: add a subtle shadow or border here if needed
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 17, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2), // Optional: slightly thicker on focus
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}