import 'package:flutter/material.dart';
import 'package:reit_app/services/profile_service.dart';
import 'package:reit_app/models/user.dart';
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

  Center img(String imgUrl) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          maxRadius: 40,
          // backgroundImage: AssetImage(
          //   // user.image
          //   'assets/alucard.jpg',
          // ),
          backgroundImage: NetworkImage(imgUrl),
        ),
      ),
    );
  }

  Container name(String name) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding email(String email) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 90, 20, 50),
        child: TextFormField(
          enabled: false,
          cursorColor: Colors.red,
          decoration: InputDecoration(
            hintText: 'email: ' + email,
            hintStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Padding submitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          'ย้อนกลับ',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        color: Colors.white,
        elevation: 12,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                backgroundColor: Colors.orange[600],
                elevation: 2,
                centerTitle: true,
                title: Text(
                  'Profile',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0),
                ),
              ),
              backgroundColor: Colors.orange[300],
              body: Container(
                margin: EdgeInsets.only(top: 100),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    img(snapshot.data.image),
                    name(snapshot.data.fullName),
                    email(snapshot.data.email),
                    submitButton(),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
