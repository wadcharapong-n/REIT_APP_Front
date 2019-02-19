import 'package:flutter/material.dart';
import 'package:reit_app/models/reit.dart';

class DetailReit extends StatelessWidget {
  final Reit reit;

  DetailReit(this.reit);

  Container _getContent() {
    final _overviewTitle = "Content".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _overviewTitle,
                ),
                new Text(
                  reit.name,
                ),
              ],
            ),
          ),
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

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Colors.green,
        child: new Stack(
          children: <Widget>[
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }
}
