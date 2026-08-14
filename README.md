# Research Package

[![pub package](https://img.shields.io/pub/v/research_package.svg)](https://pub.dartlang.org/packages/research_package)
[![style: effective dart](https://img.shields.io/badge/style-pedandic_dart-40c4ff.svg)](https://pub.dev/packages/pedandic_dart)
[![github stars](https://img.shields.io/github/stars/cph-cachet/research.package.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/cph-cachet/research.package)
[![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

Research Package is a Flutter [package](https://pub.dartlang.org/packages/research_package) for building research study apps on Android and iOS using [Flutter](https://flutter.dev).

Research Package is a Flutter implementation of the [Apple ResearchKit](https://www.researchandcare.org/researchkit/) available for iOS (just like [ResearchStack](https://github.com/ResearchStack/ResearchStack) is for Android). The overarching goal of ResearchPackage is to enable developers and researchers to design and build cross-platform (iOS and Android) research applications using the same codebase.

Research Package is designed from the ground up to meet the requirements of most scientific research, including capturing participant consent, extensible input tasks, and the security and privacy needs necessary for IRB approval.
The main features of Research Package are:

- [Obtaining informed consent](https://carp.cachet.dk/obtaining-consent/) from participants, including support for a signature.
- [Creating surveys](https://carp.cachet.dk/creating-a-survey/) and questionnaires with a wide range of answer formats (e.g., Likert scale, date pickers, image pickers, etc.), such as the [WHO5](https://www.psykiatri-regionh.dk/who-5/Documents/WHO-5%20questionaire%20-%20English.pdf) survey.
- [Supporting localizations](https://carp.cachet.dk/localization/) of surveys and informed consent.

Research Package is part of the overall [Copenhagen Research Platform (CARP)](https://carp.cachet.dk) with also provides a Flutter package for mobile and wearable sensing called [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing).
The [Pulmonary Monitor](https://github.com/cph-cachet/pulmonary_monitor_app) app shows how mobile sensing can be combined with collection of survey data from users.

## Documentation

There is a set of tutorials, describing:

- the overall [software architecture](https://carp.cachet.dk/research-package-api/) of Research Package
- how to create an [informed consent](https://carp.cachet.dk/obtaining-consent/) flow
- how to define and run [user surveys](https://carp.cachet.dk/creating-a-survey/)
- how to enable [localization](https://carp.cachet.dk/localization/)

The [Research Package Flutter API](https://pub.dev/documentation/research_package/latest/) is available (and maintained) as part of the package release at pub.dev.

## Localization

Translations live in `assets/lang/<languageCode>.json` and are looked up with
`RPLocalizations.of(context)?.translate('key')`. A key which is not translated is returned as-is, so
it is safe to pass text which may be either a key or a literal.

**Nested keys.** Translations may be nested and are addressed with a dot-separated path. These two
files are equivalent, so nested and dot-separated files can be mixed freely and existing flat files
keep working untouched:

```json
{ "pages": { "task_list": { "title": "Tasks", "description": "Your tasks" } } }
{ "pages.task_list.title": "Tasks", "pages.task_list.description": "Your tasks" }
```

```dart
locale.translate('pages.task_list.title'); // 'Tasks'
```

**Interpolation.** `{{placeholder}}` values are filled in from `args`. A placeholder with no
matching argument is left in place, so a forgotten argument is visible rather than silently blank. A
single brace is always literal.

```json
{ "greeting": "Hello {{name}}, you have {{n}} messages" }
```

```dart
locale.translate('greeting', args: {'name': 'Bo', 'n': 3});
// 'Hello Bo, you have 3 messages'
```

**Plurals.** Give a key one variant per plural category using the `_zero`, `_one`, `_two`, `_few`,
`_many` and `_other` suffixes, and pass a `count`. The category is picked using the CLDR rules of the
locale, so a language which needs `_few` and `_many` gets them. `count` is also available to the
translation as `{{count}}` without passing it in `args`.

```json
{
  "tasks_zero": "All done",
  "tasks_one": "{{count}} task left",
  "tasks_other": "{{count}} tasks left"
}
```

```dart
locale.translate('tasks', count: 0); // 'All done'
locale.translate('tasks', count: 1); // '1 task left'
locale.translate('tasks', count: 5); // '5 tasks left'
```

Which categories apply depends on the language — English only ever uses `_one` and `_other`. The one
exception is `_zero`, which is used for a `count` of exactly 0 in any language when present. A
category which is not translated falls back to `_other`, and a key with no plural variants at all
falls back to the key itself.

## Example Application

There is an [example app](https://github.com/cph-cachet/research.package/tree/master/example) which demonstrates the different features of Research Package as implemented in a Flutter app.

## Who is backing this project?

Research Package is made by the [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/) and is an important component in the [Copenhagen Research Platform (CARP)](https://carp.cachet.dk), which is used in a number of applications and studies.
The current project maintainers are [Mads Vedel Saaby Christensen](https://github.com/MadsVSChristensen) and [Jakob E. Bardram](https://www.bardram.net).

## How can I contribute?

We are more than happy to take contributions and feedback.
Use the [Issues](https://github.com/cph-cachet/research.package/issues) page to file an issue or feature request.
Besides general help for enhancement and quality assurance (bug fixing), we welcome input on new answer types.

## License

This software is copyright (c) [Copenhagen Center for Health Technology (CACHET)](https://www.cachet.dk/)
at the [Technical University of Denmark (DTU)](https://www.dtu.dk).
This software is available 'as-is' under a [MIT license](https://github.com/cph-cachet/research.package/blob/master/LICENSE).
