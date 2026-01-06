import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class LanguageSwitchRow extends StatelessWidget {
  LanguageSwitchRow({super.key});

  final RxString selectedLang = Get.locale?.languageCode.obs ?? 'en'.obs;

  void _changeLanguage(String code, Locale locale) {
    selectedLang.value = code;

    Get.updateLocale(locale);
    Intl.defaultLocale = locale.toString();

    final box = GetStorage();
    box.write('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      box.write('country_code', locale.countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🔥 key
          children: [
            _LangChip(
              title: 'English',
              isSelected: selectedLang.value == 'en',
              onTap: () => _changeLanguage('en', const Locale('en', 'US')),
            ),
            _LangChip(
              title: 'عربي',
              isSelected: selectedLang.value == 'ar',
              onTap: () => _changeLanguage('ar', const Locale('ar', 'IQ')),
            ),
            _LangChip(
              title: 'کوردی',
              isSelected: selectedLang.value == 'ku',
              onTap: () => _changeLanguage('ku', const Locale('ku', 'IQ')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // 🔥 ensures equal width
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48, // 👈 bigger height
          margin: const EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isSelected ? 1 : 0.9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, // 👈 slightly bigger text
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
