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
import '../widgets/language_widgets.dart';

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
    await _authController.login(
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
          // Background image
          Positioned.fill(
            child: Image.asset(Images.background, fit: BoxFit.cover),
          ),

          // Foreground: language row + form stacked in normal flow (inside
          // a scroll view) so the language row can never overlap the logo
          // below it, regardless of screen height or content size.
          // Positioned.fill (not a bare non-positioned child) so the Stack
          // still sizes itself to the full screen and the background image
          // isn't cropped to the scroll view's shrink-wrapped content height.
          Positioned.fill(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      // Language buttons — locked to LTR order so
                      // English/عربي/کوردی never swap places when the app's
                      // reading direction flips to RTL.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: LanguageSwitchRow(),
                      ),

                      const SizedBox(height: 48),

                      // Logo + "justplay" text — also locked to LTR so the
                      // icon/text order stays fixed regardless of language.
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
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
                      ),

                      const SizedBox(
                        height: 35,
                      ), // space between logo and title
                      // Title
                      Text(
                        'login'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'enter_login_details'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 27),

                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "name".tr,
                          hintStyle: TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.name,
                        autofillHints: const [AutofillHints.name],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_nameFocus),
                      ),

                      SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        decoration: context.primaryInputDecoration().copyWith(
                          hintText: "+ 964 0123 456 789",
                          hintStyle: TextStyle(color: Color(0xFF828282)),
                        ),
                        validator: Validators.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_nameFocus),
                      ),

                      SizedBox(height: 24),

                      PrimaryButton(text: 'login'.tr, onApiPressed: _submit),

                      SizedBox(height: 17.5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => CreateAccountScreen());
                            },
                            child: Text(
                              'create_account_button'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 2,
                          ), // 👈 Increased gap between text & underline

                          Container(
                            width: 130, // underline width
                            height: 1.3, // thickness
                            color: Colors.white,
                          ),
                        ],
                      ),
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
