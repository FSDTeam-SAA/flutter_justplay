import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/utils/app_svg.dart';
import 'package:flutter_justplay/features/auth/screens/create_account_screen.dart';
import 'package:flutter_justplay/navigation_menu.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/extensions/input_decoration_extensions.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              Images.background,
              fit: BoxFit.cover,
            ),
          ),

          // Main content (logo + titles) – centered vertically & horizontally
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // vertical center
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo + "justplay" text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
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

                const SizedBox(height: 35), // space between logo and title

                // Title
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Enter your log in details below',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 27,),

                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: context.primaryInputDecoration().copyWith(
                    hintText: "Name",
                      hintStyle: TextStyle(color: Color(0xFF828282))
                  ),
                  validator: Validators.name,
                  autofillHints: const [AutofillHints.name],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_nameFocus),
                ),

                SizedBox(height: 24,),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: context.primaryInputDecoration().copyWith(
                    hintText: "+ 964 0123 456 789",
                    hintStyle: TextStyle(color: Color(0xFF828282))
                  ),
                  validator: Validators.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_nameFocus),
                ),

                SizedBox(height: 24,),

                PrimaryButton(text: 'Login', onSimplePressed: (){Get.to(() => NavigationMenu());},),

                SizedBox(height: 17.5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {Get.to(() => CreateAccountScreen());},
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: 2), // 👈 Increased gap between text & underline

                    Container(
                      width: 130,   // underline width
                      height: 1.3, // thickness
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}