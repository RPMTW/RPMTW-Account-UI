import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/screen/account_screen.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

class AddAccountScreen extends StatefulWidget {
  static const String route = '/add-account';
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late RPMTWApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = RPMTWApiClient(development: true);
  }

  Future<String?> _loginUser(LoginData data) async {
    String email = data.name;
    String password = data.password;
    User user;
    try {
      user = await _apiClient.authResource.getUserByEmail(email);
    } catch (e) {
      return localizations.accountNotFound;
    }

    String token;
    try {
      token = await _apiClient.authResource
          .getToken(uuid: user.uuid, password: password);
    } catch (e) {
      return localizations.accountPasswordError;
    }
    AccountHandler.add(Account(
        uuid: user.email,
        username: user.username,
        email: user.email,
        emailVerified: user.emailVerified,
        avatarStorageUUID: user.avatarStorageUUID,
        status: user.status,
        message: user.message,
        token: token));
  }

  Future<String?> _signupUser(SignupData data) async {
    String username = data.additionalSignupData!['username']!;
    String email = data.name!;
    String password = data.password!;
    CreateUserResult createUserResult;
    try {
      createUserResult = await _apiClient.authResource
          .createUser(username: username, email: email, password: password);
    } catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains("the email has already been used")) {
        return localizations.accountAlreadyUsedEmail;
      } else {
        return localizations.accountCreateError + "\n$errorMsg";
      }
    }

    User user = createUserResult.user;
    String token = createUserResult.token;

    AccountHandler.add(Account(
        uuid: user.email,
        username: user.username,
        email: user.email,
        emailVerified: user.emailVerified,
        avatarStorageUUID: user.avatarStorageUUID,
        status: user.status,
        message: user.message,
        token: token));
  }

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
          flushbarTitleError: localizations.guiError,
          additionalSignUpFormDescription:
              localizations.accountAdditionalSignup,
          additionalSignUpSubmitButton: localizations.guiSubmit,
          confirmPasswordHint: localizations.accountConfirmPassword,
          confirmPasswordError: localizations.accountConfirmPasswordError,
          confirmSignupIntro: localizations.accountAuthCodeIntro,
          confirmationCodeHint: localizations.accountAuthCodeTitle,
          confirmationCodeValidationError: localizations.accountAuthCodeError,
          flushbarTitleSuccess: localizations.guiSuccess,
          resendCodeButton: localizations.accountResendCode,
          signUpSuccess: localizations.accountAuthCodeSent,
          goBackButton: localizations.guiBack,
          confirmSignupSuccess: localizations.accountCreateSuccess,
          resendCodeSuccess: localizations.accountAuthCodeSent,
          confirmSignupButton: localizations.guiConfirm,
        ),
        userValidator: (String? email) {
          RegExp regExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
          if (email!.isEmpty || !regExp.hasMatch(email)) {
            return localizations.accountInvalidEmail;
          }
        },
        passwordValidator: (String? password) {
          if (password!.length < 6) {
            //密碼至少需要6個字元
            return localizations.accountPasswordTooShort;
          } else if (password.length > 30) {
            // 密碼最多30個字元
            return localizations.accountPasswordTooLong;
          } else if (!password.contains(RegExp(r'[A-Za-z]'))) {
            // 密碼必須至少包含一個英文字母
            return localizations.accountPasswordNeedsEnglish;
          } else if (!password.contains(RegExp(r'[0-9]'))) {
            // 密碼必須至少包含一個數字
            return localizations.accountPasswordNeedsNumber;
          }
        },
        onLogin: _loginUser,
        onSignup: _signupUser,
        onConfirmSignup: (code, loginData) async {
          int authCode = int.parse(code);
          bool isValid = await _apiClient.authResource
              .validAuthCode(email: loginData.name, code: authCode);

          if (!isValid) {
            return localizations.accountAuthCodeError;
          } else {
            Account? account = Account.findByEmail(loginData.name);
            if (account != null) {
              AccountHandler.add(Account(
                uuid: account.uuid,
                username: account.username,
                email: account.email,
                emailVerified: true,
                avatarStorageUUID: account.avatarStorageUUID,
                status: account.status,
                message: account.message,
                token: account.token,
              ));
            }
          }
        },
        onResendCode: (singUPData) async {
          // RPMTW 暫時不支援重新寄送驗證碼
          return localizations.guiWIP;
        },
        footer: localizations.guiCopyright,
        hideForgotPasswordButton: true, //目前尚未支援忘記密碼功能
        additionalSignupFields: [
          UserFormField(
              keyName: "username",
              displayName: localizations.accountUsername,
              icon: const Icon(Icons.badge),
              fieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.accountUsernameError;
                }
              }),
        ],
        onSubmitAnimationCompleted: () {
          if (AccountHandler.userCount == 1 && callback != null) {
            //僅有一個帳號
            String token = AccountHandler.users[0].token;
            AccountHandler.callbackUrl(token);
          } else {
            navigation.pushNamed(AccountScreen.route);
          }
        },
        onRecoverPassword: _recoverPassword,
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            label: 'Google',
            callback: () async {
              return localizations.guiWIP;
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.facebook,
            label: 'Facebook',
            callback: () async {
              return localizations.guiWIP;
            },
          ),
          LoginProvider(
            icon: FontAwesomeIcons.github,
            label: 'Github',
            callback: () async {
              return localizations.guiWIP;
            },
          ),
        ]);
  }
}
