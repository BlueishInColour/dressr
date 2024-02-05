import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get username => _sharedPrefs.getString('currentUserName') ?? "";
  String get displayname => _sharedPrefs.getString('currentDisplayName') ?? "";

  set username(String value) {
    _sharedPrefs.setString('currentUserName', value);
  }

  set displayname(String value) {
    _sharedPrefs.setString('currentDisplayName', value);
  }
}
