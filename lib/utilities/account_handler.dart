import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

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

  static Account add(Account user) {
    try {
      /// 如果未拋出錯誤代表有找到 UUID 相同的使用者帳號，就將該使用者帳號刪除替換為新的
      Account duplicateUser =
          users.firstWhere((_user) => _user.uuid == user.uuid);
      users.remove(duplicateUser);
      // ignore: empty_catches
    } catch (e) {}

    users.add(user);
    save();
    return user;
  }

  static Account addByUser(User user, String token) {
    Account account = Account(
        uuid: user.email,
        username: user.username,
        email: user.email,
        emailVerified: user.emailVerified,
        avatarStorageUUID: user.avatarStorageUUID,
        status: user.statusCode,
        message: user.statusMessage,
        token: token);
    return add(account);
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

  static void callbackUrl(String token) {
    if (callback != null) {
      String url = callback!;
      url = url.replaceAll(r"${token}", token);
      html.window.location.href = url;
    }
  }
}
