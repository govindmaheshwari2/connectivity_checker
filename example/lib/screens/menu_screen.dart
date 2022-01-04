import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:connectivity_wrapper_example/screens/scaffold_example_screen.dart';
import 'package:connectivity_wrapper_example/utils/strings.dart';
import 'package:connectivity_wrapper_example/utils/utils.dart';
import 'package:flutter/material.dart';

import 'custom_offline_widget_screen.dart';
import 'network_aware_widget_screen.dart';

class MenuScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Connectivity Wrapper Example"),
      ),
      body: ConnectivityScreenWrapper(
        disableInteraction: true,
        disableWidget: Container(
          color: Colors.red.withOpacity(0.3),
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(Strings.example1),
              onTap: () async {
                AppRoutes.push(context, ScaffoldExampleScreen());
              },
            ),
            Divider(),
            ListTile(
              title: Text(Strings.example2),
              onTap: () {
                AppRoutes.push(context, CustomOfflineWidgetScreen());
              },
            ),
            Divider(),
            ListTile(
              title: Text(Strings.example3),
              onTap: () {
                AppRoutes.push(context, NetworkAwareWidgetScreen());
              },
            ),
            Divider(),
            ListTile(
              title: Text(Strings.example4),
              onTap: () async {
                if (await ConnectivityWrapper.instance.isConnected) {
                  showSnackBar(
                    context,
                    title: "You Are Connected",
                    color: Colors.green,
                  );
                } else {
                  showSnackBar(
                    context,
                    title: "You Are Not Connected",
                  );
                }
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
