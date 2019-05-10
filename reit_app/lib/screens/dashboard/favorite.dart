import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/favorite_reit.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/favorite_services.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/shared_preferences_service.dart';

class Favorite extends StatefulWidget {
  Function chaekIsEmptyReitAndSetState;
  Favorite({Key key, this.chaekIsEmptyReitAndSetState});

  @override
  FavoriteState createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<Favorite> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  List<FavoriteReit> favoriteReitList = List<FavoriteReit>();
  final authenService = Injector.getInjector().get<AuthenService>();

  @override
  void initState() {
    super.initState();
    getFavoriteReitAndSetState();
  }

  getFavoriteReitAndSetState() {
    favoriteService.getFavoriteReitByUserId().then((result) {
      setState(() {
        favoriteReitList.clear();
        result.forEach((data) {
          favoriteReitList.add(data);
        });
      });
      if (favoriteReitList.length > 0) {
        widget.chaekIsEmptyReitAndSetState(false);
      } else {
        widget.chaekIsEmptyReitAndSetState(true);
      }
    }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
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
                favoriteReit: favoriteReitList[index],
                getFavoriteReitAndSetState: getFavoriteReitAndSetState),
            itemCount: favoriteReitList.length,
            padding: EdgeInsets.symmetric(vertical: 16.0)),
      ),
    );
  }
}

class ReitRow extends StatefulWidget {
  final FavoriteReit favoriteReit;
  final Function getFavoriteReitAndSetState;

  const ReitRow({Key key, this.favoriteReit, this.getFavoriteReitAndSetState})
      : super(key: key);

  @override
  ReitRowState createState() {
    return ReitRowState();
  }
}

class ReitRowState extends State<ReitRow> {
  final favoriteService = Injector.getInjector().get<FavoriteService>();
  final sharedPreferencesService =
      Injector.getInjector().get<SharedPreferencesService>();
  final authenService = Injector.getInjector().get<AuthenService>();
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
                    reitSymbol: widget.favoriteReit.symbol,
                  )),
        ).then((result) {
          widget.getFavoriteReitAndSetState();
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
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
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
      widget.favoriteReit.symbol,
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Quicksand'),
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
        favoriteService
            .deleteReitFavorite(widget.favoriteReit.symbol)
            .then((result) {
          widget.getFavoriteReitAndSetState();
        }).catchError((_) => {authenService.LogoutAndNavigateToLogin(context)});
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
            ? Text(widget.favoriteReit.trustNameTh,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Baijamjuree'),
                overflow: TextOverflow.ellipsis)
            : Text(widget.favoriteReit.trustNameTh,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Baijamjuree')));
  }

  Row _getSection3() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _reitPriceMaxMin(
                            text: 'Max : ',
                            value: widget.favoriteReit.maxPriceOfDay,
                            color: Colors.blue),
                        _reitPriceMaxMin(
                            text: 'Min : ',
                            value: widget.favoriteReit.minPriceOfDay,
                            color: Colors.red),
                      ],
                    ),
                  ),
                  _reitPriceOfDay(
                      value: widget.favoriteReit.priceOfDay,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(text,
              style: TextStyle(
                  color: color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand'),
              textAlign: TextAlign.left),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand'),
              textAlign: TextAlign.left),
        ],
      ),
    );
  }

  Expanded _reitPriceOfDay({String value, Color color}) {
    return Expanded(
        flex: 4,
        child: Text(value,
            style: TextStyle(
                color: color,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand'),
            textAlign: TextAlign.right));
  }
}
