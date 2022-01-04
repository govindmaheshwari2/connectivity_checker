import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:connectivity_checker_example/utils/strings.dart';
import 'package:connectivity_checker_example/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkAwareWidgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.example3),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          PA5(),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
          ),
          PA5(),
          ConnectivityWidgetWrapper(
            stacked: false,
            offlineWidget: ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Connecting",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    PA5(),
                    CupertinoActivityIndicator(radius: 8.0),
                  ],
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
