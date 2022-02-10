import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vigilanteApp/screens/home_screen.dart';


class Verification extends StatefulWidget {
  static const routeName = '/verification';
  final String value;
  final String number;

  Verification({Key key, this.value, this.number}) : super (key : key);
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  // Map data;
  // var id;
  // var contactNumber;
  // var verificationCode;
  // var userEmail;

  final codeController = TextEditingController();

  // Future getData() async{
  //   http.Response response = await http.get("http://vigilante.londonfoster.org/user_data.php?email=${widget.value}");
  //   data = json.decode(response.body);
  //   setState(() {
  //     verificationCode = data['verificationCode'].toString();
  //     contactNumber = data['contactNumber'].toString();
  //     userEmail = data['email'].toString();
  //   });
  //   print(data['verificationCode'].toString());
  //   print(data['userEmail'].toString());
  // }


  @override
  void dispose(){
    codeController.dispose();
    super.dispose();
  }

  Future<void> toast(String msg, Color color){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 12.0
    );
  }

  Widget buildVerifyBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          http.Response response = await http.get("http://vigilante.londonfoster.org/user_data.php?email=${widget.value}");
          var data = json.decode(response.body);
          var verificationCode = data['verificationCode'].toString();
          var user_id = data['id'].toString();
          print(codeController.text);
          print(verificationCode);

          if(codeController.text == verificationCode){
            var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
              new HomeScreen(value: widget.value,),
            );
            Navigator.of(context).push(route);
            toast("Your account is successfully verified.", Colors.green);
            http.Response response1 = await http.post("http://vigilante.londonfoster.org/update_verify.php?user_id=$user_id");
            json.decode(response1.body);
          }else{
            toast("Verification Failed", Colors.green);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        color: Theme.of(context).primaryColor,
        child: const Text(
          'VERIFY',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildBackBtn(){
    return Container(
      alignment: Alignment.topLeft,
      child: FlatButton(
        padding: const EdgeInsets.only(right:38),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Back',
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget buildCodeNumberBox(){
    return Container(
      padding: EdgeInsets.only(top:10),
      child: TextFormField(
        controller: codeController,
        decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[100]),
          borderRadius: BorderRadius.circular(17),
        ),
        labelText: "Enter code here",
        border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.teal[100],
                      Colors.teal[200],
                      Colors.teal[200],
                      Colors.teal[200],
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 50
                  ),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildBackBtn(),
                      SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            buildCodeNumberBox(),
                            Container(
                              child: Text(
                                "We sent verification code to ${widget.number}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildVerifyBtn(),
                    ],
                  ),
                ),
          ),
        ),
    );
  }
}