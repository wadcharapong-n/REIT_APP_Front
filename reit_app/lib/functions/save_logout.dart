import 'package:shared_preferences/shared_preferences.dart';

saveLogout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.remove('LastUserId');
  await preferences.remove('LastUserName');
  await preferences.remove('LastFullName');
  await preferences.remove('LastEmail');
  await preferences.remove('LastImage');
  await preferences.remove('LastEmail');
  await preferences.remove('LastSite');
  await preferences.remove('LastToken');
}
