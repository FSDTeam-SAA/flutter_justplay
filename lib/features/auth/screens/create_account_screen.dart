import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/utils/app_svg.dart';
import 'package:flutter_justplay/features/auth/controller/auth_controller.dart';
import 'package:flutter_justplay/features/auth/screens/login_screen.dart';
import 'package:flutter_justplay/features/auth/screens/privacy_and_policy.dart';
import 'package:flutter_justplay/features/auth/screens/terms_of_service.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/extensions/input_decoration_extensions.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  final TextEditingController _dobController = TextEditingController();
  final FocusNode _dobFocus = FocusNode();

  final AuthController _authController = Get.find<AuthController>();

  bool _agreedToTerms = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      Get.snackbar(
        'Required',
        'Please agree to the Terms of Service and Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    await _authController.register(
      _nameController.text.trim(),
      _phoneController.text,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fixed full-screen background
          Positioned.fill(
            child: Image.asset(
              Images.background,
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable content with SafeArea
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'justplay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 46,
                            ),
                          ),
                          SizedBox(width: 12),
                          AppSvg(
                            asset: Images.logo,
                            height: 45,
                            width: 45,
                            color: Colors.white,
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      const Text(
                        'Create an account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Enter your details below to start playing',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Name",
                          hintStyle: const TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.name,
                        autofillHints: const [AutofillHints.name],
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocus),
                      ),

                      const SizedBox(height: 24),

                      // Phone Field
                      TextFormField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "+ 964 0123 456 789",
                          hintStyle: const TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_dobFocus),
                      ),

                      const SizedBox(height: 24),

                      // Date of Birth Field
                      TextFormField(
                        controller: _dobController,
                        focusNode: _dobFocus,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "Date of birth",
                          hintStyle: const TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.date,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      ),

                      const SizedBox(height: 32),

                      PrimaryButton(text: 'Continue', onApiPressed: _submit),

                      const SizedBox(height: 32),

                      const Text(
                        'By clicking continue, you agree to our',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Checkbox + Terms & Privacy links
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            onChanged: (value) {
                              setState(() => _agreedToTerms = value ?? false);
                            },
                          ),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const TermsOfService()),
                                      ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const PrivacyAndPolicy()),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Login link
                      GestureDetector(
                        onTap: () => Get.to(() => const LoginScreen()),
                        child: Column(
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(width: 50, height: 1.5, color: Colors.white),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20), // Extra bottom space
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}