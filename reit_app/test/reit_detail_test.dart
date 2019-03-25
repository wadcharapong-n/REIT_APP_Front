// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:fluaterial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reit_app/models/reit_detail.dart';

import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/reit_detail_service.dart';


class MockReitDetailService implements ReitDetailService {
  @override
  Future<ReitDetail> getReitDetailBySymbol(String reitSymbol) async {
    final reit = new ReitDetail(
      id : "1234",
      symbol : "TEST",
      trustNameTh : "บริษัท ทดสอบ จำกัด",
      trustNameEn : "Test Company",
      priceOfDay : "",
      maxPriceOfDay : "",
      minPriceOfDay : "",
      parValue : "",
      parNAV : "",
      peValue : "",
      ceilingValue : "",
      floorValue : "",
      policy : "",
      trustee : "",
      nickName : "",
      reitManager : "",
      address : "",
      registrationDate : "",
      investmentAmount : "",
      establishmentDate : "",
    );
    return reit;
  }
}

Widget getTestableWidget(ReitDetailService _reitDetailService) {
    return MaterialApp(
      home: new DetailReit(
        reitSymbol: "TEST",
        reitDetailService: _reitDetailService
      ),
    );
  }

void main() {
  test('Should get Reit detail after initState', () {
    var mockReitDetailService = new MockReitDetailService();
    var reit = new DetailReit(reitSymbol: "TEST", reitDetailService: mockReitDetailService).createState();

    // reit.widget.reitSymbol = "TEST";
    print(reit.reitDetail);
    // expect(await driver.getText(counterTextFinder), "0");
  });
  

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   var mockReitDetailService = new MockReitDetailService();  
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(getTestableWidget(mockReitDetailService));
    

    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  // });
}
