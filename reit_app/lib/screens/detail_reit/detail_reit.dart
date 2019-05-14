import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/reit_detail_service.dart';
import 'package:reit_app/loader.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailReit extends StatefulWidget {
  final String reitSymbol;
  DetailReit({Key key, this.reitSymbol});

  @override
  DetailReitState createState() => DetailReitState();
}

class DetailReitState extends State<DetailReit> {
  var reitDetailService = Injector.getInjector().get<ReitDetailService>();
  var favoriteService = Injector.getInjector().get<FavoriteService>();
  final authenService = Injector.getInjector().get<AuthenService>();
  ReitDetail reitDetail;
  bool isFavoriteReit;
  bool isEllipsis = true;
  void toggleEllipsis() {
    setState(() {
      isEllipsis = !isEllipsis;
    });
  }

  @override
  void initState() {
    super.initState();
    getReitDetailBySymbol();
    checkFavoriteReitAndSetState(widget.reitSymbol);
  }

  getReitDetailBySymbol() {
    reitDetailService.getReitDetailBySymbol(widget.reitSymbol).then((result) {
      setState(() {
        reitDetail = result;
      });
    }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
  }

  checkFavoriteReitAndSetState(String symbol) async {
    await favoriteService.isFavoriteReit(symbol).then((result) {
      setState(() {
        isFavoriteReit = result;
      });
    }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
  }

  Widget build(BuildContext context) {
    if (reitDetail == null) {
      return Scaffold(
        body: Center(
          child: Loader(),
        ),
      );
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Reit Detail",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            fontFamily: 'Prompt',
          ),
        ),
        backgroundColor: Colors.orange[600],
        actions: <Widget>[
          isFavoriteReit == true ? iconDeleteFavorite() : iconAddFavorite()
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Dashboard', (Route<dynamic> route) => false);
          },
        ),
      ),
      body: new Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              _getSection1(),
              _getSection2(),
              _getSection3(),
              _getSection4(),
              _getSection5(),
            ],
          ),
        ),
      ),
    );
  }

  IconButton iconAddFavorite() {
    return IconButton(
        icon: Icon(
          Icons.star_border,
          color: Colors.blue,
          size: 30,
        ),
        onPressed: () {
          favoriteService.addReitFavorite(reitDetail.symbol).then((result) {
            if (result) {
              setState(() {
                isFavoriteReit = true;
              });
            }
          }).catchError(
              (_) => {authenService.LogoutAndNavigateToLogin(context)});
        });
  }

  IconButton iconDeleteFavorite() {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: Colors.blue,
        size: 34,
      ),
      onPressed: () {
        favoriteService.deleteReitFavorite(reitDetail.symbol).then((result) {
          if (result) {
            setState(() {
              isFavoriteReit = false;
            });
          }
        }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
      },
    );
  }

  final borderBottom = new BoxDecoration(
    border: new Border(
        bottom: BorderSide(
      color: Colors.black12,
      width: 1,
    )),
  );

  Text getTrustNameTh() {
    if (isEllipsis) {
      return Text(
        reitDetail.trustNameTh,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Sarabun',
        ),
      );
    }
    return Text(
      reitDetail.trustNameTh,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Sarabun',
      ),
    );
  }

  Text getTrustNameEn() {
    if (isEllipsis) {
      return Text(
        reitDetail.trustNameEn,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Sarabun',
        ),
      );
    }
    return Text(
      reitDetail.trustNameEn,
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Sarabun',
      ),
    );
  }

  Container _getSection1() {
    return new Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: borderBottom,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex: 8,
                          child: Text(reitDetail.symbol,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Prompt',
                              )),
                        ),
                        Flexible(flex: 2, child: buttonBuy()),
                      ],
                    ),
                    GestureDetector(
                        onTap: toggleEllipsis,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              getTrustNameTh(),
                              getTrustNameEn()
                            ])),
                  ],
                ),
              ),
            ),
            new Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(reitDetail.priceOfDay,
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Prompt',
                        )),
                    Text(reitDetail.maxPriceOfDay,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Prompt',
                        )),
                    Text(reitDetail.minPriceOfDay,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Prompt',
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Container _getSection2Left() {
    return new Container(
      padding: EdgeInsets.only(left: 0, right: 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Par(Baht)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  "Ceiling",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  "Floor",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  reitDetail.parValue,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
                Text(
                  reitDetail.ceilingValue,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
                Text(
                  reitDetail.floorValue,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _getSection2Right() {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "P/NAV",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Prompt'),
                ),
                Text(
                  "P/E",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Prompt'),
                ),
                Text(
                  "Dvd.Yield(%)",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Prompt'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  reitDetail.parNAV,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
                Text(
                  reitDetail.peValue,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                ),
                Text(
                  reitDetail.dvdYield,
                  style: TextStyle(fontSize: 16, fontFamily: 'Prompt'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _getSection2() {
    return new Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
                child: Column(
              children: <Widget>[_getSection2Left()],
            )),
            new Expanded(
                child: Column(
              children: <Widget>[_getSection2Right()],
            ))
          ],
        ));
  }

  Container _getSection3() {
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      decoration: borderBottom,
      child: Row(
        children: <Widget>[
          new Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "ผู้จัดการกองทรัสต์",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.reitManager,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
              Text(
                "ผู้บริหารอสังหาริมทรัพย์",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.propertyManager,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
              Text(
                "ผู้ดูแลผลประโยชน์ (Trustee)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.trustee,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
              Text(
                "นโยบายการลงทุน",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.investmentPolicy,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
              Text(
                "ที่อยู่",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.address,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
              Text(
                "หุ้นสามัญ (ทุนจดทะเบียน)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                reitDetail.investmentAmount,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Sarabun',
                ),
              ),
              SizedBox(height: 2),
            ],
          ))
        ],
      ),
    );
  }

  Widget _getSection4() {
    if (reitDetail.places.isEmpty) {
      return Container();
    }
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      decoration: borderBottom,
      child: Row(
        children: <Widget>[
          new Expanded(
            child: loopWidgetPlace(reitDetail.places),
          )
        ],
      ),
    );
  }

  Widget loopWidgetPlace(List<Place> places) {
    if (places == null) {
      return Container();
    }
    List<Widget> listPlaceWidget = List<Widget>();
    for (var i = 0; i < places.length; i++) {
      if (i == 0) {
        listPlaceWidget.add(Text(
          'สินทรัพย์ที่ลงทุน',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Sarabun',
          ),
        ));
        listPlaceWidget.add(SizedBox(height: 5));
      }
      listPlaceWidget.add(Text(
        places[i].name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'Sarabun',
        ),
      ));
      listPlaceWidget.add(Text(
        reitDetail.address,
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'Sarabun',
        ),
      ));
      listPlaceWidget.add(SizedBox(height: 2));
    }

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listPlaceWidget);
    ;
  }

  Container _getSection5() {
    if (!(reitDetail.majorShareholders.isEmpty)) {
      return new Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        decoration: borderBottom,
        child: Row(
          children: <Widget>[
            new Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ผู้ถือหุ้นรายใหญ่",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Sarabun',
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: {
                      0: FractionColumnWidth(.10),
                      1: FractionColumnWidth(.70),
                      2: FractionColumnWidth(.20),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'No.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            'Percent',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sarabun',
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      _tableRowSection5(0),
                      _tableRowSection5(1),
                      _tableRowSection5(2),
                      _tableRowSection5(3),
                      _tableRowSection5(4),
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  TableRow _tableRowSection5(int index) {
    var no = index + 1;
    if (reitDetail.majorShareholders.length > index) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 2, 10),
            child: Text(
              no.toString(),
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 2, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reitDetail.majorShareholders[index].nameTh,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 2, 10),
            child: Text(
              reitDetail.majorShareholders[index].sharesPercent,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
        ],
      );
    } else {
      return TableRow(
        children: [
          Text(''),
          Text(''),
          Text(''),
        ],
      );
    }
  }

  Container buttonBuy() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: ButtonTheme(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        minWidth: 50.0,
        height: 25.0,
        child: RaisedButton(
          child: Text(
            'Buy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Prompt',
            ),
          ),
          color: Colors.blue,
          elevation: 4.0,
          onPressed: () {
            _launchURL();
          },
        ),
      ),
    );
  }

  _launchURL() async {
    var url = 'http://' + reitDetail.urlAddress;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
