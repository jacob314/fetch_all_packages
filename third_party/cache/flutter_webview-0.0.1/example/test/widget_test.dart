import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_example/main.dart';

void main() {
  testWidgets('Launches the webview', (WidgetTester tester) async {
    await tester.pumpWidget(new MyApp());

    expect(find.byKey(LAUNCH_BUTTON), findsOneWidget);
    await tester.tap(find.byKey(LAUNCH_BUTTON));
    await tester.pump();
  });
}
