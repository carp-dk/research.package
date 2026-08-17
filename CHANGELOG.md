## 3.0.0

* Localization now supports nested translation keys. A nested json object is
  flattened into a dot-separated path, so `{"pages": {"task_list": {"title": ...}}}`
  and `{"pages.task_list.title": ...}` are equivalent and existing flat
  translation files keep working unchanged.
* Localization now supports `{{placeholder}}` interpolation via the new `args`
  argument of `translate()`, e.g.
  `translate('greeting', args: {'name': 'Bo'})`. A placeholder with no matching
  argument is left in place rather than rendered blank. A single brace stays
  literal.
* Localization now supports plurals via the new `count` argument of
  `translate()`, using the `_zero`, `_one`, `_two`, `_few`, `_many` and `_other`
  key suffixes. The category is selected with the CLDR rules of the locale, and
  `count` is available to the translation as `{{count}}`. `_zero` is used for a
  count of exactly 0 in any language when present; a missing category falls back
  to `_other`, and a key with no plural variants falls back to the key itself.
* `translate()` remains backwards compatible — `translate('key')` behaves exactly
  as before, including returning the key when it is not translated.
* `LocalizationLoader.load` now returns `Future<Map<String, dynamic>>` so a
  loader may return nested translations. Existing loaders returning
  `Future<Map<String, String>>` are still valid overrides and need no change.
  `MapLocalizationLoader` accordingly takes `Map<String, Map<String, dynamic>>`.
* New dependency: `intl: '>=0.19.0 <0.21.0'`, for the CLDR plural rules.
* Added support for requesting OS permissions in context during informed consent
  (issue #171). A consent section now declares the permissions its text explains
  the need for via `RPConsentSection.permissions`, and tapping "NEXT" on that
  section triggers the native permission dialog — but only when the step opts in
  with `RPVisualConsentStep.askPermission: true`. Without that flag nothing is
  requested and the flow behaves exactly as before.
* Added `RPPermissionType` (location, locationAlways, microphone, camera,
  notification, activityRecognition, sensors, bluetooth, health) and
  `RPPermissionStatus`.
* Added `RPPermissionResult`, added to the task result under the identifier of
  the `RPVisualConsentStep`, holding the status of every permission which was
  asked for. A denied permission is recorded but never blocks the participant.
* Added `RPPermissions.request()` for asking for a single permission outside a
  consent flow.
* `RPPermissionType.health` is now requested by Research Package itself, through
  the `health` package. Health data is not one permission — HealthKit and Health
  Connect authorise each of the 100+ data types separately — so a section which
  lists it must also list the types it needs in the new
  `RPConsentSection.healthDataTypes`; without them there is nothing to ask for
  and it resolves to `RPPermissionStatus.unsupported`. `HealthDataType` is
  re-exported, and `RPPermissions.requestHealthData()` is public for asking
  outside a consent flow. Note that on iOS the resulting status is optimistic:
  HealthKit does not disclose whether read access was granted, so `granted`
  means the authorisation sheet was shown without error.
* New dependency: `health: '>=13.0.0 <14.0.0'`. **This raises the Android
  requirement to `minSdkVersion 26` for every app using research_package**, and
  apps which ask for health data must extend `FlutterFragmentActivity` and
  declare the Health Connect entries in their manifest — see the "Health data"
  part of the README's platform setup.
* New dependency: `permission_handler: '>=12.0.0 <13.0.0'`. Apps which use
  `askPermission` must declare the permissions they ask for natively — see the
  "OS permissions" section of the README. Apps which do not use it need no setup.
* Added a "BACK" button to `RPUIVisualConsentStep`, for re-reading earlier
  sections — the step used to be forward only. It is hidden on the first section,
  and on a section which is still going to open a permission alert. Once that
  section's permissions have been asked for, "BACK" reappears on it.
* **Breaking:** an informed consent flow — an `RPOrderedTask` containing an
  `RPConsentReviewStep` — no longer shows the close button in the top bar, and
  the visual consent step no longer shows a "CANCEL" button. Apple requires that
  a screen explaining an upcoming permission request offers no way out other than
  the system alert it leads to, and the permission sections sit inside this flow.
  Such a task is now left by pressing "DISAGREE" on the review step. This also
  removes an inconsistency: the old "CANCEL" button popped the route directly
  without calling `RPUITask.onCancel`, which "DISAGREE" does call. Tasks which
  are not consent tasks keep their close button.
* **Breaking:** `RPUIVisualConsentStep` now takes the `RPVisualConsentStep` as
  `step:` instead of taking `consentDocument:`. This only affects code which
  instantiates the widget directly, which is not normally needed — the step
  builds it.
* `RPUIVisualConsentStepState` now keeps its `PageController` in the state and
  disposes it, instead of creating a new one on every build.
* Added `RPUITask.carouselBarBuilder` for replacing the default carousel bar
  (logo, "x of y" progress and close button) with a custom widget. Return
  `const SizedBox.shrink()` to hide the bar entirely. When the builder is
  given, `carouselBarImage`, `carouselBarHorizontalPadding`,
  `carouselBarVerticalPadding` and `carouselBarBackgroundColor` are ignored.
  Note that a replacement bar should offer its own way to cancel the task.
* Added `RPUITask.nextButtonText` to override the label of the Next button.
  When `null` the localized `'NEXT'` key is used as before. Applies to the whole
  task, not to individual steps.
* Added `RPStep.nextButtonText` so an individual step can label its own forward
  action (e.g. "Start Practicing"). It takes precedence over
  `RPUITask.nextButtonText`, which in turn falls back to the `'NEXT'` key.

## 2.5.0

* upgrade to `carp_serializable` ^3.0.0

## 2.4.1

* Migrated to `carp_themes_package` 0.2.0: widgets now read colors and text
  styles from the standard `ThemeData` (`ColorScheme`, `TextTheme`,
  `scaffoldBackgroundColor`) instead of the removed `CarpColors` extension and
  `fsXX` text constants.
* Lowered the minimum Dart SDK to `3.12.0`.

## 2.4.0

Update dependencies:
 - `sdk: ^3.12.2`
 - `carp_themes_package: ^0.0.5`
 - `carp_serializable: ^2.0.1`
 - `signature: ^6.3.0`
 - `json_annotation: ^4.12.0`
 - `audioplayers: ^6.7.0`
 - `video_player: ^2.11.1`

* Updated example apps
* Improve typechecking for bottom bar visibility

## 2.3.0

* Adding custom padding to carouselBar

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
