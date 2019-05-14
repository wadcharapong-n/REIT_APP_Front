import 'package:flutter/material.dart';
import 'package:reit_app/services/profile_service.dart';
import 'package:reit_app/models/user.dart';
import 'package:reit_app/loader.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  final profileService = Injector.getInjector().get<ProfileService>();

  @override
  void initState() {
    super.initState();
  }

  Container buttonBack() {
    return Container(
        height: 45.0,
        width: 150.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.redAccent,
          color: Colors.red,
          elevation: 7.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: MaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                height: 30.0,
                child: new Text(
                  'กลับ',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Prompt',
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ));
  }

  Container showImage(String imageUrl) {
    return Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(75.0)),
            boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]));
  }

  Container showName(String name) {
    return Container(
      child: Text(
        name,
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: 'Prompt'),
      ),
    );
  }

  Text showEmail(String email) {
    return Text(
      'อีเมล : ' + email,
      style: TextStyle(
          fontSize: 18.0, fontStyle: FontStyle.normal, fontFamily: 'Prompt'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: profileService.getProfileData(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.fullName != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFEF6c00),
                centerTitle: true,
                elevation: 0,
                title: Text(
                  'ข้อมูลผู้ใช้',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      fontFamily: 'Prompt'),
                ),
              ),
              body: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFFFFF3E0),
                        const Color(0xFFEF6c00)
                      ],
                      begin: const FractionalOffset(0.0, 0.5),
                      end: const FractionalOffset(0.1, 0.0),
                      stops: [0.0, 5.0],
                      tileMode: TileMode.clamp),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      showImage(snapshot.data.image),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      showName(snapshot.data.fullName),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      showEmail(snapshot.data.email),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      // buttonBack(),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: Loader(),
            ),
          );
        }
      },
    );
  }
}
