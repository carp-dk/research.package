part of '../../ui.dart';

/// Localization support using assets files.
///
/// Use [translate] to translate any text.
///
/// All translations should be put in the `assets/lang/` folder as json files,
/// one for each local (e.g., `en.json`or `da.json`). Note that only the
/// `languageCode` of a `Locale` is used.
///
/// Remember to add the `assets/lang/` folder to the list of `assets` in the
/// `pubspec.yaml` file like this:
///
/// ```
/// flutter:
///   assets:
///     - assets/lang/
///     ...
/// ```
///
/// Translations may be nested, and are addressed with a dot-separated path.
/// These two files are equivalent:
///
/// ```json
///  { "pages": { "task_list": { "title": "Tasks" } } }
///  { "pages.task_list.title": "Tasks" }
/// ```
///
/// A translation can contain `{{placeholder}}` values, filled in from the
/// `args` of [translate], and a key can be given per plural category using the
/// `_zero`, `_one`, `_two`, `_few`, `_many` and `_other` suffixes, selected by
/// the `count` of [translate]:
///
/// ```json
///  {
///    "greeting": "Hello {{name}}",
///    "tasks_one": "{{count}} task left",
///    "tasks_other": "{{count}} tasks left"
///  }
/// ```
class AssetLocalizations {
  /// A map of available translations for this [locale].
  ///
  /// Nested translations are flattened into dot-separated keys, so this map is
  /// always flat regardless of how the translations were written.
  Map<String, String> translations = {};

  final Locale locale;

  /// Create an assets localization based on [locale].
  AssetLocalizations(this.locale);

  /// The `{{placeholder}}` pattern used by [translate].
  ///
  /// Surrounding whitespace is allowed and ignored, i.e. `{{ name }}` and
  /// `{{name}}` are the same placeholder.
  static final RegExp _placeholder = RegExp(r'\{\{\s*(\w+)\s*\}\}');

  /// The plural category suffixes recognized in translation keys, in the order
  /// [Intl.pluralLogic] expects them.
  static const List<String> _pluralCategories = [
    'zero',
    'one',
    'two',
    'few',
    'many',
    'other',
  ];

  /// Flattens a - possibly nested - map of translations into a flat map whose
  /// keys are dot-separated paths.
  ///
  /// ```dart
  ///  flatten({'pages': {'task_list': {'title': 'Tasks'}}});
  ///  // {'pages.task_list.title': 'Tasks'}
  /// ```
  ///
  /// A map which is already flat is returned unchanged, which is what makes
  /// nested and dot-separated translation files interchangeable. Values which
  /// are neither a map nor a string are converted with `toString()`.
  static Map<String, String> flatten(Map<String, dynamic> translations) {
    Map<String, String> flat = {};

    void visit(String prefix, Map<dynamic, dynamic> map) {
      map.forEach((key, value) {
        String path = prefix.isEmpty ? '$key' : '$prefix.$key';
        if (value is Map) {
          visit(path, value);
        } else {
          flat[path] = '$value';
        }
      });
    }

    visit('', translations);
    return flat;
  }

  /// Returns the localized resources object of type [AssetLocalizations] for the
  /// widget tree that corresponds to the given [context].
  ///
  /// Returns `null` if no resources object of type [AssetLocalizations] exists within
  /// the given `context`.
  static AssetLocalizations? of(BuildContext context) =>
      Localizations.of<AssetLocalizations>(context, AssetLocalizations);

  /// The file name of the localization asset.
  String get filename => 'assets/lang/${locale.languageCode}.json';

  /// Load the translations from [filename] based on the [locale].
  Future<void> load() async {
    print("$runtimeType - loading '$filename'");

    String jsonString = await rootBundle.loadString(filename, cache: false);

    translations = flatten(json.decode(jsonString) as Map<String, dynamic>);
  }

  /// Can this [key] be translated by this localization?
  bool canTranslate(String key) => translations.containsKey(key);

  /// Translate [key] to this [locale].
  ///
  /// If [key] is not translated, [key] is returned 'as-is'. This makes it safe
  /// to pass text which may be either a translation key or a literal.
  ///
  /// Nested translations are addressed with a dot-separated path, e.g.
  /// `pages.task_list.title`.
  ///
  /// If [args] is given, every `{{placeholder}}` in the translation is replaced
  /// with the matching entry. A placeholder with no matching entry is left in
  /// place, so that a forgotten argument is visible rather than silently blank.
  ///
  /// ```dart
  ///  translate('greeting', args: {'name': 'Bo'}); // 'Hello Bo'
  /// ```
  ///
  /// If [count] is given, the plural form of [key] is used - that is the key
  /// suffixed with the plural category of [count] in this [locale], one of
  /// `_zero`, `_one`, `_two`, `_few`, `_many` or `_other`. [count] is also
  /// available to the translation as `{{count}}`, without having to pass it in
  /// [args] as well.
  ///
  /// ```dart
  ///  translate('tasks', count: 3); // '3 tasks left' from 'tasks_other'
  /// ```
  ///
  /// The categories which apply depend on the language - English only ever uses
  /// `_one` and `_other` - except for `_zero`, which is used for a [count] of
  /// exactly 0 in any language when present. A category which is not translated
  /// falls back to `_other`, and a [key] with no plural forms at all falls back
  /// to [key] itself.
  String translate(String key, {Map<String, Object?>? args, num? count}) {
    String resolvedKey = (count == null) ? key : _pluralKeyFor(key, count);
    String translation = translations[resolvedKey] ?? translations[key] ?? key;

    // Keep the plain lookup allocation-free - with nothing to fill in, there is
    // nothing for the interpolation to do.
    if (args == null && count == null) return translation;

    return _interpolate(translation, {
      if (count != null) 'count': count,
      ...?args,
    });
  }

  /// Replaces every `{{placeholder}}` in [template] with the matching entry in
  /// [args], leaving placeholders without an entry untouched.
  String _interpolate(String template, Map<String, Object?> args) =>
      template.replaceAllMapped(_placeholder, (match) {
        String name = match.group(1)!;
        return args.containsKey(name) ? '${args[name]}' : match.group(0)!;
      });

  /// The plural form of [key] to use for [count] in this [locale].
  ///
  /// Returns the translated key suffixed with the plural category, or [key]
  /// itself if there is no `_other` form to fall back on.
  String _pluralKeyFor(String key, num count) {
    // Only offer the categories which are actually translated, so that
    // [Intl.pluralLogic] can fall back to '_other' for the rest.
    Map<String, String?> forms = {
      for (var category in _pluralCategories)
        category: translations.containsKey('${key}_$category')
            ? '${key}_$category'
            : null,
    };

    return Intl.pluralLogic<String>(
      count,
      zero: forms['zero'],
      one: forms['one'],
      two: forms['two'],
      few: forms['few'],
      many: forms['many'],
      // [Intl.pluralLogic] requires a value here. Falling back to the key means
      // an untranslated plural degrades to a plain lookup of [key].
      other: forms['other'] ?? key,
      locale: locale.languageCode,
    );
  }

  /// A default [LocalizationsDelegate] for [AssetLocalizations].
  ///
  /// This default delegate loads translations from the `assets/lang` file path.
  static const LocalizationsDelegate<AssetLocalizations> delegate =
      AssetLocalizationsDelegate();
}

/// A factory for a set of localized resources of type `AssetLocalizations`,
/// to be loaded by a [Localizations] widget.
class AssetLocalizationsDelegate
    extends LocalizationsDelegate<AssetLocalizations> {
  /// Create a [AssetLocalizationsDelegate].
  const AssetLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // we don't restrict the supported locales here since the user of RP
    // might create his/her own translations
    return true;
  }

  @override
  Future<AssetLocalizations> load(Locale locale) async {
    AssetLocalizations localizations = AssetLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AssetLocalizationsDelegate old) => false;
}
