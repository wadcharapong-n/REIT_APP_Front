import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/screens/dashboard/favorite.dart';
import 'package:reit_app/screens/dashboard/reitlist.dart';
import 'package:reit_app/screens/search/search.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/services/shared_preferences_service.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  final sharedPreferencesService =
      Injector.getInjector().get<SharedPreferencesService>();
  final authenService = Injector.getInjector().get<AuthenService>();
  bool isEmptyReit = false;

  @override
  void initState() {
    super.initState();
    getFavoriteReitAndSetState();
  }

  getFavoriteReitAndSetState() {
    favoriteService.getFavoriteReitByUserId().then((result) {
      if (result.length > 0) {
        setState(() {
          chaekIsEmptyReitAndSetState(false);
        });
      }
    }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
  }

  chaekIsEmptyReitAndSetState(value) {
    setState(() {
      isEmptyReit = value;
    });
  }

  Widget appBarDashbord() {
    return AppBar(
      backgroundColor: Color(0xFFFB8c00),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'หน้าหลัก',
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            fontFamily: 'Prompt'),
      ),
      actions: <Widget>[
        PopupMenuButton(
            icon: Icon(
              Icons.menu,
              size: 38,
            ),
            itemBuilder: (_) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_circle),
                          Text('  ข้อมูลผู้ใช้'),
                        ],
                      ),
                      value: 'Profile'),
                  PopupMenuItem<String>(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.reply),
                          Text('  ออกจากระบบ'),
                        ],
                      ),
                      value: 'Logout'),
                ],
            onSelected: (value) {
              if (value == 'Logout') {
                sharedPreferencesService.saveLogout().then((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });
              } else if (value == 'Profile') {
                Navigator.of(context).pushNamed('/Profile');
              }
            }),
      ],
    );
  }

  Row inputSearch() {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await showSearch(
                context: context,
                delegate: Search(),
              );
            },
            child: Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 100.0,
              margin: const EdgeInsets.fromLTRB(15, 10, 5, 10),
              padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  Text(
                    '  ค้นหา',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(0.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white.withOpacity(0.9),
            onPressed: () => {Navigator.pushNamed(context, '/Location')},
            child: Icon(
              Icons.location_on,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Column headerFavorite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 0, 5),
              child: Text(
                'รายการที่สนใจ',
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Prompt'),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
              child: ButtonTheme(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                minWidth: 50.0,
                height: 25.0,
                child: RaisedButton(
                  child: Text(
                    'กองทรัสต์ทั้งหมด',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Prompt',
                    ),
                  ),
                  color: Colors.blue,
                  elevation: 4.0,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ReitAll');
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            height: 1.0,
            width: 400.0,
            color: Colors.black),
      ],
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
                'กองทรัสต์ทั้งหมด',
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
            inputSearch(),
            isEmptyReit == false ? headerFavorite() : headerReitList(),
            isEmptyReit == false
                ? Favorite(
                    chaekIsEmptyReitAndSetState: chaekIsEmptyReitAndSetState)
                : ReitList(),
          ],
        ),
      ]),
    );
  }
}
