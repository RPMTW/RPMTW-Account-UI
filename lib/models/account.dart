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
      required this.token})
      : super(
          uuid: uuid,
          username: username,
          email: email,
          emailVerified: emailVerified,
          avatarStorageUUID: avatarStorageUUID,
        );

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        uuid: map['uuid'],
        username: map['username'],
        email: map['email'],
        emailVerified: map['emailVerified'],
        avatarStorageUUID: map['avatarStorageUUID'],
        token: map['token']);
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
      'uuid': uuid,
      'username': username,
      'email': email,
      'emailVerified': emailVerified,
      'avatarStorageUUID': avatarStorageUUID,
      'token': token
    };
  }
}
