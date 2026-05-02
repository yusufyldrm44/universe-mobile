import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universe/main.dart';
import 'package:universe/services/auth_service.dart';

void main() {
  testWidgets('UniVerseApp builds without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(UniVerseApp(authService: AuthService()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
