// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/screen/add_account_screen.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';

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

  @override
  void initState() {
    users = AccountHandler.users;
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
          Center(
            child: Builder(builder: (context) {
              Size size = MediaQuery.of(context).size;
              return Container(
                alignment: Alignment.center,
                width: size.width / 4,
                height: size.height / 1.8,
                child: ColoredBox(
                  color: const Color.fromARGB(55, 15, 15, 15),
                  child: Column(
                    children: [
                      ...callback != null
                          ? [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(localizations.accountSelect,
                                  style: const TextStyle(fontSize: 20)),
                              Text(Uri.parse(callback!).host)
                            ]
                          : [],
                      Expanded(
                        child: ListView.builder(
                            itemCount: AccountHandler.userCount,
                            itemBuilder: (context, index) {
                              Account account = users[index];
                              if (account.emailVerified) {
                                return _AccountListTitle(account: account);
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                      ),
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
          Positioned.fill(
              top: 25,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/RPMTW_Logo.gif",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      Text(localizations.accountTitle,
                          style: const TextStyle(fontSize: 50)),
                    ],
                  ))),
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
  late CircleAvatar avatar;
  late String token;

  @override
  void initState() {
    String? avatarUrl =
        widget.account.avatarUrl(RPMTWApiClient.lastInstance.baseUrl);

    if (avatarUrl != null) {
      avatar = CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      );
    } else {
      /// 隨機生成顏色
      Color color =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      avatar = CircleAvatar(
        backgroundColor: color,
        child: Text(
          widget.account.username.characters.first,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    token = widget.account.token;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: avatar,
      title: Text(widget.account.username),
      subtitle: Text(widget.account.email),
      hoverColor: const Color.fromARGB(85, 31, 30, 30),
      trailing: PopupMenuButton(
          tooltip: "顯示更多",
          itemBuilder: (context) => [
                ...callback != null
                    ? [
                        const PopupMenuItem(
                          child: Text("使用本帳號登入"),
                          value: 1,
                        ),
                      ]
                    : <PopupMenuItem<int>>[],
                const PopupMenuItem(
                  child: Text("管理帳號"),
                  value: 2,
                ),
                const PopupMenuItem(
                  child: Text("登出帳號"),
                  value: 3,
                ),
              ],
          onSelected: (int _index) {
            switch (_index) {
              case 1:
                AccountHandler.callbackUrl(token);
                break;
              case 2:
                break;
              case 3:
                AccountHandler.remove(widget.account);
                _AccountNotification().dispatch(context);
                break;
              default:
                break;
            }
          }),
      onTap: () => AccountHandler.callbackUrl(token),
    );
  }
}
