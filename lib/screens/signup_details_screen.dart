import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:vigilanteApp/screens/home_screen.dart';
import 'package:vigilanteApp/screens/verification.dart';


class SignupDetailsScreen extends StatefulWidget {
  static const routeName = '/signup_details_screen';

  @override
  _SignupScreenDetailsState createState() => _SignupScreenDetailsState();
}


class _SignupScreenDetailsState extends State<SignupDetailsScreen> {
  
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  String id;
  String email;
  String password;
  String fname;
  String mname;
  String lname;
  String address;
  String contactNo;
  String emergencyNo;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final lnameController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final genderController = TextEditingController();
  // final reEnterPasswordController = TextEditingController();
  // final emergencyNumberController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    fnameController.dispose();
    mnameController.dispose();
    lnameController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    genderController.dispose();
    // reEnterPasswordController.dispose();
    // emergencyNumberController.dispose();
    super.dispose();
  }

  @override
  void initState(){
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

  Future signUp() async{
    var url = Uri.parse('http://vigilante.londonfoster.org/add_user.php?email=${emailController.text}&password=${passwordController.text}&fname=${fnameController.text}&mname=${mnameController.text}&lname=${lnameController.text}&gender=${genderController.text}&address=${addressController.text}&contact_number=${contactNumberController.text}&emergency_number=1');
    var response = await http.post(url);
    var data = json.decode(response.body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(data == "Error"){
      toast("Exist!", Colors.red);
    }else if(emailController.text.isEmpty ?? true){
      toast("Fill up!", Colors.red);
    }else if(data['status'] == "Success"){
      await FlutterSession().set('token', emailController.text);
      toast("Kindly verify your account", Colors.green);
      // Navigator.of(context).pushNamed(HomeScreen.routeName);
      var route = new MaterialPageRoute(
        builder: (BuildContext context) =>
          new Verification(value: emailController.text,number: contactNumberController.text,),
      );
      Navigator.of(context).push(route);
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
        child: TextFormField(
          controller: passwordController,
          validator: (value){
            if(value.isEmpty){
              return 'Please enter some text';
            }
          },
          onSaved: (value) => password = value,
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

// Widget buildReEnterPassword(){
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Container(
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius:6,
//               offset: Offset(0,2)
//             ),
//           ],
//         ),
//         height: 60,
//         child: TextField(
//           controller: reEnterPasswordController,
//           obscureText: !_passwordVisible,
//           style: TextStyle(
//             color: Colors.black87,
//           ),
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.only(top: 14),
//             prefixIcon: Icon(
//               Icons.vpn_key,
//               color: Colors.teal,
//             ),
//             hintText: 'Re-enter password',
//             hintStyle: TextStyle(
//               fontSize: 16,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 _passwordVisible ? Icons.visibility : Icons.visibility_off,
//                 color: Colors.black38.withOpacity(0.5),
//               ),
//               onPressed: () {
//                 setState(() {
//                   _passwordVisible = !_passwordVisible;
//                 });
//               }
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget buildFname(){
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
          controller: fnameController,
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
              MdiIcons.accountQuestion,
              color: Colors.teal,
            ),
            hintText: 'First Name',
          ),
        ),
      ),
    ],
  );
}

Widget buildMname(){
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
          controller: mnameController,
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
              MdiIcons.accountQuestion,
              color: Colors.teal,
            ),
            hintText: 'Middle Name',
          ),
        ),
      ),
    ],
  );
}

Widget buildLname(){
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
          controller: lnameController,
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
              MdiIcons.accountQuestion,
              color: Colors.teal,
            ),
            hintText: 'Last Name',
          ),
        ),
      ),
    ],
  );
}

Widget buildAddress(){
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
          controller: addressController,
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
              MdiIcons.home,
              color: Colors.teal,
            ),
            hintText: 'Address',
          ),
        ),
      ),
    ],
  );
}

Widget buildContactNo(){
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
          controller: contactNumberController,
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
              MdiIcons.cellphone,
              color: Colors.teal,
            ),
            hintText: 'Contact Number',
          ),
        ),
      ),
    ],
  );
}

Widget buildGender(){
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
          controller: genderController,
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
              MdiIcons.accountBox,
              color: Colors.teal,
            ),
            hintText: 'Gender',
          ),
        ),
      ),
    ],
  );
}

// Widget buildEmergencyNumber(){
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Container(
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius:6,
//               offset: Offset(0,2)
//             ),
//           ],
//         ),
//         height: 60,
//         child: TextFormField(
//           controller: emergencyNumberController,
//           keyboardType: TextInputType.emailAddress,
//           validator: (value){
//             if(value.isEmpty){
//               return 'Please enter some text';
//             }
//           },
//           onSaved: (value) => email = value,
//           style: TextStyle(
//             color: Colors.black87,
//           ),
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.only(top: 14, right: 45),
//             prefixIcon: Icon(
//               MdiIcons.accountBox,
//               color: Colors.teal,
//             ),
//             hintText: 'Emergency Number',
//           ),
//         ),
//       ),
//     ],
//   );
// }

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
                        buildBackBtn(),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Enter details',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        const Divider(
                          // color: Colors.black87,
                          height: 15,
                          thickness: 2,
                          indent: 0,
                          endIndent: 0,
                        ),
                        Form(
                          key: _formKey,
                          child: new Column(
                            // shrinkWrap: true,
                            children: <Widget>[
                              buildEmail(),
                              SizedBox(height: 20,),
                              buildPassword(),
                              // SizedBox(height: 20,),
                              // buildReEnterPassword(),
                              SizedBox(height: 20,),
                              buildFname(),
                              SizedBox(height: 20,),
                              buildMname(),
                              SizedBox(height: 20,),
                              buildLname(),
                              SizedBox(height: 20,),
                              buildGender(),
                              SizedBox(height: 20,),
                              buildAddress(),
                              SizedBox(height: 20,),
                              buildContactNo(),
                              SizedBox(height: 20,),
                              // buildEmergencyNumber(),
                              
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 25),
                                width: double.infinity,
                                child: RaisedButton(
                                  elevation: 5,
                                  onPressed: () async {
                                    signUp();
                                  },
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  child: const Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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