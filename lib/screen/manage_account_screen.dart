import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rpmtw_account_ui/models/account.dart';
import 'package:rpmtw_account_ui/utilities/account_handler.dart';
import 'package:rpmtw_account_ui/utilities/data.dart';
import 'package:rpmtw_account_ui/widget/ok_close.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';

class ManageAccountScreen extends StatefulWidget {
  static const String route = '/manage-account';
  final Account account;
  const ManageAccountScreen({Key? key, required this.account})
      : super(key: key);

  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late Account account;

  @override
  void initState() {
    account = widget.account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${localizations.accountActionManage} - ${account.email}"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _Avatar(
            widget: widget,
            account: account,
          )
        ],
      ),
    );
  }
}

class _Avatar extends StatefulWidget {
  const _Avatar({Key? key, required this.widget, required this.account})
      : super(key: key);

  final ManageAccountScreen widget;
  final Account account;

  @override
  State<_Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<_Avatar> {
  bool hover = false;
  late CircleAvatar avatar;
  late Account account;

  @override
  void initState() {
    account = widget.account;
    avatar = account.avatar(fontSize: 60);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 150, height: 150, child: avatar),
        IconButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );

            if (result != null) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      _UpdatingAvatar(result: result, account: account));
            }
          },
          icon: const Icon(Icons.photo_camera),
          tooltip: localizations.changeAvatar,
        )
      ],
    );
  }
}

class _UpdatingAvatar extends StatelessWidget {
  final FilePickerResult result;
  final Account account;
  const _UpdatingAvatar({Key? key, required this.result, required this.account})
      : super(key: key);

  Future<Account> updating(BuildContext context) async {
    PlatformFile file = result.files.single;
    RPMTWApiClient apiClient = RPMTWApiClient.lastInstance;
    Storage storage =
        await apiClient.storageResource.createStorageByBytes(file.bytes!);

    User newUser = await apiClient.authResource.updateUser(
        uuid: "me", newAvatarStorageUUID: storage.uuid, token: account.token);

    return AccountHandler.addByUser(newUser, account.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: updating(context),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            title: Text(localizations.changeAvatarUpdateSuccess),
            actions: [
              OkClose(
                onOk: () {
                  navigation.pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          ManageAccountScreen(account: snapshot.data!)));
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(localizations.changeAvatarUpdating),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
