import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_glance/ui/article_screen.dart';

void main() {
  testWidgets('ArticleScreen widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ArticleScreen()));

    // Check if the app bar is present.
    expect(find.byType(AppBar), findsOneWidget);
  });
}
