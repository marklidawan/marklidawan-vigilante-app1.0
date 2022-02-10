import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top:25, right:16),
        child: ListView(
          children: <Widget>[
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height:40,),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: 8,),
                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountSettingRow(context, 'Name'),
            buildAccountSettingRow(context, 'Email'),
            buildAccountSettingRow(context, 'Password'),
            buildAccountSettingRow(context, 'Address'),
            buildAccountSettingRow(context, 'Contact number'),
            buildAccountSettingRow(context, 'Emergency number'),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountSettingRow(BuildContext context, String title) {
    return GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text(title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title),
                        
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Close')
                      ),
                    ],
                  );
                });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
  }
}