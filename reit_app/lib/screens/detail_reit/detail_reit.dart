import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/services/reit_detail_service.dart';
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
    });
  }

  checkFavoriteReitAndSetState(String symbol) async {
    await favoriteService.isFavoriteReit(symbol).then((result) {
      setState(() {
        isFavoriteReit = result;
      });
    });
  }

  Widget build(BuildContext context) {
    if (reitDetail == null) {
      return new Scaffold();
    }

    if (reitDetail.majorShareholders.isEmpty) {}

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Reit Detail",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.0),
        ),
        backgroundColor: Colors.orange[600],
        actions: <Widget>[
          isFavoriteReit == true ? iconDeleteFavorite() : iconAddFavorite()
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/Dashboard');
            //  .pushNamedAndRemoveUntil(
            //     '/Dashboard', (Route<dynamic> route) => false);
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
            setState(() {
              isFavoriteReit = true;
            });
          });
        });
  }

  IconButton iconDeleteFavorite() {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: Colors.blue,
        size: 30,
      ),
      onPressed: () {
        favoriteService.deleteReitFavorite(reitDetail.symbol).then((result) {
          setState(() {
            isFavoriteReit = false;
          });
        });
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
      return Text(reitDetail.trustNameTh, overflow: TextOverflow.ellipsis);
    }
    return Text(reitDetail.trustNameTh);
  }

  Text getTrustNameEn() {
    if (isEllipsis) {
      return Text(reitDetail.trustNameEn, overflow: TextOverflow.ellipsis);
    }
    return Text(reitDetail.trustNameEn);
  }

  Container _getSection1() {
    return new Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Text(reitDetail.symbol,
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      buttonBuy(),
                    ],
                  ),
                  GestureDetector(
                      onTap: toggleEllipsis,
                      child: Column(children: <Widget>[
                        getTrustNameTh(),
                        getTrustNameEn()
                      ])),
                ],
              ),
            ),
            new Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(reitDetail.priceOfDay,
                      style: TextStyle(fontSize: 40, color: Colors.green)),
                  Text(reitDetail.maxPriceOfDay,
                      style: TextStyle(fontSize: 16, color: Colors.blue)),
                  Text(reitDetail.minPriceOfDay,
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),
            )
          ],
        ));
  }

  Container _getSection2Left() {
    return new Container(
      padding: EdgeInsets.only(left: 0, right: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("ราคา Par"),
              Text("P/E"),
              Text("ราคา Floor"),
            ],
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(reitDetail.parValue),
              Text(reitDetail.peValue),
              Text(reitDetail.floorValue),
            ],
          )
        ],
      ),
    );
  }

  Container _getSection2Right() {
    return new Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text("P/Nav"), Text("ราคา Ceiling"), Text("")],
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(reitDetail.parNAV),
              Text(reitDetail.ceilingValue),
              Text("")
            ],
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
                "นโยบายเงินปันผล",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(reitDetail.policy),
            ],
          ))
        ],
      ),
    );
  }

  Container _getSection4() {
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
                "ทรัสตี (Trustee)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(reitDetail.trustee),
            ],
          ))
        ],
      ),
    );
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Table(
                    // border: TableBorder.lerp(1, 0, 1),
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: {
                      0: FractionColumnWidth(.10),
                      1: FractionColumnWidth(.60),
                      2: FractionColumnWidth(.15),
                      3: FractionColumnWidth(.15),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text('No.'),
                          Text('Name'),
                          Text('Shares'),
                          Text('Percent'),
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
            padding: const EdgeInsets.fromLTRB(0, 3, 1, 10),
            child: Text(no.toString()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 1, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(reitDetail.majorShareholders[index].nameTh),
                Text(reitDetail.majorShareholders[index].nameEn),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 1, 10),
            child: Text(reitDetail.majorShareholders[index].shares),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 1, 10),
            child: Text(reitDetail.majorShareholders[index].sharesPercent),
          ),
        ],
      );
    } else {
      return TableRow(
        children: [
          Text(''),
          Text(''),
          Text(''),
          Text(''),
        ],
      );
    }
  }

  Container buttonBuy() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      child: ButtonTheme(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        minWidth: 50.0,
        height: 25.0,
        child: RaisedButton(
          child: Text(
            'Buy',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
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
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
