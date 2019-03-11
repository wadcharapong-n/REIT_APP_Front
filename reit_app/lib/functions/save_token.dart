import 'package:shared_preferences/shared_preferences.dart';

saveToken({String token}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (token != null) {
    await preferences.setString(
        'LastToken', (token != null && token.length > 0) ? token : "");
  }
}
