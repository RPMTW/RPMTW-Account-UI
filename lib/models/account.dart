import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

class Account extends User {
  final String token;
  Account(
      {required String uuid,
      required String username,
      required String email,
      required bool emailVerified,
      required String? avatarStorageUUID,
      required int status,
      required String message,
      required this.token})
      : super(
            uuid: uuid,
            username: username,
            email: email,
            emailVerified: emailVerified,
            avatarStorageUUID: avatarStorageUUID,
            status: status,
            message: message);

  CircleAvatar avatar({double fontSize = 18}) {
    CircleAvatar _avatar;
    String? _avatarUrl = avatarUrl(RPMTWApiClient.lastInstance.baseUrl);

    if (_avatarUrl != null) {
      _avatar = CircleAvatar(
        backgroundImage: NetworkImage(_avatarUrl),
      );
    } else {
      /// 隨機生成顏色
      Color color =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      _avatar = CircleAvatar(
        backgroundColor: color,
        child: Text(
          username.characters.first,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      );
    }
    return _avatar;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    Map data = map['data'];
    return Account(
        uuid: data['uuid'],
        username: data['username'],
        email: data['email'],
        emailVerified: data['emailVerified'],
        avatarStorageUUID: data['avatarStorageUUID'],
        status: map['status'],
        message: map['message'],
        token: data['token']);
  }

  static Account? findByEmail(String email) {
    try {
      return AccountHandler.users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "message": message,
      "data": {
        'uuid': uuid,
        'username': username,
        'email': email,
        'emailVerified': emailVerified,
        'avatarStorageUUID': avatarStorageUUID,
        'token': token
      }
    };
  }
}
