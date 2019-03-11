import 'package:shared_preferences/shared_preferences.dart';
import 'package:reit_app/models/user.dart';

saveUserLogin({User user}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if ((user != null && user.userID != null && user.site != null)) {
    await preferences.setString('LastUserId', user.userID);
    await preferences.setString(
        'LastUserName',
        (user.userName != null && user.userName.length > 0)
            ? user.userName
            : "");
    await preferences.setString(
        'LastFullName',
        (user.fullName != null && user.fullName.length > 0)
            ? user.fullName
            : "");
    await preferences.setString('LastEmail',
        (user.email != null && user.email.length > 0) ? user.email : "");
    await preferences.setString('LastImage',
        (user.image != null && user.image.length > 0) ? user.image : "");
    await preferences.setString('LastSite', user.site);
  } else {}
}
