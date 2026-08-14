import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Tests the translation engine directly, by seeding [AssetLocalizations]
/// instead of loading an asset - the asset loading itself is unchanged.
void main() {
  /// A localization for [languageCode] holding [translations], which may be
  /// nested.
  AssetLocalizations localizations(
    String languageCode,
    Map<String, dynamic> translations,
  ) =>
      AssetLocalizations(Locale(languageCode))
        ..translations = AssetLocalizations.flatten(translations);

  group('Nested translations', () {
    test('a nested translation is addressed by its dot-separated path', () {
      final locale = localizations('en', {
        'pages': {
          'task_list': {'title': 'Tasks', 'description': 'Your tasks'},
        },
      });

      expect(locale.translate('pages.task_list.title'), 'Tasks');
      expect(locale.translate('pages.task_list.description'), 'Your tasks');
    });

    test('nested and dot-separated files are interchangeable', () {
      // Existing translation files use dot-separated keys and downstream apps
      // have hundreds of them, so both spellings have to resolve identically.
      final nested = localizations('en', {
        'pages': {
          'task_list': {'title': 'Tasks'},
        },
      });
      final flat = localizations('en', {'pages.task_list.title': 'Tasks'});

      expect(nested.translations, flat.translations);
    });

    test('an intermediate path is not itself a translation', () {
      final locale = localizations('en', {
        'pages': {
          'task_list': {'title': 'Tasks'},
        },
      });

      expect(locale.canTranslate('pages.task_list'), isFalse);
      // Unknown keys come back as-is, which callers rely on to pass literals.
      expect(locale.translate('pages.task_list'), 'pages.task_list');
    });
  });

  group('Interpolation', () {
    test('{{placeholder}} is replaced from args', () {
      final locale = localizations('en', {
        'greeting': 'Hello {{name}}, you have {{n}} messages',
      });

      expect(
        locale.translate('greeting', args: {'name': 'Bo', 'n': 3}),
        'Hello Bo, you have 3 messages',
      );
    });

    test('surrounding whitespace in a placeholder is ignored', () {
      final locale = localizations('en', {'greeting': 'Hello {{ name }}'});

      expect(locale.translate('greeting', args: {'name': 'Bo'}), 'Hello Bo');
    });

    test('a placeholder with no matching arg is left in place', () {
      // Left visible on purpose: a forgotten argument should be obvious rather
      // than silently rendering an empty gap.
      final locale = localizations('en', {'greeting': 'Hello {{name}}'});

      expect(
        locale.translate('greeting', args: {'other': 'Bo'}),
        'Hello {{name}}',
      );
      expect(locale.translate('greeting'), 'Hello {{name}}');
    });

    test('args interpolate into an untranslated literal', () {
      // RP passes text which may be a key or a literal sentence, so the
      // fallback has to be interpolated too.
      final locale = localizations('en', {});

      expect(locale.translate('Hi {{name}}', args: {'name': 'Bo'}), 'Hi Bo');
    });

    test('a single brace is literal', () {
      final locale = localizations('en', {'math': 'use {x} for the variable'});

      expect(
        locale.translate('math', args: {'x': 'nope'}),
        'use {x} for the variable',
      );
    });
  });

  group('Plurals', () {
    final english = {
      'tasks_one': '{{count}} task left',
      'tasks_other': '{{count}} tasks left',
    };

    test('count selects the _one and _other forms', () {
      final locale = localizations('en', english);

      expect(locale.translate('tasks', count: 1), '1 task left');
      expect(locale.translate('tasks', count: 5), '5 tasks left');
    });

    test('count is available as {{count}} without passing it in args', () {
      final locale = localizations('en', english);

      expect(locale.translate('tasks', count: 7), '7 tasks left');
    });

    test('count combines with other args', () {
      final locale = localizations('en', {
        'tasks_other': '{{name}} has {{count}} tasks',
      });

      expect(
        locale.translate('tasks', count: 2, args: {'name': 'Bo'}),
        'Bo has 2 tasks',
      );
    });

    test(
      '_zero is used for exactly 0 even though English has no zero category',
      () {
        final locale = localizations('en', {
          ...english,
          'tasks_zero': 'All done',
        });

        expect(locale.translate('tasks', count: 0), 'All done');
        // Without a _zero form, 0 is 'other' in English.
        expect(
          localizations('en', english).translate('tasks', count: 0),
          '0 tasks left',
        );
      },
    );

    test('a missing category falls back to _other', () {
      final locale = localizations('en', {'tasks_other': '{{count}} tasks'});

      expect(locale.translate('tasks', count: 1), '1 tasks');
    });

    test('a key with no plural forms falls back to the key itself', () {
      final locale = localizations('en', {'tasks': 'Tasks'});

      expect(locale.translate('tasks', count: 3), 'Tasks');
    });

    test('an untranslated key with a count comes back as-is', () {
      expect(localizations('en', {}).translate('tasks', count: 3), 'tasks');
    });

    test('categories follow the locale, not English', () {
      // Danish, like English, is one/other - so 1 is 'one'.
      expect(
        localizations('da', {
          'tasks_one': '{{count}} opgave',
          'tasks_other': '{{count}} opgaver',
        }).translate('tasks', count: 1),
        '1 opgave',
      );
      // Polish uses 'few' for 2-4 and 'many' for 5+. Selecting on English rules
      // would wrongly give 'other' for both.
      final polish = localizations('pl', {
        'tasks_one': '{{count}} zadanie',
        'tasks_few': '{{count}} zadania',
        'tasks_many': '{{count}} zadań',
        'tasks_other': '{{count}} zadania',
      });
      expect(polish.translate('tasks', count: 1), '1 zadanie');
      expect(polish.translate('tasks', count: 3), '3 zadania');
      expect(polish.translate('tasks', count: 7), '7 zadań');
    });
  });

  group('Backwards compatibility', () {
    test('a plain translate is unchanged', () {
      final locale = localizations('en', {'NEXT': 'NEXT'});

      expect(locale.translate('NEXT'), 'NEXT');
      expect(locale.translate('unknown key'), 'unknown key');
      expect(locale.canTranslate('NEXT'), isTrue);
      expect(locale.canTranslate('unknown key'), isFalse);
    });

    test('a flat dot-separated key still resolves', () {
      // The shape of every translation file RP and its apps ship today.
      final locale = localizations('en', {
        'title.overview': 'Overview',
        'informed_consent.agree_text': 'I agree',
      });

      expect(locale.translate('title.overview'), 'Overview');
      expect(locale.translate('informed_consent.agree_text'), 'I agree');
    });
  });

  group('flatten', () {
    test('a flat map is unchanged', () {
      expect(AssetLocalizations.flatten({'a': 'b', 'c.d': 'e'}), {
        'a': 'b',
        'c.d': 'e',
      });
    });

    test('non-string leaves are stringified', () {
      expect(AssetLocalizations.flatten({'n': 3, 'b': true}), {
        'n': '3',
        'b': 'true',
      });
    });

    test('an empty nested map contributes nothing', () {
      expect(AssetLocalizations.flatten({'a': <String, dynamic>{}}), isEmpty);
    });
  });
}
