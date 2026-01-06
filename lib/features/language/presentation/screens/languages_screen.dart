
import 'package:flutter/material.dart';
import 'package:flutter_justplay/core/common/widgets/app_scaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final RxString selectedLang = Get.locale?.languageCode.obs ?? 'en'.obs;

  void _changeLanguage(String code, Locale locale) {
    selectedLang.value = code;
    Get.updateLocale(locale);

    final box = GetStorage();
    box.write('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      box.write('country_code', locale.countryCode);
    }
  }
//   void _changeLanguage(String code, Locale locale) {
//   selectedLang.value = code;

//   Get.updateLocale(locale);
//   Intl.defaultLocale = locale.toString(); // ⭐ CRITICAL
// }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
      
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Text(
                'select_language'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 32),

              Obx(
                () => Column(
                  children: [
                    _LanguageTile(
                      title: 'English',
                      isSelected: selectedLang.value == 'en',
                      onTap: () =>
                          _changeLanguage('en', const Locale('en', 'US')),
                    ),
                    const SizedBox(height: 12),
                    _LanguageTile(
                      title: 'کوردی',
                      isSelected: selectedLang.value == 'ku',
                      onTap: () =>
                          _changeLanguage('ku', const Locale('ku', 'IQ')),
                    ),
                    const SizedBox(height: 12),
                    _LanguageTile(
                      title: 'العربية',
                      isSelected: selectedLang.value == 'ar',
                      onTap: () =>
                          _changeLanguage('ar', const Locale('ar', 'IQ')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE0E400) // selected (same as booking)
              : const Color(0xFFEAEC91), // unselected
          borderRadius: BorderRadius.circular(91.27),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
