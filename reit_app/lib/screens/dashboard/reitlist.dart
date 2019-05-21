import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:reit_app/models/reit_detail.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/authen_service.dart';
import 'package:reit_app/services/search_service.dart';

class ReitList extends StatefulWidget {
  final String comeForm;
  ReitList({Key key, this.comeForm});
  @override
  ReitListState createState() => ReitListState();
}

class ReitListState extends State<ReitList> {
  final reitListService = Injector.getInjector().get<SearchService>();
  final authenService = Injector.getInjector().get<AuthenService>();
  List<ReitDetail> reitList = List<ReitDetail>();

  @override
  void initState() {
    super.initState();
    getReitAndSetState();
  }

  getReitAndSetState() {
    reitListService.getReitAll().then((result) {
      setState(() {
        reitList = result;
      });
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
            itemBuilder: (context, index) => ReitListRow(
                  reitList: reitList[index],
                  comeForm: widget.comeForm,
                ),
            itemCount: reitList.length,
            padding: EdgeInsets.symmetric(vertical: 16.0)),
      ),
    );
  }
}

class ReitListRow extends StatefulWidget {
  final ReitDetail reitList;
  final String comeForm;
  const ReitListRow({Key key, this.reitList, this.comeForm}) : super(key: key);

  @override
  ReitListRowState createState() {
    return ReitListRowState();
  }
}

class ReitListRowState extends State<ReitListRow> {
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
                    reitSymbol: widget.reitList.symbol,
                    comeForm: widget.comeForm,
                  )),
        );
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

  Padding _getSection1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          reitSymbol(),
        ],
      ),
    );
  }

  Text reitSymbol() {
    return Text(
      widget.reitList.symbol,
      style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Quicksand'),
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
          ? Text(widget.reitList.trustNameTh,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Baijamjuree'),
              overflow: TextOverflow.ellipsis)
          : Text(
              widget.reitList.trustNameTh,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Baijamjuree'),
            ),
    );
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
                            text: 'สูงสุด : ',
                            value: widget.reitList.maxPriceOfDay,
                            color: Colors.blue),
                        _reitPriceMaxMin(
                            text: 'ต่ำสุด : ',
                            value: widget.reitList.minPriceOfDay,
                            color: Colors.red),
                      ],
                    ),
                  ),
                  _reitPriceOfDay(
                      value: widget.reitList.priceOfDay, color: Colors.green),
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
          textAlign: TextAlign.right),
    );
  }
}
