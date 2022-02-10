import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vigilanteApp/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:vigilanteApp/screens/verification.dart';
// import 'package:icon_shadow/icon_shadow.dart';

import './signup_details_screen.dart';
import './home_screen.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMe = false;
  bool _passwordVisible = true;
  String email;
  String password;

  // Map data1;
  // var id;
  // var phone;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    // getData();
    _passwordVisible = false;
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

  // Future getData() async{
  //   http.Response response = await http.get("http://vigilante.londonfoster.org/user_data.php?email=${emailController.text}");
  //   data1 = json.decode(response.body);
  //   print(data1['id'].toString());
  //   print(data1['contactNumber']);
  //   setState(() {
  //     id = data1['id'].toString();
  //     phone = data1['contactNumber'];
  //   });
  // }

  Future logIn() async{
    http.Response response1 = await http.get("http://vigilante.londonfoster.org/user_data.php?email=${emailController.text}");
    var data1 = json.decode(response1.body);
    var user_id = data1['id'].toString();
    var phone = data1['contactNumber'];

    var url = 'http://vigilante.londonfoster.org/login_user.php?email=${emailController.text}&password=${passwordController.text}';
    var response = await http.get(url);
    var data = json.decode(response.body);
    print(response.body);
    

    http.Response response2 = await http.post("http://vigilante.londonfoster.org/is_verified.php?user_id=$user_id");
    var verifiedData = json.decode(response2.body);
    print(response2.body);
    

    if(data == "Error"){
      toast("Invalid Username or Password!", Colors.red);
    }else if(data['status'] == "Success"){
      if(verifiedData == "Error"){

        toast("Kindly verify your account.", Colors.red);
        // Navigator.of(context).pushNamed(HomeScreen.routeName);
        var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
            new Verification(value: emailController.text,number: phone,),
        );
        Navigator.of(context).push(route);

      }else if(verifiedData == "Success"){

        await FlutterSession().set('token', emailController.text);

        toast("Login Successful", Colors.green);
        // Navigator.of(context).pushNamed(HomeScreen.routeName);
        var route1 = new MaterialPageRoute(
          builder: (BuildContext context) =>
            new HomeScreen(value: emailController.text),
        );
        Navigator.of(context).push(route1);
        
      }
    }else{
      toast("Please fill out information!", Colors.red);
    }
  }
  

Widget buildEmail(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius:6,
              offset: Offset(0,2)
            ),
          ],
        ),
        height: 60,
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value){
            if(value.isEmpty){
              return 'Please enter some text';
            }
          },
          onSaved: (value) => email = value,
          style: TextStyle(
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14, right: 45),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.teal,
            ),
            hintText: 'Enter your email',
          ),
        ),
      ),
    ],
  );
}

  Widget buildPassword(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius:6,
              offset: Offset(0,2)
            ),
          ],
        ),
        height: 60,
        child: TextField(
          controller: passwordController,
          obscureText: !_passwordVisible,
          style: TextStyle(
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.vpn_key,
              color: Colors.teal,
            ),
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black38.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              }
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget buildForgotPassBtn(){
//   return Container(
//     alignment: Alignment.centerRight,
//     child: FlatButton(
//       padding: EdgeInsets.only(right:0),
//       onPressed: () => print('Button Pressed'),
//       child: Text(
//         'Forgot Password?',
//         style: TextStyle(
//           color: Colors.black38.withOpacity(0.5),
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     ),
//   );
// }

Widget buildSignUpBtn(){
  return Container(
    alignment: Alignment.topRight,
    child: FlatButton(
      padding: EdgeInsets.only(right:0),
      onPressed: () {
        Navigator.of(context).pushNamed(SignupDetailsScreen.routeName);
      },
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

// Widget buildRememberCb(){
//   return Container(
//     height: 20,
//     child: Row(
//       children: <Widget>[
//         Theme(
//           data: ThemeData(unselectedWidgetColor: Colors.white),
//           child: Checkbox(
//             value: isRememberMe,
//             checkColor: Colors.green,
//             activeColor: Colors.white,
//             onChanged: (value) {
//               setState(() {
//                 isRememberMe = value;
//               });
//             },
//           ),
//         ),
//         Text(
//           'Remember Me',
//           style: TextStyle(
//             color: Colors.black38.withOpacity(0.5),
            
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget buildLoginBtn(){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: RaisedButton(
      elevation: 5,
      onPressed: () {
        logIn();
      },
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      color: Theme.of(context).primaryColor,
      child: Text(
        'LOGIN',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
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
                    buildSignUpBtn(),
                    SizedBox(
                      height: 160,
                      child: Image.asset(
                        'assets/images/logo_50.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Text(
                      'Vigilanté',
                      style: TextStyle(
                        color: Theme.of(context).canvasColor.withOpacity(1),
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 50,),
                    
                    buildEmail(),
                    SizedBox(height: 20,),
                    buildPassword(),
                    Row(
                      children: <Widget>[
                        // buildRememberCb(),
                        SizedBox(width: 45,),
                        // buildForgotPassBtn(),
                        
                      ],
                    ),
                    buildLoginBtn(),
                    
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}