import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:icetea_studio_core/ui/i18n/messages_all.dart';

//https://github.com/konifar/droidkaigi2018-flutter/tree/master/lib/i18n

/// Defines the Localization keys and values for the entire application
///
/// Naming Convention: [context]_[contentTypeAbbr]_[name] where,
/// context: class | section | form | etc...
/// contentTypeAbbr: lbl (Labels) | btn (Buttons) | plh (Placeholders)| ttp (Tooltips) | mes (Message) | etc...
/// name: photos | industries | etc...
/// Ex: userProfile_lbl_photos
class Strings {
  static Future<Strings> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new Strings();
    });
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static final Strings instance = new Strings();

  // App Specific
  String get appName => Intl.message("Click Social", name: "appName");

  // Search
  String get search_prt_defaultHint => Intl.message("Enter something to search", name: "search_prt_defaultHint");

  // Common Text
  String get common_txt_at => Intl.message("at", name: "common_txt_at");
  String get common_txt_and => Intl.message("and", name: "common_txt_and");
  String get common_txt_other_singular => Intl.message("other", name: "common_txt_other_singular");
  String get common_txt_other_plural => Intl.message("others", name: "common_txt_other_plural");
  String get common_txt_explore => Intl.message("explore", name: "common_txt_explore");
  String get common_txt_record => Intl.message("record", name: "common_txt_record");
  String get common_txt_yes => Intl.message("yes", name: "common_txt_yes");
  String get common_txt_no => Intl.message("no", name: "common_txt_no");

  // Common Button Text
  String get common_btn_connect => Intl.message("Connect", name: "common_btn_connect");
  String get common_btn_login => Intl.message("LOGIN", name: "common_btn_login");
  String get common_btn_signUp => Intl.message("SIGN UP", name: "common_btn_signUp");
  String get common_btn_next => Intl.message("NEXT", name: "common_btn_next");
  String get common_btn_done => Intl.message("DONE", name: "common_btn_done");
  String get common_btn_agree => Intl.message("AGREE", name: "common_btn_agree");
  String get common_btn_no => Intl.message("NO", name: "common_btn_no");
  String get common_btn_save => Intl.message("SAVE", name: "common_btn_save");
  String get common_btn_add => Intl.message("ADD", name: "common_btn_add");
}

class MyLocalizationsDelegate extends LocalizationsDelegate<Strings> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}