import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:reit_app/services/login_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  var profileData;
  String site;
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
        radius: 150,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final loginGoogle = Padding(
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Login With Google',
            style: TextStyle(color: Colors.black, fontSize: 15)),
      ),
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
          var accessToken = facebookLoginResult.accessToken.token;
          this.site = 'facebook';
          onLoginStatusChanged(true, profileData: null);
          getToken(accessToken, this.site).then((isTrue) {
            if (isTrue == true) {
              Navigator.of(context).pushReplacementNamed('/Dashboard');
            } else {
              initiateFacebookLogin();
            }
          });
          break;
      }
    }

    final loginFacebook = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 20),
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
      backgroundColor: Colors.orange[600],
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            logo,
            SizedBox(height: 100),
            loginGoogle,
            loginFacebook,
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
