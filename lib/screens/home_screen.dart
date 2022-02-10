import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:gps/gps.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';

import '../widgets/circle_painter.dart';
import '../widgets/curve_wave.dart';
import '../widgets/drawer.dart';



class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';
  final value;

  const HomeScreen({Key key, this.value, this.size = 80.0, this.color = Colors.red,
    this.onPressed, this.child,}) : super(key: key);
  final double size;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  GpsLatlng latlng;
  Map data;
  var id;
  var phone;

  Future getData() async{
    http.Response response = await http.get("http://vigilante.londonfoster.org/user_data.php?email=${widget.value}");
    data = json.decode(response.body);
    print(data['id'].toString());
    print(data['contactNumber']);
    setState(() {
      id = data['id'].toString();
      phone = data['contactNumber'];
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    getLocation();
    getData();
  }

  void getLocation() async {
    final gps = await Gps.currentGps();
    this.latlng = gps;
    setState(() {});
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
          .catchError((onError) {
          print(onError);
          toast("Report not successful!");
        });
    print(_result);
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }

  Future<void> toast(String msg){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12.0
    );
  }

  Widget _button() {
    
    List<String> recipients =["09658950924"];
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 25),
                color: Colors.red,
                textColor: Colors.white,
                shape: CircleBorder(
                  side: BorderSide.none
                ),
                child: Text('HELP', style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Icon(
                                MdiIcons.helpCircle,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ),
                            ),
                            Text("What type of emergency services do you need?"),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: new Icon(
                                    MdiIcons.policeBadge,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ), 
                                  onPressed: () async {
                                    getData();
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult == ConnectivityResult.wifi) {
                                        var coords1 = ('['+latlng.lat+','+latlng.lng+']'); 
                                        var coords = (coords1.toString());
                                        print("connected");
                                        var url = Uri.parse('http://vigilante.londonfoster.org/submit_report.php?emergency_type=police&coords=$coords&user_id=$id&connection_type=2');
                                        var response = await http.post(url);
                                        print(phone);
                                        print('Response status: ${response.statusCode}');
                                        print('Response body: ${response.body}');
                                        // print('Response body: ${response2.body}');
                                    }else{
                                      String message = "@$latlng@police@$id";
                                      _sendSMS(message.replaceAll(' ',''), recipients);
                                      toast("Click send if cellular signal is available!");
                                      print("no connection");
                                      print("Gps is: $latlng");
                                    }
                                    toast("Report successfully sent!");
                                    Navigator.of(context).pop();
                                  }
                                ),
                                IconButton(
                                  icon: new Icon(
                                    MdiIcons.hospitalBox,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ), 
                                  onPressed: ()async{
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult == ConnectivityResult.wifi) {
                                        var coords1 = ('['+latlng.lat+','+latlng.lng+']'); 
                                        var coords = (coords1.toString());
                                        print("connected");
                                        var url = Uri.parse('http://vigilante.londonfoster.org/submit_report.php?emergency_type=medical&coords=$coords&user_id=$id&connection_type=2');
                                        var response = await http.post(url);
                                        print('Response status: ${response.statusCode}');
                                        print('Response body: ${response.body}');
                                    }else{
                                      String message = "@$latlng@medical@$id";
                                      _sendSMS(message.replaceAll(' ',''), recipients);
                                      toast("Click send if cellular signal is available!");
                                      print("no connection");
                                      print("Gps is: $latlng");
                                    }
                                    toast("Report successfully sent!");
                                    Navigator.of(context).pop();
                                  }
                                ),
                                IconButton(
                                  icon: new Icon(
                                    MdiIcons.fire,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ), 
                                  onPressed: ()async{
                                    final connectivityResult = await Connectivity().checkConnectivity();
                                    if (connectivityResult == ConnectivityResult.wifi) {
                                        var coords1 = ('['+latlng.lat+','+latlng.lng+']');
                                        var coords = (coords1.toString());
                                        print("connected");
                                        var url = Uri.parse('http://vigilante.londonfoster.org/submit_report.php?emergency_type=fire&coords=$coords&user_id=$id&connection_type=2');
                                        var response = await http.post(url);
                                        print('Response status: ${response.statusCode}');
                                        print('Response body: ${response.body}');
                                    }else{
                                      String message = "@$latlng@fire@$id";
                                      _sendSMS(message.replaceAll(' ',''), recipients);
                                      toast("Click send if cellular signal is available!");
                                      print("no connection");
                                      print("Gps is: $latlng");
                                    }
                                    toast("Report successfully sent!");
                                    Navigator.of(context).pop();
                                  }
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Police'),
                                Text('Medical'),
                                Text('Fire'),
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
                }
              ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Keep safe!'),
      ),
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(
            _controller,
            color: widget.color,
          ),
          child: SizedBox(
            width: widget.size * 4.125,
            height: widget.size * 4.125,
            child: _button(),
          ),
        ),
      ),
    );
  }
}