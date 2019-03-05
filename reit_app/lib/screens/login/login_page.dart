import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:reit_app/screens/profile_page/profile_page.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 150.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final loginButtonGoogle = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(ProfilePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Login With Google',
            style: TextStyle(color: Colors.black, fontSize: 15)),
      ),
    );

    final or = Center(
      child: Text('OR', style: TextStyle(color: Colors.white)),
    );

    void initiateFacebookLogin() async {
      var facebookLoginResult =
          await facebookLogin.logInWithReadPermissions(['email']);

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.cancelledByUser:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile.toString());

          onLoginStatusChanged(true, profileData: profile);
          break;
      }
    }

    final loginFacebook = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => initiateFacebookLogin(),
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Login With Facebook',
            style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 100.0),
            loginButtonGoogle,
            or,
            loginFacebook,
            SizedBox(height: 300.0),
          ],
        ),
      ),
    );
  }
}
