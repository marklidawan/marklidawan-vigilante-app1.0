import 'package:flutter/material.dart';

class HowToUseOnline extends StatelessWidget {
  static const routeName = '/how-to-use-online';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("How to use online mode"),
      ),
      body: new Image.asset(
        'assets/images/steps_online.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}