import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/screen/account_screen.dart';
import 'package:rpmtw_account_ui/screen/add_account_screen.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

void main() async {
  AccountHandler.init();
  RPMTWApiClient(); // Initialize RPMTWApiClient
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
        supportedLocales: const [
          Locale('en', 'us'), // English
          Locale.fromSubtags(
              languageCode: 'zh', scriptCode: 'Hant'), // Chinese (Traditional)
          Locale.fromSubtags(
              languageCode: 'zh', scriptCode: 'Hans') // Chinese (Simplified)
        ],
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            fontFamily: "font"),
        initialRoute: HomePage.route,
        onGenerateRoute: (settings) {
          if (settings.name == HomePage.route ||
              settings.name == '/index.html') {
            return MaterialPageRoute(
                settings: settings, builder: (context) => const HomePage());
          } else if (settings.name == AddAccountScreen.route) {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) => const AddAccountScreen());
          } else {
            return MaterialPageRoute(
                settings: settings,
                builder: (context) => const AccountScreen());
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
