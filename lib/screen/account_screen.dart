import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

class AccountScreen extends StatefulWidget {
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
    return Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset(
        //         "assets/images/RPMTW_Logo.gif",
        //         width: 45,
        //         height: 45,
        //       ),
        //       const SizedBox(width: 10),
        //       Text(localizations.accountTitle),
        //     ],
        //   ),
        // ),
        body: Stack(
      children: [
        Center(
          child: Builder(builder: (context) {
            Size size = MediaQuery.of(context).size;
            return Container(
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              alignment: Alignment.center,
              width: size.width / 4,
              height: size.height / 1.8,
              child: ColoredBox(
                color: const Color.fromARGB(55, 15, 15, 15),
                child: ListView.builder(
                    itemCount: AccountHandler.userCount,
                    itemBuilder: (context, index) {
                      Account account = users[index];

                      CircleAvatar avatar;

                      String? avatarUrl = account
                          .avatarUrl(RPMTWApiClient.lastInstance.baseUrl);

                      if (avatarUrl != null) {
                        avatar = CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                        );
                      } else {
                        /// 隨機生成顏色
                        Color color =
                            Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(1.0);
                        avatar = CircleAvatar(
                          backgroundColor: color,
                          child: Text(
                            account.username.characters.first,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListTile(
                        leading: avatar,
                        title: Text(account.username),
                        subtitle: Text(account.email),
                        hoverColor: const Color.fromARGB(85, 31, 30, 30),
                        trailing: PopupMenuButton(
                            tooltip: "顯示更多",
                            itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    child: Text("使用本帳號登入"),
                                    value: 1,
                                  ),
                                  const PopupMenuItem(
                                    child: Text("管理帳號"),
                                    value: 2,
                                  ),
                                  const PopupMenuItem(
                                    child: Text("移除帳號"),
                                    value: 3,
                                  ),
                                ],
                            onSelected: (int _index) {
                              switch (_index) {
                                case 1:
                                  break;
                                case 2:
                                  break;
                                case 3:
                                  break;
                                default:
                                  break;
                              }
                            }),
                        onTap: () {
                          // TODO:Implement
                        },
                      );
                    }),
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
    ));
  }
}
