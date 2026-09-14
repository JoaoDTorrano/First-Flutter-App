import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:namer_app/main.dart';

void main() {
  // Rail is collapsed (labels hidden), so navigate by tapping its icon.
  final favoritesTab = find.descendant(
    of: find.byType(NavigationRail),
    matching: find.byIcon(Icons.favorite),
  );

  testWidgets('shows a word pair and the Like/Next buttons', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(BigCard), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next generates a different word pair', (tester) async {
    await tester.pumpWidget(const MyApp());

    final before = tester.widget<BigCard>(find.byType(BigCard)).pair;
    await tester.tap(find.text('Next'));
    await tester.pump();
    final after = tester.widget<BigCard>(find.byType(BigCard)).pair;

    expect(after, isNot(equals(before)));
  });

  testWidgets('Like adds the word pair to favorites', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    final pair = tester.widget<BigCard>(find.byType(BigCard)).pair;
    await tester.tap(find.text('Like'));
    await tester.pump();

    // The button icon switches to a filled heart.
    expect(find.byIcon(Icons.favorite_border), findsNothing);

    // Navigate to the Favorites tab.
    await tester.tap(favoritesTab);
    await tester.pumpAndSettle();

    expect(find.text('You have 1 favorites:'), findsOneWidget);
    expect(find.text(pair.asLowerCase), findsOneWidget);
  });

  testWidgets('Favorites page is empty by default', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(favoritesTab);
    await tester.pumpAndSettle();

    expect(find.text('No favorites yet.'), findsOneWidget);
  });
}
