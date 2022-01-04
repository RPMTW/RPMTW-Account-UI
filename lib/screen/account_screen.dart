import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';

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
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/RPMTW_Logo.gif",
                width: 45,
                height: 45,
              ),
              const SizedBox(width: 10),
              Text(localizations.accountTitle),
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: AccountHandler.userCount,
            itemBuilder: (context, index) {
              Account account = users[index];
              return ListTile(
                title: Text(
                  account.username,
                  textAlign: TextAlign.center,
                ),
                onTap: () {},
              );
            }));
  }
}
