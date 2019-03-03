import 'package:flutter/material.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/services/reit_detail_service.dart';
import 'package:reit_app/screens/home_page/widgets/favorite.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/models/reit_favorite.dart';

class DetailReit extends StatefulWidget {
  final String reitSymbol;
  DetailReit({Key key, this.reitSymbol}) : super(key: key);

  @override
  DetailReitState createState() => DetailReitState();
}

class DetailReitState extends State<DetailReit> {
  ReitDetail reitDetail;
  bool favorite;

  @override
  void initState() {
    super.initState();
    getReitDetailBySymbol(widget.reitSymbol).then((result) {
      setState(() {
        reitDetail = result;
      });
      checkFavorite();
    });
  }

  checkFavorite() {
    for (final reitFavorite in FavoriteState.reitsFavorite) {
      if (reitFavorite.ticker == reitDetail.symbol) {
        favorite = true;
        break;
      } else {
        favorite = false;
      }
    }
  }

  Widget build(BuildContext context) {
    if (reitDetail == null) {
      return new Scaffold();
    }
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Reit Detail"),
        backgroundColor: Colors.red[200],
        actions: <Widget>[
          favorite == true
              ? IconButton(
                  icon: Icon(
                    Icons.star,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {
                    deleteReitFavorite('1', reitDetail.symbol).then((result) {
                      setState(() {
                        favorite = false;
                      });
                      FavoriteState.reitsFavorite.removeWhere((item) =>
                          item.userId == '1' &&
                          item.ticker == reitDetail.symbol);
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.star_border,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {
                    addReitFavorite('1', reitDetail.symbol).then((result) {
                      setState(() {
                        favorite = true;
                      });
                      Object json = {
                        'UserId': '1',
                        'Ticker': reitDetail.symbol
                      };
                      FavoriteState.reitsFavorite
                          .add(ReitFavorite.fromJson(json));
                    });
                  })
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: new Container(
        margin: EdgeInsets.all(10),
        child: new Column(
          children: <Widget>[
            _getSection1(),
            _getSection2(),
            _getSection3(),
            _getSection4()
            //  _getToolbar(context),
          ],
        ),
      ),
    );
  }

  final borderBottom = new BoxDecoration(
    border: new Border(
        bottom: BorderSide(
      color: Colors.black12,
      width: 1,
    )),
  );

  Container _getSection1() {
    return new Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reitDetail.symbol,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Text(reitDetail.trustNameTh, overflow: TextOverflow.ellipsis),
                  Text(reitDetail.trustNameEn, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            new Expanded(
              flex: 4,
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
      padding: EdgeInsets.only(left: 5, right: 5),
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

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.white),
    );
  }
}
