import 'package:flutter/material.dart';

class HowToUseOffline extends StatelessWidget {

  static const routeName = '/how-to-use-offline';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("How to use offline mode"),
      ),
      body: new Image.asset(
        'assets/images/steps_offline.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}