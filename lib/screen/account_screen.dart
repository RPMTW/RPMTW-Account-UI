import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/models/callback_info.dart';
import 'package:rpmtw_account_ui/screen/add_account_screen.dart';
import 'package:rpmtw_account_ui/screen/manage_account_screen.dart';

import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_api_client_flutter/rpmtw_api_client_flutter.dart';

class _AccountNotification extends Notification {
  List<Account> users;

  _AccountNotification() : users = AccountHandler.users;
}

class AccountScreen extends StatefulWidget {
  static const String route = '/account';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late List<Account> users;
  late CallbackInfo? info;

  @override
  void initState() {
    users = AccountHandler.users;
    info = CallbackInfo.instance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<_AccountNotification>(
      onNotification: (notification) {
        List<Account> _users = notification.users;
        if (_users.isEmpty) {
          navigation.pushNamed(AddAccountScreen.route);
        }
        setState(() {
          users = _users;
        });
        return true;
      },
      child: Scaffold(
          body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              Image.asset(
                "assets/images/RPMTW_Logo.gif",
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(localizations.accountTitle,
                  style: const TextStyle(fontSize: 50)),
              Center(
                child: Builder(builder: (context) {
                  Size size = MediaQuery.of(context).size;
                  return Container(
                    alignment: Alignment.center,
                    width: size.width / (size.width > 500 ? 4 : 1.5),
                    height: size.height / 1.8,
                    child: ColoredBox(
                      color: const Color.fromARGB(55, 15, 15, 15),
                      child: ListView(
                        children: [
                          ...info != null
                              ? [
                                  const SizedBox(height: 10),
                                  Text(localizations.accountSelect,
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center),
                                  Text(info!.serviceName,
                                      textAlign: TextAlign.center)
                                ]
                              : [],
                          Column(
                            children: users.map((account) {
                              if (account.emailVerified) {
                                return _AccountListTitle(account: account);
                              } else {
                                return const SizedBox.shrink();
                              }
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: Text(localizations.accountLoginOther),
                            hoverColor: const Color.fromARGB(85, 31, 30, 30),
                            onTap: () {
                              navigation.pushNamed(AddAccountScreen.route);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Positioned.fill(
              bottom: 5,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(localizations.guiCopyright))),
        ],
      )),
    );
  }
}

class _AccountListTitle extends StatefulWidget {
  final Account account;
  const _AccountListTitle({Key? key, required this.account}) : super(key: key);

  @override
  __AccountListTitleState createState() => __AccountListTitleState();
}

class __AccountListTitleState extends State<_AccountListTitle> {
  late String token;
  late CallbackInfo? info;

  @override
  void initState() {
    token = widget.account.token;
    info = CallbackInfo.instance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.account.avatar(),
      title: Text(widget.account.username),
      subtitle: Text(widget.account.email),
      hoverColor: const Color.fromARGB(85, 31, 30, 30),
      trailing: PopupMenuButton(
          tooltip: "顯示更多",
          itemBuilder: (context) => [
                ...info != null
                    ? [
                        PopupMenuItem(
                          child: Text(localizations.accountActionLogin),
                          value: 1,
                        ),
                      ]
                    : <PopupMenuItem<int>>[],
                PopupMenuItem(
                  child: Text(localizations.accountActionManage),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text(localizations.accountActionLogout),
                  value: 3,
                ),
              ],
          onSelected: (int _index) {
            switch (_index) {
              case 1:
                AccountHandler.callbackUrl(info, token);
                break;
              case 2:
                navigation.push(MaterialPageRoute(
                    builder: (context) =>
                        ManageAccountScreen(account: widget.account)));
                break;
              case 3:
                AccountHandler.remove(widget.account);
                _AccountNotification().dispatch(context);
                break;
              default:
                break;
            }
          }),
      onTap: () => AccountHandler.callbackUrl(info, token),
    );
  }
}
