import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/services/reit_detail_service.dart';
import 'package:reit_app/screens/dashboard/widgets/favorite.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/models/reit_favorite.dart';

class DetailReit extends StatefulWidget {
  final String reitSymbol;
  // final ReitDetailService reitDetailService;
  DetailReit({Key key, this.reitSymbol});
  
  @override
  DetailReitState createState() => DetailReitState();
}

class DetailReitState extends State<DetailReit> {
  final injector = Injector.getInjector();
  ReitDetail reitDetail;
  bool isEmptyFavorite;
  bool isEllipsis = true;
  void toggleEllipsis() {
    setState(() {
      isEllipsis = !isEllipsis;
    });
  }

  @override
  void initState() {
    print("----------- initState --------------");
    super.initState();
    print("----------- super.initState --------------");
    ReitDetailService reitDetailService = injector.get<ReitDetailService>();
    reitDetailService.getReitDetailBySymbol(widget.reitSymbol).then((result) {
      setState(() {
        reitDetail = result;
        print("----------- reitDetail trustNameTh --------------");
        print(reitDetail.trustNameTh);
      });
      checkEmptyFavorite();
    });
  }

  checkEmptyFavorite() {
    for (final reitFavorite in FavoriteState.reitsFavorite) {
      if (reitFavorite.symbol == reitDetail.symbol) {
        isEmptyFavorite = false;
        break;
      } else {
        isEmptyFavorite = true;
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
          isEmptyFavorite == false ? iconDeleteFavorite() : iconAddFavorite()
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, false);
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
          ],
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
          addReitFavorite(reitDetail.symbol).then((result) {
            setState(() {
              isEmptyFavorite = false;
            });
            FavoriteState.reitsFavorite.add(
              ReitFavorite(
                  symbol: reitDetail.symbol,
                  trustNameTh: reitDetail.trustNameTh,
                  trustNameEn: reitDetail.trustNameEn,
                  priceOfDay: reitDetail.priceOfDay,
                  maxPriceOfDay: reitDetail.maxPriceOfDay,
                  minPriceOfDay: reitDetail.minPriceOfDay),
            );
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
        deleteReitFavorite(reitDetail.symbol).then((result) {
          setState(() {
            isEmptyFavorite = true;
          });
          FavoriteState.reitsFavorite.removeWhere(
              (item) => item.symbol == reitDetail.symbol);
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
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reitDetail.symbol,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
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
}
