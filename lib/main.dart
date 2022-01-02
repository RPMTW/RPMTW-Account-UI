import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_account_ui/view/add_account_view.dart';

void main() {
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
        AppLocalizations.delegate
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const AddAccountView();
  }
}
