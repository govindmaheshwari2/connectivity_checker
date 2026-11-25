// Dart imports:
import 'dart:js_interop';

// Project imports:
import 'package:connectivity_checker/src/utils/constants.dart';

@JS('fetch')
external JSPromise<JSAny?> _fetch(JSString url, JSAny init);

/// Web: browsers can't open raw sockets, so a `no-cors` HEAD request is sent
/// to [url]. Any response (even opaque) means reachable; a network error or
/// timeout means unreachable.
class AddressCheckOptions {
  final Uri url;
  final Duration timeout;

  AddressCheckOptions(this.url, {this.timeout = DEFAULT_TIMEOUT});

  @override
  String toString() => "AddressCheckOptions($url, $timeout)";
}

final List<AddressCheckOptions> defaultAddresses = List.unmodifiable([
  AddressCheckOptions(Uri.parse('https://one.one.one.one')),
  AddressCheckOptions(Uri.parse('https://www.google.com')),
]);

Future<bool> checkHost(AddressCheckOptions options) async {
  try {
    await _fetch(
      options.url.toString().toJS,
      {'method': 'HEAD', 'mode': 'no-cors', 'cache': 'no-store'}.jsify()!,
    ).toDart.timeout(options.timeout);
    return true;
  } catch (_) {
    return false;
  }
}
