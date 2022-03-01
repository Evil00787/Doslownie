import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/message_format.dart';

typedef TranslateFunc = String Function(BuildContext);

// ignore: one_member_abstracts
abstract class CurrentLocaleObserver {
  void onLocaleSet(Locale locale);
}

class AppLocalesDelegate extends LocalizationsDelegate<AppLocales> {
	static List<Locale> supportedLocales = [
		const Locale('en', 'US'),
		const Locale('pl', 'PL')
	];

	const AppLocalesDelegate();

	@override
	bool isSupported(Locale locale) {
		return supportedLocales.contains(locale);
	}

	@override
	Future<AppLocales> load(Locale locale) async {
		await AppLocales.instance.setLocale(locale);
		return AppLocales.instance;
	}

	@override
	bool shouldReload(AppLocalesDelegate old) => false;
}

class AppLocales {
	Locale? locale;
  final List<CurrentLocaleObserver> _localeObservers = [];

	static AppLocales instance = AppLocales();
  static AppLocales get I => instance;
	static AppLocales of(BuildContext context) => Localizations.of<AppLocales>(context, AppLocales)!;

	static const LocalizationsDelegate<AppLocales> delegate = AppLocalesDelegate();

	final Map<Locale, Map<String, dynamic>> _translations = {};

	Future setLocale(Locale locale) async {
		if (_translations.isEmpty) await loadLocales();
		if (this.locale == locale) return;
		this.locale = locale;
    for (var observer in _localeObservers) {
      observer.onLocaleSet(locale);
    }
	}

	Future loadLocales() async {
		for (var locale in AppLocalesDelegate.supportedLocales) {
			var localeTranslations = await rootBundle.loadString('i18n/$locale.json');
			_translations[locale] = json.decode(localeTranslations);
		}
	}

	String get(String key, [Map<String, Object>? args, Locale? locale]) {
		locale ??= this.locale;
		try {
			var string = key.split('.').fold(_translations[locale], (object, key) => (object as Map)[key]) as String;
			if (args == null) return string;
			return MessageFormat(string, locale: locale.toString()).format(args);
// ignore: avoid_catching_errors
		} on NoSuchMethodError {
			print('Key $key has no localized string in language ${locale!.languageCode}');
			return '';
// ignore: avoid_catching_errors
		} on Error catch (e) {
      print('$e');
			return '';
		}
	}

  String call(String key, [Map<String, Object>? args, Locale? locale]) => get(key, args, locale);

	Map<String, String> getTranslations(String key, [Map<String, Object>? args]) {
		var translations = <String, String>{};
		for (var locale in AppLocalesDelegate.supportedLocales) {
		  translations[locale.languageCode] = get(key, args, locale);
		}
		return translations;
	}

  void observeLocaleChanges(CurrentLocaleObserver observer) => _localeObservers.add(observer);
}