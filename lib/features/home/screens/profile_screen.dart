// screens/profile_edit_screen.dart

import 'dart:developer' as DPrint;

import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/button_widgets.dart';
import 'package:flutter_justplay/features/home/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets_const.dart';
import '../../../core/extensions/input_decoration_extensions.dart';
import '../../../core/utils/app_svg.dart';
import '../models/response/fetch_profile_response_model.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _phonenumberTEController = TextEditingController();
  final TextEditingController _cityTEController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phomeNumberFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    setInitial();
    super.initState();
  }

  void setInitial(){
    final userInfo = _profileController.userInfo.value;
    if(userInfo != null){
      _nameTEController.text = userInfo.user.name;
      _phonenumberTEController.text = userInfo.user.phone;
      _cityTEController.text = userInfo.user.city;
    }
  }

  Future<void> _submit() async {
    await _profileController.updatePersonalInfo(
      _nameTEController.text.trim(),
      _phonenumberTEController.text.trim(),
      _cityTEController.text.trim(),
    );
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _phoneController.dispose();
  //   _cityController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E400),
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
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Profile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Edit your details below",
                style: TextStyle(
                  fontSize: 16.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
          
              // Reactive wrapper to update controllers when userInfo changes
          
              const SizedBox(height: 16),
              // ─── Full Name ───
              TextFormField(
                controller: _nameTEController,
                focusNode: _nameFocusNode,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: context.primaryInputDecoration().copyWith(
                  hintText: "Full Name",
                ),
              ),
              const SizedBox(height: 16),
              // ─── Phone Number ───
          
              TextFormField(
                controller: _phonenumberTEController,
                focusNode: _phomeNumberFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: context.primaryInputDecoration().copyWith(
                  hintText: "Phone Number",
                ),
              ),
          
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityTEController,
                focusNode: _cityFocusNode,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: context.primaryInputDecoration().copyWith(
                  hintText: "City",
                ),
              ),
          
              const SizedBox(height: 60),
              Container(
                height: 90,
                child: SecondaryButton(
                  text: 'Save Details',
                  onApiPressed: _submit,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    const double borderRadiusValue = 112.0;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
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
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
            borderSide:
            const BorderSide(color: Color(0xFFE0E0E0), width: 2),
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