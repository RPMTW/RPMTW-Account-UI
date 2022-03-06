import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

NavigatorState get navigation => NavigationService.navigationKey.currentState!;
AppLocalizations get localizations => AppLocalizations.of(navigation.context)!;

/// 登入帳號後將轉至此頁面
Uri? callback;
