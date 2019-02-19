import 'package:flutter/material.dart';
import 'package:reit_app/models/reit.dart';
import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/favorite_services.dart';

class Favorite extends StatefulWidget {
  @override
  FavoriteState createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<Favorite> {
  List<Reit> reits = [];
  @override
  void initState() {
    super.initState();
    loadJson();
  }

  loadJson() async {
    final jsonResponse = await loadReit();
    setState(() {
      jsonResponse.forEach((v) {
        print(v);
        final reitFormJson = Reit.fromJson(v);
        reits.add(reitFormJson);
      });
    });
  }

  deleteCard(reit) {
    setState(() {
      reits.remove(reit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemBuilder: (context, index) => ReitRow(
                reit: reits[index],
                deleteCard: deleteCard,
              ),
          itemCount: reits.length,
          padding: EdgeInsets.symmetric(vertical: 16.0)),
    );
  }
}

class ReitRow extends StatefulWidget {
  final Reit reit;
  final Function deleteCard;

  const ReitRow({Key key, this.reit, this.deleteCard}) : super(key: key);

  @override
  ReitRowState createState() {
    return ReitRowState();
  }
}

class ReitRowState extends State<ReitRow> {
  @override
  Widget build(BuildContext context) {
    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');

    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500);

    final regularTextStyle = baseTextStyle.copyWith(
        color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w400);

    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 16.0);
    Widget _planetValue({String value}) {
      return Row(children: <Widget>[
        Expanded(
          child: Text(value, style: regularTextStyle),
        ),
      ]);
    }

    final reitCardContent = Container(
      margin: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.reit.symbol,
                  style: headerTextStyle,
                ),
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: Colors.pink,
                  ),
                  tooltip: 'Delete Favorite',
                  onPressed: () {
                    print('object');
                    this.widget.deleteCard(widget.reit);
                  },
                ),
              ],
            ),
          ],
        ),
        Text(widget.reit.name, style: subHeaderTextStyle),
        Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 2.0,
            width: 40.0,
            color: Colors.black),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
        ),
        Row(
          children: <Widget>[
            Expanded(child: _planetValue(value: widget.reit.price))
          ],
        )
      ]),
    );

    final reitCard = Container(
      child: reitCardContent,
      margin: EdgeInsets.only(left: 46.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailReit(widget.reit),
          )),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 24.0,
        ),
        child: reitCard,
      ),
    );
  }
}
