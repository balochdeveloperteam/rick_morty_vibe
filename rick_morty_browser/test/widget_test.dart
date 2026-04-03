import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Material smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Rick & Morty')),
        ),
      ),
    );
    expect(find.text('Rick & Morty'), findsOneWidget);
  });
}
