import 'package:flutter_test/flutter_test.dart';

import 'package:ajo_nation/main.dart';

void main() {
  testWidgets('app launches to the Ajo Hub splash experience', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Ajo Hub'), findsOneWidget);
    expect(find.text('Rotating savings, simplified'), findsOneWidget);
  });
}
