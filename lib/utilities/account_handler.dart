import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:rpmtw_account_ui/models/account.dart';

class AccountHandler {
  static late html.Storage storage;
  static late List<Account> users;

  static void init() {
    storage = html.window.localStorage;
    if (storage.containsKey('rpmtw_account')) {
      String account = storage['rpmtw_account']!;
      List accountList = json.decode(account);
      List<Map<String, dynamic>> accountJson =
          (accountList).cast<Map<String, dynamic>>();
      users = accountJson.map((user) => Account.fromMap(user)).toList();
    } else {
      users = [];
    }
  }

  static bool get hasAccount => users.isNotEmpty;

  static int get userCount => users.length;

  static void add(Account user) {
    users.add(user);
    save();
  }

  static void remove(Account user) {
    users.remove(user);
    save();
  }

  static void save() {
    List<Map<String, dynamic>> accountJson =
        users.map((user) => user.toMap()).toList();
    storage['rpmtw_account'] = json.encode(accountJson);
  }
}
