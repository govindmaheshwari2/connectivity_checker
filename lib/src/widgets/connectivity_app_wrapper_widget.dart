// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:connectivity_checker/src/providers/connectivity_provider.dart';

///[ConnectivityAppWrapper] is a StatelessWidget.

class ConnectivityAppWrapper extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null
  final Widget app;

  const ConnectivityAppWrapper({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: ConnectivityStatus.CONNECTED,
      create: (context) => ConnectivityProvider().connectivityStream,
      child: app,
    );
  }
}
