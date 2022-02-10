import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

// screens
import './screens/signup_details_screen.dart';
import './screens/verification.dart';
import './screens/login_screen.dart';
import './screens/settings_screen.dart';
import './screens/home_screen.dart';
import './screens/how_to_use_offline.dart';
import './screens/how_to_use_online.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    dynamic token = FlutterSession().get('token');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.cyanAccent,
            canvasColor: Colors.teal[50].withOpacity(1),
            fontFamily: 'Poppins',
            textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              color: Theme.of(context).canvasColor,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
          home: token != '' ? LoginScreen() : HomeScreen(),
        // initialRoute: '/',
        routes: {
          SettingsScreen.routeName : (ctx) => SettingsScreen(),
          HomeScreen.routeName : (ctx) => HomeScreen(),
          LoginScreen.routeName : (ctx) => LoginScreen(),
          SignupDetailsScreen.routeName : (ctx) => SignupDetailsScreen(),
          Verification.routeName : (ctx) => Verification(),
          HowToUseOffline.routeName: (ctx) => HowToUseOffline(),
          HowToUseOnline.routeName: (ctx) => HowToUseOnline(),
        },
      );
    
  }
}