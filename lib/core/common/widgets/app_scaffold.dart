import 'package:flutter/material.dart';
import 'package:flutter_justplay/features/home/screens/drawer_screen.dart';
import 'package:get/get.dart';

import '../../constants/assets_const.dart' hide Icons;
import '../../theme/app_colors.dart';
import '../../utils/app_svg.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final AppBar? appBar;
  final Widget? drawer;
  final bool removePadding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool? isUnfocus;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.drawer,
    this.removePadding = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.isUnfocus = true,
  });

  @override
  Widget build(BuildContext context) {
    // Always wrap or replace AppBar to inject our custom leading + actions
    final AppBar finalAppBar = _buildCustomAppBar(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer, // Will open only if not null
      appBar: finalAppBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: removePadding ? 0 : 18),
          child: GestureDetector(
            onTap: () => isUnfocus == true ? FocusScope.of(context).unfocus() : null,
            child: body,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar _buildCustomAppBar(BuildContext context) {
    // Use original appBar properties if provided, otherwise default
    final original = appBar ?? AppBar();

    return AppBar(
      title: original.title ?? const Text(''),
      centerTitle: original.centerTitle,
      backgroundColor: original.backgroundColor,
      elevation: original.elevation,
      shadowColor: original.shadowColor,
      foregroundColor: original.foregroundColor,
      iconTheme: original.iconTheme,
      actionsIconTheme: original.actionsIconTheme,
      flexibleSpace: original.flexibleSpace,
      bottom: original.bottom,

      // Always show menu icon on the left
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black,size: 30,), // You can replace with AppSvg if you want logo
          onPressed: () {
            Get.to(() => MenuScreen(username: 'username'));
          },
          tooltip: 'Menu',
        ),
      ),

      // Always show profile image on the right
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
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
    );
  }
}