import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:vigilanteApp/screens/login_screen.dart';
import 'package:vigilanteApp/screens/how_to_use_offline.dart';
import 'package:vigilanteApp/screens/how_to_use_online.dart';

// import '../screens/rate_us_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/how_to_use_offline.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0,30,20,10),
            alignment: Alignment.centerLeft,
            // color: Theme.of(context).primaryColor,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                // backgroundImage: AssetImage('assets/images/logo.png'),
                // backgroundColor: Theme.of(context).canvasColor,
                // minRadius: 10,
                // maxRadius: 35,
              ),
              title: Text(
                'Vigilanté',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          // Container(
          //   height: 100,
          //   width: double.infinity,
          //   padding: EdgeInsets.all(20),
          //   alignment: Alignment.center,
          //   child: CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/pp.jpg'),
          //     backgroundColor: Theme.of(context).canvasColor,
          //     radius: 35.0,
          //   ),
          // ),
          SizedBox(height: 50,),
          FutureBuilder(
            future: FlutterSession().get('token'),
            builder: (context,snapshot){
              return SizedBox(
                height: 20,
                child: Text( snapshot.hasData ?
                  snapshot.data : 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400, 
                    
                  ),
                ),
              );
            },
          ),
          
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.accountCog,
          //     size: 26,
          //   ),
          //   title: Text(
          //     'Account Settings',
          //     style: TextStyle(
          //       fontSize: 16,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed(SettingsScreen.routeName);
          //   },
          // ),
          Divider(),

          ListTile(
            leading: Icon(
              MdiIcons.headQuestion,
              size: 26,
            ),
            title: Text(
              'How to Use Vigilante',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    // title: Text("Are you sure you want to log out?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Icon(
                            Icons.help_outline,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: new Icon(
                                MdiIcons.wifiCheck,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ), 
                              onPressed: () {
                                Navigator.of(context).pushNamed(HowToUseOnline.routeName);
                              }
                            ),
                            IconButton(
                              icon: new Icon(
                                MdiIcons.wifiOff,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ), 
                              onPressed: (){
                                Navigator.of(context).pushNamed(HowToUseOffline.routeName);
                              }
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Online'),
                            Text('Offline'),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel')
                      ),
                    ],
                  );
                }
              );
            },
          ),
          Divider(),
          SizedBox(
            height: 170,
          ),
          
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 26,
            ),
            title: Text(
              'Log out',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    // title: Text("Are you sure you want to log out?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Icon(
                            Icons.help_outline,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                        Text("Do you want to log out?"),
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          FlutterSession().set('token','');
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                            (Route route) => false,
                          );
                        }, 
                        child: Text(
                          'Yes'
                        )
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('No')
                      ),
                    ],
                  );
                });
              
            },
          ),
        ],
      ),
    );
  }
}
