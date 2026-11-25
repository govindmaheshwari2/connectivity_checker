// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:connectivity_checker/connectivity_checker.dart';

void main() {
  test('closed port is unreachable', () async {
    final result = await ConnectivityWrapper.instance.isHostReachable(
      AddressCheckOptions(
        InternetAddress.loopbackIPv4,
        port: 1,
        timeout: const Duration(seconds: 1),
      ),
    );
    expect(result.isSuccess, isFalse);
  });

  test('open port is reachable', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final result = await ConnectivityWrapper.instance.isHostReachable(
      AddressCheckOptions(InternetAddress.loopbackIPv4, port: server.port),
    );
    await server.close();
    expect(result.isSuccess, isTrue);
  });
}
