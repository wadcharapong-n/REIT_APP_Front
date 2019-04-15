import 'package:flutter/material.dart';
import 'package:reit_app/services/profile_service.dart';
import 'package:reit_app/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = User();
  var x = '';

  @override
  void initState() {
    super.initState();

    getProfileData().then((result) {
      setState(() {
        user = result;
        x = user.fullName;
      });
      print('image =======>' + user.image);
      print('name ========>' + user.fullName);
      print('email =======>' + user.email);
      print('site =======>' + user.site);
      print('userID =======>' + user.userID);
      print('userName =======>' + user.userName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ima = Center(
      child: Container(
        width: 120,
        height: 120,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          maxRadius: 40,
          backgroundImage: AssetImage(
            // user.image
            'assets/alucard.jpg',
          ),
        ),
      ),
    );

    final detail = Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                x,
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

    final email = Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Container(
        padding: EdgeInsets.all(20),
        child: TextFormField(
          cursorColor: Colors.red,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
          ),
          initialValue: user.email,
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ),
    );

    final submitButton = Padding(
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
          // Perform some action
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Profile',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
        ),
      ),
      backgroundColor: Colors.orange[300],
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            ima,
            detail,
            email,
            submitButton,
          ],
        ),
      ),
    );
  }
}
