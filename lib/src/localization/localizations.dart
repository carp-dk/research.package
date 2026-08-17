part of '../../ui.dart';

/// Localization support for Research Package using [LocalizationLoader]
/// configurations.
///
/// Use [translate] to translate any text, like this:
///
/// ```
///  RPLocalizations.of(context).translate('key');
/// ```
///
class RPLocalizations extends AssetLocalizations {
  static const String assetPath = 'research_package/assets/lang';

  /// Create a localization based on [locale].
  RPLocalizations(super.locale);

  /// Returns the localized resources object of type [RPLocalizations] for the
  /// widget tree that corresponds to the given [context].
  ///
  /// Returns `null` if no resources object of type [RPLocalizations] exists within
  /// the given `context`.
  static RPLocalizations? of(BuildContext context) =>
      Localizations.of<RPLocalizations>(context, RPLocalizations);

  /// The name of the static localization asset.
  String get staticAssetName =>
      'packages/$assetPath/${locale.languageCode}.json';

  /// Load the translations for Research Package.
  ///
  /// The translations is a combination of the static names in the package as
  /// provided in [staticAssetName] combined with translations of the any text
  /// provided by the [loaders], which knows how to load translations.
  @override
  Future<void> load({List<LocalizationLoader> loaders = const []}) async {
    print("$runtimeType - loading static translations from '$staticAssetName'");
    String jsonString = '{}';

    // first try to load the static translations as part of RP
    try {
      jsonString = await rootBundle.loadString(
        staticAssetName,
        cache: false,
      );
    } catch (_) {
      print(
          "WARNING - Failed to load RP translations for '$locale' and it seems like RP does not support this locale in the current version. "
          'If you are using this locale in your app, you should consider to make a pull request to RP so we can add this locale to the package for others to use as well. '
          'See https://carp.cachet.dk/localization for a description on how to do this. '
          'For now, translations provided in the app localization file(s) are also used for RP so you can provide translations for the RP terms there for now.');
    }

    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    translations.addAll(AssetLocalizations.flatten(jsonMap));

    for (LocalizationLoader loader in loaders) {
      Map<String, dynamic> loadedTranslations = await loader.load(locale);
      // Merge the maps.
      // Note that keys in [_translations] is overwritten with keys in [loadedTranslations].
      // Hence, it is possible to overwrite the default translations.
      // Flattened here so that a loader may return nested translations.
      translations.addAll(AssetLocalizations.flatten(loadedTranslations));
    }
  }

  /// A default [LocalizationsDelegate] for [RPLocalizations].
  ///
  /// This default delegate loads translations from the `assets/lang` file path.
  static LocalizationsDelegate<RPLocalizations> delegate =
      RPLocalizationsDelegate(loaders: [const AssetLocalizationLoader()]);
}

class RPLocalizationsDelegate extends LocalizationsDelegate<RPLocalizations> {
  final List<LocalizationLoader> loaders;
  bool _shouldReload = false;

  /// Create a [RPLocalizationsDelegate].
  ///
  /// [loaders] specify a list of [LocalizationLoader] which each can load
  /// different translations. Translations from all [loaders] are merged.
  /// Potential duplicate translation keys are overwritten in the order of
  /// the list of loaders.
  RPLocalizationsDelegate({required this.loaders});

  @override
  bool isSupported(Locale locale) {
    // we don't restrict the supported locales here since the user of RP
    // might create his/her own translations
    return true;
  }

  @override
  Future<RPLocalizations> load(Locale locale) async {
    RPLocalizations localizations = RPLocalizations(locale);
    await localizations.load(loaders: loaders);
    _shouldReload = false;
    return localizations;
  }

  /// Mark that this delegate should reload its translations.
  /// Useful if, for example, downloaded from the network.
  void reload() => _shouldReload = true;

  @override
  bool shouldReload(RPLocalizationsDelegate old) => _shouldReload;
}

/// Interface for location loaders who knows how to load a translation
/// map for a [Locale].
abstract class LocalizationLoader {
  /// Load translations for [locale].
  ///
  /// The map may be nested, in which case it is flattened into dot-separated
  /// keys when merged - see [AssetLocalizations.flatten]. Returning a flat
  /// `Map<String, String>` remains valid.
  Future<Map<String, dynamic>> load(Locale locale);
}

/// A [LocalizationLoader] which can load translations from a map.
///
/// [map] must map a language code to a map of translations keys
/// mapped to translations (i.e., a map of maps).
///
/// ```json
///  {
///    'en': {'header':'This is a header', ...},
///    'da': {'header':'Dette er en overskrift', ...},
///  }
/// ```
class MapLocalizationLoader implements LocalizationLoader {
  /// The map between a language code and the localizations for this language.
  ///
  /// The localizations of a language may be nested.
  final Map<String, Map<String, dynamic>> map;

  /// Create a [MapLocalizationLoader] based on the [map].
  MapLocalizationLoader(this.map);

  @override
  Future<Map<String, dynamic>> load(Locale locale) async =>
      (map.containsKey(locale.languageCode)) ? map[locale.languageCode]! : {};
}

/// A [LocalizationLoader] which can load translations from file assets
/// bundles. Remember to add the language file assets to the
/// `pubspec.yaml` file.
class AssetLocalizationLoader implements LocalizationLoader {
  final String basePath;

  /// Create a asset location loader.
  /// Loads from `assets/lang` per default.
  const AssetLocalizationLoader({this.basePath = 'assets/lang'});

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    String path = '$basePath/${locale.languageCode}.json';
    print("$runtimeType - loading '$path'");
    String jsonString = await rootBundle.loadString(path);

    // Decoded as-is, so nested translations survive to be flattened on merge.
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
