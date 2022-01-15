// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/screen/account_screen.dart';
import 'package:rpmtw_account_ui/screen/add_account_screen.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'dart:ui' as ui;

/// https://github.com/flutter/flutter/issues/81215
TextStyle fontStyle = const TextStyle(
    fontFeatures: [ui.FontFeature.proportionalFigures()], fontFamily: "font");

void main() async {
  Uri _uri = Uri.parse(window.location.href);
  String? _callback = _uri.queryParameters['rpmtw_auth_callback'];
  if (_callback != null && _callback.contains(r"${token}")) {
    callback = _callback;
  }

  AccountHandler.init();
  RPMTWApiClient.init(); // Initialize RPMTWApiClient
  runApp(const AccountApp());
}

class AccountApp extends StatelessWidget {
  const AccountApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RPMTW Account',
        navigatorKey: NavigationService.navigationKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          fontFamily: "font",
          textTheme: TextTheme(
            bodyText2: fontStyle,
            bodyText1: fontStyle,
            headline6: fontStyle,
            headline5: fontStyle,
            headline4: fontStyle,
            headline3: fontStyle,
            headline2: fontStyle,
            headline1: fontStyle,
            caption: fontStyle,
            button: fontStyle,
            subtitle2: fontStyle,
            subtitle1: fontStyle,
            overline: fontStyle,
          ),
        ),
        initialRoute: HomePage.route,
        onGenerateRoute: (settings) {
          String name = settings.name ?? "/";

          if (name == HomePage.route || name == '/index.html') {
            return MaterialPageRoute(
                settings: settings, builder: (context) => const HomePage());
          } else if (name == AddAccountScreen.route) {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) => const AddAccountScreen());
          } else if (name == AccountScreen.route) {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) => const AccountScreen());
          } else {
            return MaterialPageRoute(
                settings: settings, builder: (context) => const HomePage());
          }
        });
  }
}

class HomePage extends StatefulWidget {
  static const route = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (AccountHandler.hasAccount) {
      return const AccountScreen();
    } else {
      return const AddAccountScreen();
    }
  }
}
