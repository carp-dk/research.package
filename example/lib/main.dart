import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:research_package/research_package.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_themes_package/carp_themes_package.dart';

part 'informed_consent_page.dart';
part 'linear_survey_page.dart';
part 'navigable_survey_page.dart';
part 'research_package_objects/informed_consent.dart';
part 'research_package_objects/linear_survey.dart';
part 'research_package_objects/navigation_direct_step_navigation_rule.dart';
part 'research_package_objects/navigation_step_jump_rule.dart';
part 'research_package_objects/navigation_step_reorganizer_rule.dart';
part 'research_package_objects/other_navigable_survey_examples.dart';

void main() {
  // initialize research package
  // mostly used if you load a RP configurations from a json file
  ResearchPackage.ensureInitialized();

  runApp(const RPDemoApp());
}

class RPDemoApp extends StatelessWidget {
  const RPDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en'),
        Locale('da'),
        Locale('fr'),
        Locale('es'),
      ],
      localizationsDelegates: [
        // Research Package translations - supports translation of both the
        // RP-specific text as well as app-specific text.
        //  - translations of the RP text is part of the RP Flutter package
        //  - the translations of app text is located in the 'assets/lang/' folder
        //  - the translations of informed consent and surveys are part of the
        //    app text and also included in the the 'assets/lang/' files
        //  - note that only some text is translated -- illustrates that RP
        //    works both with and without translation.
        RPLocalizations.delegate,

        // Research Package translations - supports translation of both;
        //  - the RP-specific text
        //  - app-specific text using the [AssetLocalizationLoader]
        //  - a map-based localization loader [MapLocalizationLoader]
        // RPLocalizationsDelegate(loaders: [
        //   AssetLocalizationLoader(),
        //   MapLocalizationLoader({
        //     'en': {'app_name': 'Research Package Demo'},
        //     'da': {'app_name': 'Research Package Demonstration'},
        //     'fr': {'app_name': 'Demonstration de Research Package'},
        //   }),
        // ]),

        // Built-in localization of basic text for Cupertino widgets
        GlobalCupertinoLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode) {
            return supportedLocale;
          }
        }
        // if the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      theme: carpTheme,
      darkTheme: carpDarkTheme,
      title: 'Research Package Demo',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xff003F6E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "assets/images/carp_logo.png",
                height: 80,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: <Widget>[
                    Text(
                      locale?.translate("home.welcome") ?? "Welcome",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Container(height: 5),
                    Text(
                      locale?.translate("home.questions") ?? "Questions?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Container(height: 5),
                    const Text(
                      "support@carp.dk",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                    //Container(height: 50),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC32C39),
                        fixedSize: const Size(300, 60),
                      ),
                      child: Text(
                        locale?.translate("informed_consent") ??
                            "Informed Consent",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<dynamic>(
                            builder: (context) => InformedConsentPage()));
                      },
                    ),
                    Container(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC32C39),
                        fixedSize: const Size(300, 60),
                      ),
                      child: Text(
                        locale?.translate("linear_survey") ?? "Linear Survey",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<dynamic>(
                            builder: (context) => LinearSurveyPage()));
                      },
                    ),
                    Container(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC32C39),
                        fixedSize: const Size(300, 60),
                      ),
                      child: Text(
                        locale?.translate("branching_survey") ??
                            "Branching Survey",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<dynamic>(
                            builder: (context) => NavigableSurveyPage()));
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //     child: Padding(
      //   padding: const EdgeInsets.all(22.0),
      //   child: Image.asset(
      //     "assets/images/cachet-logo-white.png",
      //     height: 50,
      //   ),
      // )),
    );
  }
}
