import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/utils/app_svg.dart';
import 'package:flutter_justplay/features/auth/screens/create_account_screen.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/extensions/input_decoration_extensions.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  final AuthController _authController = Get.find<AuthController>();

  Future<void> _submit() async {
    DPrint.log("Login action");
    if (!_formKey.currentState!.validate()) return;
    // Pass data to AuthController (you can extend AuthController to handle signup)
    await _authController.login(_nameController.text.trim(),_phoneController.text, context);
  }

  @override
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
              padding: const EdgeInsets.all(12.0),
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
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Enter your log in details below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 27),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.black,
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
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "+ 964 0123 456 789",
                          hintStyle: const TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      ),

                      const SizedBox(height: 24),

                      PrimaryButton(text: 'Login', onApiPressed: _submit),

                      const SizedBox(height: 17.5),

                      // Create Account
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => Get.to(() => CreateAccountScreen()),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 130,
                            height: 1.3,
                            color: Colors.white,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20), // Optional bottom padding
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