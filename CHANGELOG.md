## 2.2.0

* Removing Research Package styles, integrating carp_themes_package instead.
* Added support for new media types in RPInstructionStep class. Media types include
  - Video 
  - Audio
  - Image
Media can be accessed by providing a url in the protocol under an RPInstructionStep by setting it as "video_step": "url".
* Changed color of BACK button in task to be same as NEXT button.


## 2.1.1

* minor visual updates

## 2.1.0

* updating RPColors theme to act as carp_styles_package temporarily

## 2.0.2

* fixing nullable variables

## 2.0.1

* fixing asset path

## 2.0.0

* Redesign of informed consent 
* Redesign of app bar
* Addition of research_package_styles
* Major flutter upgrade for example app
* Major gradle upgrade for exmaple app 

## 1.8.0

* Added support for a `HealthDataCollection` type in the `RPConsentSectionType` which allow for showing what health data is being collected as part of an informed consent flow.
* Added and example incl. translations of a `HealthDataCollection` type

## 1.7.4

* Removing option to use back button due to Issue [#141](https://github.com/cph-cachet/research.package/issues/141)

## 1.7.3

* Fix signature background colour ([#134](https://github.com/cph-cachet/research.package/issues/134))
* Fix of implicit back button ([PR #140](https://github.com/cph-cachet/research.package/pull/140))
* Fix of start & end time stamps ([#136](https://github.com/cph-cachet/research.package/issues/136))

## 1.7.2

* Upgrade of serialization
  * Upgrade to `carp_serializable` v. 2.0
  * Now using **camelCase** for JSON.
  * Support for deserialization of all `RPResult` classes and sub-classes (polymorphic serialization using the `carp_serializable` package) (issue [#83](https://github.com/cph-cachet/research.package/issues/83))
* Temporary fix of `rxdart` issue (#131).
* Small upgrade to text and email in demo app.
* Added support for Spanish (ES) in demo app.

## 1.6.0

* Add optional `footnote` option to various `RPSteps` and add it to the UI

## 1.5.1

* Fix issue [#115](https://github.com/cph-cachet/research.package/issues/115) by removing unused widgets, `simple_html_css` package

## 1.5.0

* Fix of issue [#111](https://github.com/cph-cachet/research.package/issues/111)
* Fix of linter / static analysis issues

## 1.4.3

* `DoubleQuestionFormat` and `IntegerQuestionFormat` now open a keyboard with only numbers, given that is the only accepted format.
* `TextAnswerFormat` now has the possibility of disabling all the keyboard "helpers" (e.g., auto corrector, suggestions).
* Fix of issue [#95](https://github.com/cph-cachet/research.package/issues/95).
* Fix of a case in which an `RPStep` could be null.
* Fix of `LateInitializationError` by removing late variables.

## 1.4.2

* Fix UI bugs [#100](https://github.com/cph-cachet/research.package/issues/100) and [#101](https://github.com/cph-cachet/research.package/issues/101)

## 1.4.1

* Fix of issue [#183](https://github.com/cph-cachet/research.package/issues/182)

## 1.4.0

* `steps` in `RPFormStep` are now called `questions`.
* Improvements to API documentation
* Upgrade to Dart 3 and Android APK upgrades
* Fix of issue [#86](https://github.com/cph-cachet/research.package/issues/86)

## 1.3.2

* Added translation to French and to Portuguese (Portugal version).
* Added autoFocus to `TextAnswerFormat`.
* Added autoSkip, timeout, and autoSubmit to `FormStep`.
* Added autoSkip, timeout, and autoFocus to `QuestionStep`.
* Added autoSkip and showTime to `TimerStep`.
* Adapted colors in Research Package for the Cupertino theme.
* Added a `RPDoubleAnswerFormat`.

## 1.3.1

* Upgrade to `carp_serializable: ^1.1.0`. Note that this entails that all polymorphic json serialization uses the type key `__type`. Hence, the json format for all the domain classes is **NOT** compatible with earlier versions.
* Update of Material Design names for title, caption, and body text.
* Added the `ResearchPackage.ensureInitialized()` static method to be compliant with the other CARP packages.

## 1.2.1

* Added usage of `detailText` on `RPChoice`s.
* Small bug fixes

## 1.2.0

* Upgrade of `pubspec` dependencies to latest versions.

## 1.1.0

* Support for initializing json serialization by calling the `ResearchPackage()` factory method. This allows for dynamic loading of survey or informed consents from a json configuration.

## 1.0.0

* First stable release
* `RPActivityStep` made serializable.
* Upgraded to Dart 2.18 and Fluter 3
* Refactoring to comply to [official Dart recommended lint rules](https://pub.dev/packages/flutter_lints)
* Upgrade of several constructors to use `super` which break backwards compatibility to version 0.9.3
* Update of demo app
* Update and clean up in API documentation.

## 0.9.3

* Changed dependency from carp_core to carp_serializable, to reduce unnecessary dependencies.

## 0.9.2

* Added a `unfocus` between question to avoid the keyboard remaining on the screen after answering a question.

## 0.9.1

* Fixed a big in the signature during consent review.

## 0.9.0

* Research Package now translates the `TaskResult` and steps from the localization keys to the localized values.
* Small updates to the example app
* Small fixes to localization in the package and the example app.

## 0.8.0

* Updated deprecated theme usages.
* Added the `RPTimerStep` and serialization.
* Added `Audiofileplayer` plugin for the `RPTimerStep`
* Updated README
* Updated .gitignore

## 0.7.3

* Update to `carp_core` v. 0.33.0
* Misc. cleanup in Android example app configurations

## 0.7.2+3

* Updated `signature` to 5.0.0

## 0.7.2+2

* Changed asset urls to be specific urls of the assets
* Added a new "Checkmark" in the RPCompletionStep

## 0.7.2+1

* Changed brightness input on CupertinoDateTimePicker for `RPDateTimeAnswerFormat` to use Theme brightness instead of System brightness.

## 0.7.2

* added base method for calculateScore() method into RPActivityStep class. Which is overridden by any child class that extends RPActivityStep

## 0.7.1

* fix / enhancement of localization based on [issue #54](https://github.com/cph-cachet/research.package/issues/54).

## 0.7.0

* Removed Boolean questions, including answer format for simplicity and navigation changes. (Use regular RPChoices now)
* Removed Predicate Navigation rules, for simplicity and navigation changes. (Use `RPStepJumpRule` now)
* JSON serialization to/from json, now retains the navigation rules added. Previously the navigation was lost after conversion.
* Updated example app
* Fixed issues #58, #59, #60, #61
* Small bugfixes

## 0.6.7

* Added Activity Steps as `RPActivityStep` - A class that allows for the making of Cognitive Tests
* Added Activity Result as `RPActivityResult` - A class for storing the result of a Cognitive test
* Added `RPActivityEventLogger` - used for logging small events during each `activity step`
* Include json serialization for added classes.

## 0.6.6

* update to `carp_core` v. 0.31.0

## 0.6.5+1

* update to UI rendering in the Informed Consent based on PR [#51](https://github.com/cph-cachet/research.package/pull/51).
* update to UI rendering in the Informed Consent based on PR [#50](https://github.com/cph-cachet/research.package/pull/50).
* updating README to link to the new [tutorials on `carp.cachet.dk`](https://carp.cachet.dk/category/tutorials/).

## 0.6.4

* `RPLocalizationsDelegate` now support multiple `loaders` which can merge translations from several sources.

## 0.6.3

* Changed background color element from backgroundColor -> scaffoldBackgroundColor.
* Updated RPConsentSection to also take a custom title on predefined section types.
* Fixed an issue with the cupertinoDatePicker in dark mode, that caused the picker to not follow the theme values.
* Added headline6 to questions step titles.

## 0.6.2

* Additional customizable text in the theme
* Example app updated
* Textfield hintText uses the 'text' parameter.

## 0.6.1

* Bug fix (Missing signature)

## 0.6.0

* Null safety added.
* Theming updated using PR #24
* Minor fixes

## 0.5.5

* small update to robustness and debug info in `RPLocalizations`

## 0.5.4

* update to the localization model (`RPLocalizations`) so that:
  * the localization of the embedded text in RP is now part of RP (you don't need to worry about this anymore)
  * localization of informed consent and survey is (still) in the `assets/lang/` folder
  * support for custom [LocalizationLoader]s which can load translations from other sources
* another localization class has been added `AssetsLocalizations`, which can load translations from json files. This is useful for e.g. simple localization of static text in an app
* example app update to illustrate the use of both types of localization

## 0.5.3+1

* small updates to documentation
* making `RPTask` serializable instead of abstract
* fix to `translate` method

## 0.5.2

* update of json serialization in informed consent domain model
* updated example and unit test on `RPConsentSection` for passive data collection

## 0.5.0

* Included the [carp_core](https://pub.dev/packages/carp_core) which allow for de/serialization of RP models to/from json, while also supporting polymorphism (e.g., that an `RPAnswerFormat` can have different implementations). See [issue #12](https://github.com/cph-cachet/research.package/issues/12).
* all `.withParams()` and similar constructors have been replaced with named constructors (as recommended in Dart).
* added unit test to verify json de/serialization.
* all examples and the demo app updated accordingly.

## 0.4.1

* Fixed error in consent that caused it to have 2 top bars
* Updated docs
* Score fixes

## 0.4.0

* Merged beta.1.0
* Added RPTextAnswerFormat (a format for getting written answers from the user)
* Minor bugfixes

## 0.4.0-beta.1.0

* Updated UI for several elements:
  * RPQuestionStep (incl. most answer formats)
  * RPFormStep
  * RPInstructionStep
  * RPVisualConsentStep
* Added new consent types:
  * User data collection
  * Passive data collection
* Added simple support for theming in Research Package
* Minor bug fixes

## 0.3.2+3

* updates to documentation of RP and example app

## 0.3.2+2

* Added RPJumpStepRule - A navigation rule to jump to questions based on the chosen answer to the question.

## 0.3.2+1

* Revert of AnimationController

## 0.3.2

* Updated `AnimationController`s to Flutter 1.22
* Removed "Activity Steps" to be released in a separate package
* Merged small-scale branching feature
* Minor bugfixes

## 0.3.1+1

* `onCancel` callback changed to only optional

## 0.3.1

* `onCancel` callback added to Tasks

## 0.3.0

* `RPActivityStep` and `RPActivityResult` added with including UI.
* 8 cognitive tests added as activity steps.
* Dependencies updated
* Minor bugfixes

## 0.2.1

* FormStep now supports Slider, Image, Date and Boolean Answer Formats as well

## 0.2.0

* Support for Navigable Tasks
  * Branching support with `RPDirectStepNavigationRule` and `RPPredicateStepNavigationRule`
  * Navigation to previous questions
  * Currently supports:
    * Boolean Answer Format
    * Choice Answer Format
* Localization added
  * Demo app available now in English and Danish
* Support for new Answer Format
  * Boolean
* UI updates, bug fixes

## 0.1.2

* Support for new Answer Formats
  * Slider
  * Date and Time
  * Image Choice
* `rx_dart` dependency updated to `^0.23.0`
* Small bug fixes and documentation update

## 0.1.1

* `json_annotation` dependency updated to `^3.0.0`
* `rx_dart` dependency updated to `^0.22.0`

## 0.1.0

* Form Step feature added
* Bug fixing

## 0.0.4

* Example application added

## 0.0.3

* Initial release for Pub
* Support for three Answer Formats
  * Single Choice
  * Multiple Choice
  * Integer

## 0.0.2

* Added initial support for serialization to/from JSON
* JSON serialization is available for these classes:
  * `RPAnswerFormat`
  * `RPChoiceAnswerFormat`
  * `RPIntegerAnswerFormat`
  * `RPConsentDocument`
  * `RPConsentSection`
  * `RPSignatureResult`
  * `RPStepResult`
  * `RPTaskResult`
  * `RPChoice`

## 0.0.1

* Initial release
* Entire framework done
* Support for SingleChoice question type
