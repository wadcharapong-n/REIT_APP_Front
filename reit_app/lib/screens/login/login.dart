import 'package:flutter/material.dart';
import 'package:reit_app/loader.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  bool isLoading = false;
  String site;
  var facebookLogin = FacebookLogin();
  final loginService = Injector.getInjector().get<AuthenService>();

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

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
        this.isLoading = true;
        var accessToken = facebookLoginResult.accessToken.token;
        this.site = 'facebook';
        onLoginStatusChanged(true);
        loginService.getAccessToken(accessToken, this.site).then((isTrue) {
          if (isTrue == true) {
            Navigator.of(context).pushReplacementNamed('/Dashboard');
          } else {
            this.isLoading = false;
            initiateFacebookLogin();
          }
        });
        break;
    }
  }

  Padding logoReit() {
    return Padding(
      padding: EdgeInsets.only(top: 75.0),
      child: new Image(
          width: 250.0,
          height: 250.0,
          fit: BoxFit.fill,
          image: new AssetImage('assets/img/logo.png')),
    );
  }

  Container _buildLogin() {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              showWelcomeText(),
              colorButtonLoginFacebook(),
            ],
          ),
        ],
      ),
    );
  }

  Padding showWelcomeText() {
    return Padding(
      padding: EdgeInsets.only(top: 160.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white10,
                    Colors.white,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              "Welcome",
              style: TextStyle(
                  color: Colors.white, fontSize: 16.0, fontFamily: "Prompt"),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white10,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  Container colorButtonLoginFacebook() {
    return Container(
        margin: EdgeInsets.only(top: 200.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.orange[400],
              offset: Offset(1.0, 6.0),
              blurRadius: 10.0,
            ),
          ],
          gradient: new LinearGradient(
              colors: [Colors.blue, Colors.blue[200]],
              begin: const FractionalOffset(0.2, 0.2),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: buttonLoginFacebook());
  }

  MaterialButton buttonLoginFacebook() {
    return MaterialButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.blue,
      onPressed: () {
        initiateFacebookLogin();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
        child: Text(
          "Login With Facebook",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: "Prompt"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return new Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [const Color(0xFFFFF3E0), const Color(0xFFEF6c00)],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                logoReit(),
                _buildLogin(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Loader(),
        ),
      );
    }
  }
}
