// Package imports:
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:connectivity_checker/connectivity_checker.dart';

void main() {
  testWidgets('disposing ConnectivityAppWrapper stops polling',
      (WidgetTester tester) async {
    await tester.pumpWidget(ConnectivityAppWrapper(
      app: Builder(builder: (context) {
        Provider.of<ConnectivityStatus>(context);
        return const SizedBox();
      }),
    ));
    expect(ConnectivityWrapper.instance.hasListeners, isTrue);

    await tester.pumpWidget(const SizedBox());
    expect(ConnectivityWrapper.instance.hasListeners, isFalse);

    // Let the in-flight check time out; no new poll may be scheduled after.
    await tester.pump(const Duration(seconds: 11));
  });
}
