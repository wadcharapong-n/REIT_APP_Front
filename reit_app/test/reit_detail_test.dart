// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reit_app/models/reit_detail.dart';

import 'package:reit_app/screens/detail_reit/detail_reit.dart';
import 'package:reit_app/services/reit_detail_service.dart';

class MockReitDetail implements ReitDetail {
  @override  
  String get address => null;
  @override  
  String get ceilingValue => null;
  @override  
  String get establishmentDate => null;
  @override  
  String get floorValue => null;
  @override
  String handledNullString(String value) {    
    return null;
  }
  @override  
  String get id => null;
  @override  
  String get investmentAmount => null;
  @override  
  String get maxPriceOfDay => null;
  @override  
  String get minPriceOfDay => null;
  @override  
  String get nickName => null;
  @override  
  String get parNAV => null;
  @override  
  String get parValue => null;
  @override  
  String get peValue => null;
  @override  
  String get policy => null;
  @override  
  String get priceOfDay => null;
  @override  
  String get registrationDate => null;
  @override  
  String get reitManager => null;
  @override  
  String get symbol => null;
  @override  
  String get trustNameEn => null;
  @override  
  String get trustNameTh => null;
  @override  
  String get trustee => null;
}

class BindingsOverride extends ReitDetailService {
  @override
  final ReitDetail foo = new MockReitDetail();
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {   
    var a = new DetailReit();
    a.reitService = new BindingsOverride();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(DetailReit());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
