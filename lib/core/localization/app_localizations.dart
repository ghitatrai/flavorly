import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  static final AppLocalizations instance = AppLocalizations._internal();
  AppLocalizations._internal();

  static const String _langKey = 'user_selected_language';
  final ValueNotifier<String> currentLangNotifier = ValueNotifier('en');

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Flavorly',
      'recipes': 'Recipes',
      'favorites': 'Favorites',
      'grocery': 'Grocery',
      'search_hint': 'Search recipes or ingredients...',
      'surprise_me': 'Surprise Me!',
      'converter': 'Kitchen Converter',
      'settings': 'Settings',
      'ingredients': 'Ingredients Checklist',
      'export_list': 'Export List',
      'nutrition': 'Estimated Nutrition (Per Serving)',
      'notes': 'My Notes & Rating',
      'save': 'Save Recipe',
    },
    'fr': {
      'app_title': 'Flavorly',
      'recipes': 'Recettes',
      'favorites': 'Favoris',
      'grocery': 'Courses',
      'search_hint': 'Rechercher des recettes...',
      'surprise_me': 'Surprenez-moi !',
      'converter': 'Convertisseur',
      'settings': 'Paramètres',
      'ingredients': "Liste d'ingrédients",
      'export_list': 'Exporter',
      'nutrition': 'Nutrition Estimée (Par Portion)',
      'notes': 'Mes Notes & Avis',
      'save': 'Enregistrer',
    },
    'ar': {
      'app_title': 'فلافورلي',
      'recipes': 'الوصفات',
      'favorites': 'المفضلة',
      'grocery': 'قائمة التسوق',
      'search_hint': 'ابحث عن الوصفات والمكونات...',
      'surprise_me': 'فاجئني!',
      'converter': 'محول المطبخ',
      'settings': 'الإعدادات',
      'ingredients': 'قائمة المكونات',
      'export_list': 'تصدير القائمة',
      'nutrition': 'التغذية المقدرة (لكل وجبة)',
      'notes': 'ملاحظاتي وتقييمي',
      'save': 'حفظ الوصفة',
    },
  };

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_langKey) ?? 'en';
    currentLangNotifier.value = savedLang;
  }

  Future<void> changeLanguage(String langCode) async {
    currentLangNotifier.value = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  String translate(String key) {
    final lang = currentLangNotifier.value;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}