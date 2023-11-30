/// A pure Dart utility library that checks for an internet connection
/// by opening a socket to a list of specified addresses, each with individual
/// port and timeout. Defaults are provided for convenience.
///
/// All addresses are pinged simultaneously.
/// On successful result (socket connection to address/port succeeds)
/// a true boolean is pushed to a list, on failure
/// (usually on timeout, default 10 sec)
/// a false boolean is pushed to the same list.
///
library connectivity_wrapper;

// Dart imports:
import 'dart:async';
import 'dart:io';

// Project imports:
import 'package:connectivity_checker/src/utils/constants.dart';

export 'package:connectivity_checker/src/widgets/connectivity_app_wrapper_widget.dart';
export 'package:connectivity_checker/src/widgets/connectivity_screen_wrapper.dart';
export 'package:connectivity_checker/src/widgets/connectivity_widget_wrapper.dart';

/// Connection Status Check Result
///
/// [CONNECTED]: Device connected to network
/// [DISCONNECTED]: Device not connected to any network
///
enum ConnectivityStatus { CONNECTED, DISCONNECTED }

class ConnectivityWrapper {
  static final List<AddressCheckOptions> _defaultAddresses = List.unmodifiable([
    AddressCheckOptions(
      InternetAddress('api.scrm.world.rugby'),
      port: DEFAULT_PORT,
      timeout: DEFAULT_TIMEOUT,
    ),
    AddressCheckOptions(
      InternetAddress('google.com'),
      port: DEFAULT_PORT,
      timeout: DEFAULT_TIMEOUT,
    ),
    AddressCheckOptions(
      InternetAddress('api.scrm.world.rugby'),
      port: 443,
      timeout: DEFAULT_TIMEOUT,
    ),
  ]);

  List<AddressCheckOptions> addresses = _defaultAddresses;

  ConnectivityWrapper._() {
    _statusController.onListen = () {
      _maybeEmitStatusUpdate();
    };
    _statusController.onCancel = () {
      _timerHandle?.cancel();
      _lastStatus = null;
    };
  }

  static final ConnectivityWrapper instance = ConnectivityWrapper._();

  Future<AddressCheckResult> isHostReachable(
    AddressCheckOptions options,
  ) async {
    if (options.port == DEFAULT_PORT) {
      final res = await InternetAddress.lookup(options.address.host,
          type: InternetAddressType.IPv4);
      return res.isNotEmpty
          ? AddressCheckResult(options, true)
          : AddressCheckResult(options, false);
    }

    Socket? sock;
    try {
      sock = await Socket.connect(
        options.address,
        options.port,
        timeout: options.timeout,
      );
      sock.destroy();
      return AddressCheckResult(options, true);
    } catch (e) {
      sock?.destroy();
      return AddressCheckResult(options, false);
    }
  }

  List<AddressCheckResult> get lastTryResults => _lastTryResults;
  List<AddressCheckResult> _lastTryResults = <AddressCheckResult>[];

  Future<bool> get isConnected async {
    List<Future<AddressCheckResult>> requests = [];

    for (var addressOptions in addresses) {
      requests.add(isHostReachable(addressOptions));
    }
    _lastTryResults = List.unmodifiable(await Future.wait(requests));

    return _lastTryResults.map((result) => result.isSuccess).contains(true);
  }

  Future<ConnectivityStatus> get connectionStatus async {
    return await isConnected
        ? ConnectivityStatus.CONNECTED
        : ConnectivityStatus.DISCONNECTED;
  }

  Duration checkInterval = DEFAULT_INTERVAL;

  _maybeEmitStatusUpdate([Timer? timer]) async {
    _timerHandle?.cancel();
    timer?.cancel();

    var currentStatus = await connectionStatus;

    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    if (!_statusController.hasListener) return;
    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    _lastStatus = currentStatus;
  }

  ConnectivityStatus? _lastStatus;
  Timer? _timerHandle;

  StreamController<ConnectivityStatus> _statusController =
      StreamController.broadcast();

  Stream<ConnectivityStatus> get onStatusChange => _statusController.stream;

  bool get hasListeners => _statusController.hasListener;

  bool get isActivelyChecking => _statusController.hasListener;

  ConnectivityStatus? get lastStatus => _lastStatus;
}

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

class AddressCheckResult {
  final AddressCheckOptions options;
  final bool isSuccess;

  AddressCheckResult(
    this.options,
    this.isSuccess,
  );

  @override
  String toString() => "AddressCheckResult($options, $isSuccess)";
}
