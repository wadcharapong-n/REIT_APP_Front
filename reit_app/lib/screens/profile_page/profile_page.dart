import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final picture = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 78.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/alucard.jpg'),
        ),
      ),
    );

    final detail = Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // color: Colors.greenAccent,
                  // margin: EdgeInsets.fromLTRB(left, top, right, bottom),
                  child: Container(
                    // alignment: Alignment(0, 0),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Nok',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.greenAccent,
                  // margin: EdgeInsets.all(25),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Fly',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Container(
              // color: Colors.greenAccent,
              child: Column(
                children: <Widget>[
                  TextFormField(
                      decoration: InputDecoration(
                    labelText: 'ชื่อ',
                    hintText: 'Smith',
                  )),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email', hintText: 'Smith@outlook.co.th'),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment(-1, 0),
                    child: Text('เพศ'),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Radio(value: false, onChanged: (bool newValue) {}),
                            Text('ชาย'),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Radio(value: false, onChanged: (bool newValue) {}),
                            Text('หญิง'),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Radio(value: false, onChanged: (bool newValue) {}),
                            Text('อื่นๆ'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment(-1, 0),
                    child: Row(
                      children: <Widget>[
                        Checkbox(value: false, onChanged: (bool newValue) {}),
                        Text('รับข่าวสารทางอีเมล'),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: const Text('ยืนยันข้อมูล'),
                    color: Colors.blue,
                    elevation: 12,
                    onPressed: () {
                      // Perform some action
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white,
        ]),
      ),
      child: Column(
        children: <Widget>[
          picture,
          detail,
        ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
