import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/reit_favorite.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';

class Favorite extends StatefulWidget {
  final Function checkIsEmptyReit;
  const Favorite({Key key, this.checkIsEmptyReit}) : super(key: key);
  @override
  FavoriteState createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<Favorite> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  static List<ReitFavorite> reitsFavorite = List();
  
  @override
  void initState() {
    super.initState();
    favoriteService.getReitFavoriteByUserId().then((result) {
      reitsFavorite = result;
      checkIsEmptyReit();
    });
  }

  checkIsEmptyReit() {
    bool value;
    if (reitsFavorite.length == 0) {
      value = true;
    } else {
      value = false;
    }
    widget.checkIsEmptyReit(value);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Expanded(
        child: ListView.builder(
            itemBuilder: (context, index) => ReitRow(
                  reitFavorite: reitsFavorite[index],
                  checkIsEmptyReit: checkIsEmptyReit,
                ),
            itemCount: reitsFavorite.length,
            padding: EdgeInsets.symmetric(vertical: 16.0)),
      ),
    );
  }
}

class ReitRow extends StatefulWidget {
  final ReitFavorite reitFavorite;
  final Function checkIsEmptyReit;

  const ReitRow({Key key, this.reitFavorite, this.checkIsEmptyReit})
      : super(key: key);

  @override
  ReitRowState createState() {
    return ReitRowState();
  }
}

class ReitRowState extends State<ReitRow> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  bool isEllipsis = true;
  void toggleEllipsis() {
    setState(() {
      isEllipsis = !isEllipsis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailReit(
                    reitSymbol: widget.reitFavorite.symbol,
                  )),
        ).then((result) {
          widget.checkIsEmptyReit();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 24.0,
        ),
        child: reitCard(),
      ),
    );
  }

  Container reitCard() {
    return Container(
      child: reitCardContent(),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  Container reitCardContent() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getSection1(),
        _getSection2(),
        _getSection3(),
      ]),
    );
  }

  Row _getSection1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        reitSymbol(),
        favoriteStar(),
      ],
    );
  }

  Text reitSymbol() {
    return Text(
      widget.reitFavorite.symbol,
      style: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
    );
  }

  IconButton favoriteStar() {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: Colors.blue,
        size: 30,
      ),
      tooltip: 'Delete Favorite',
      onPressed: () {
        favoriteService.deleteReitFavorite(
          widget.reitFavorite.symbol,
        ).then((result) {
          setState(() {
            FavoriteState.reitsFavorite.removeWhere(
              (item) => item.symbol == widget.reitFavorite.symbol,
            );
          });
          widget.checkIsEmptyReit();
        });
      },
    );
  }

  Column _getSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTrustNameTh(),
        Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 2.5,
            width: 350.0,
            color: Colors.green),
      ],
    );
  }

  GestureDetector getTrustNameTh() {
    return GestureDetector(
        onTap: toggleEllipsis,
        child: isEllipsis
            ? Text(widget.reitFavorite.trustNameTh,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis)
            : Text(widget.reitFavorite.trustNameTh,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400)));
  }

  Row _getSection3() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  _reitPriceMaxMin(
                      text: 'Max : ',
                      value: widget.reitFavorite.maxPriceOfDay,
                      color: Colors.blue),
                  _reitPriceMaxMin(
                      text: 'Min : ',
                      value: widget.reitFavorite.minPriceOfDay,
                      color: Colors.red),
                  _reitPriceOfDay(
                      value: widget.reitFavorite.priceOfDay,
                      color: Colors.green),
                ]),
          ),
        ),
      ],
    );
  }

  Expanded _reitPriceMaxMin({String text, String value, Color color}) {
    return Expanded(
      flex: 3,
      child: Text(text + value,
          style: TextStyle(
              color: color, fontSize: 16.0, fontWeight: FontWeight.w400),
          textAlign: TextAlign.left),
    );
  }

  Expanded _reitPriceOfDay({String value, Color color}) {
    return Expanded(
        flex: 4,
        child: Text(value,
            style:
                TextStyle(
              color: color, fontSize: 22.0, fontWeight: FontWeight.w400),
            textAlign: TextAlign.right));
  }
}
