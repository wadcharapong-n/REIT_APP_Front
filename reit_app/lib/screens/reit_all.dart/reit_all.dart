import 'package:flutter/material.dart';
import 'package:reit_app/screens/dashboard/reitlist.dart';

class ReitAll extends StatefulWidget {
  @override
  ReitAllState createState() {
    return ReitAllState();
  }
}

class ReitAllState extends State<ReitAll> {
  @override
  void initState() {
    super.initState();
  }

  Widget appBarDashbord() {
    return AppBar(
      backgroundColor: Color(0xFFFB8c00),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'กองทรัสต์ทั้งหมด',
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            fontFamily: 'Prompt'),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/Dashboard', (Route<dynamic> route) => false);
        },
      ),
    );
  }

  Column headerReitList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(24, 5, 0, 5),
              child: Text(
                'รายการ',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Prompt'),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.fromLTRB(24, 5, 24, 0),
            height: 1.0,
            width: 400.0,
            color: Colors.black),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDashbord(),
      body: Stack(children: <Widget>[
        ClipPath(
          clipBehavior: Clip.antiAlias,
          child: Container(
              decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [const Color(0xFFFFF3E0), const Color(0xFFFB8c00)],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(0.6, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          )),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            headerReitList(),
            ReitList(
              comeForm: '/ReitAll',
            ),
          ],
        ),
      ]),
    );
  }
}
