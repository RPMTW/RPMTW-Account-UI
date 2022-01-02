import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({Key? key}) : super(key: key);

  @override
  _AddAccountViewState createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  Map users = {
    'dribbble@gmail.com': '12345',
    'hunter@gmail.com': 'hunter',
  };
  Duration get loginTime => Duration(milliseconds: 2250);
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

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
      ),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => DashboardScreen(),
        // ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
