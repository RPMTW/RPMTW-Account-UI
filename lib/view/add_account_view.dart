import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({Key? key}) : super(key: key);

  @override
  _AddAccountViewState createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  Future<String?> _authUser(LoginData data) async {}

  Future<String?> _signupUser(SignupData data) async {}

  Future<String?> _recoverPassword(String name) async {}

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        title: localizations.accountLoginTitle,
        logo: const AssetImage(
          "assets/images/RPMTW_Logo.gif",
        ),
        messages: LoginMessages(
          passwordHint: localizations.accountPassword,
          userHint: localizations.accountEmail,
          signupButton: localizations.accountSignup,
          loginButton: localizations.accountLogin,
          providersTitleFirst: localizations.accountProviders,
        ),
        userValidator: (String? email) {
          RegExp regExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
          if (email!.isEmpty || !regExp.hasMatch(email)) {
            return localizations.accountInvalidEmail;
          }
        },
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //   builder: (context) => DashboardScreen(),
          // ));
        },
        onRecoverPassword: _recoverPassword,
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: () async {},
          ),
          LoginProvider(
            icon: FontAwesomeIcons.facebook,
            label: 'Facebook',
            callback: () async {},
          ),
          LoginProvider(
            icon: FontAwesomeIcons.github,
            label: 'Github',
            callback: () async {},
          ),
        ]);
  }
}
