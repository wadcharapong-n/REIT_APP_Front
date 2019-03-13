import 'package:flutter/material.dart';
import 'package:reit_app/app_config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ima = Center(
      child: Container(
        width: 200,
        height: 200,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          maxRadius: 80,
          backgroundImage: AssetImage(
            'assets/alucard.jpg',
          ),
        ),
      ),
    );

    final detail = Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      AppConfig.user.fullName,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   child: Text(
                //     'Fly',
                //     style: TextStyle(
                //         fontSize: 25,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white),
                //   ),
                // ),
              ],
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                const Radius.circular(8.0),
              ),
            ),
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
          ),
          initialValue: AppConfig.user.email,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
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
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: 60),
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
