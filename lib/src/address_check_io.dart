// Dart imports:
import 'dart:io';

// Project imports:
import 'package:connectivity_checker/src/utils/constants.dart';

/// Android, iOS, macOS, Windows, Linux: opens a TCP socket to [address]:[port].
class AddressCheckOptions {
  final InternetAddress address;
  final int port;
  final Duration timeout;

  AddressCheckOptions(
    this.address, {
    this.port = DEFAULT_PORT,
    this.timeout = DEFAULT_TIMEOUT,
  });

  @override
  String toString() => "AddressCheckOptions($address, $port, $timeout)";
}

final List<AddressCheckOptions> defaultAddresses = List.unmodifiable([
  AddressCheckOptions(InternetAddress('1.1.1.1')),
  AddressCheckOptions(InternetAddress('8.8.4.4')),
  AddressCheckOptions(InternetAddress('208.67.222.222')),
]);

Future<bool> checkHost(AddressCheckOptions options) async {
  Socket? sock;
  try {
    sock = await Socket.connect(
      options.address,
      options.port,
      timeout: options.timeout,
    );
    return true;
  } catch (_) {
    return false;
  } finally {
    sock?.destroy();
  }
}
