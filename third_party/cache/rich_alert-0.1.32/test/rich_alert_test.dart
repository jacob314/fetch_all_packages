import 'package:flutter_test/flutter_test.dart';
import 'package:rich_alert/rich_alert.dart';

void main() {
  testWidgets("Test for the RichAlertDialog widget",
      (WidgetTester tester) async {
    await tester.pumpWidget(RichAlertDialog(
      alertTitle: richTitle("My title"),
      alertSubtitle: richSubtitle("My subtitle"),
      alertType: RichAlertType.SUCCESS,
    ));

    final titleFinder = find.text("My title");
    final subtitleFinder = find.text("My subtitle");

    expect(titleFinder, findsOneWidget);
    expect(subtitleFinder, findsOneWidget);
  });
}
