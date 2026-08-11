import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domotics/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const DomoticsApp());
    // Verify the app shell renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
