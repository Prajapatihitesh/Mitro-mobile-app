import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:mark_1/register.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mark_1/ButtomNavbar.dart';
import 'dart:convert';
bool  _isLoader = false;

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  // Class variables
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Class functions
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }
  void Formvalidation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = true;
      });
      login();
    }
  }
  // Online API call
  Future login() async {
    // var link = "http://192.168.1.49/Flutter_api/Login.php";
    var link = "https://mitro-college-project.000webhostapp.com/Api/Login.php";

    final Uri url = Uri.parse(link);

    var response = await http.post(url, body: {
      "username": _email.text,
      "password": _pass.text,
    });



    var data = jsonDecode(response.body);

    if (data == "Error") {
      setState(() {
        _isLoader = false;
      });
      Fluttertoast.showToast(
          msg: "Email or Password are Not Valid!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else if (data == "connection issue") {
      setState(() {
        _isLoader = false;
      });
      Fluttertoast.showToast(
          msg: "network issue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    else {
      setState(() {
        _isLoader = false;
      });

      Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

          var id = data[0]['User_Id'];

      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  ButtomNavbar(id:id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),

          ModalRoute.withName("/ButtomNavbar")
      );


    }
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoader == false ?
      Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.0,
                right: 35,
                left: 35),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                        height: 150, child: Image.asset('assets/MITRO.png')),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 33,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: MultiValidator([
                          EmailValidator(errorText: "Email are not Proper Formed"),
                          RequiredValidator(errorText: "Not Valid"),
                        ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _pass,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Not Valid"),
                        ]),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Color(0Xff4c505b),
                                fontSize: 27,
                                fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0Xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                Formvalidation();
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {

                                Navigator.pushAndRemoveUntil(
                                  context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const MyRegister(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),

                                  ModalRoute.withName("/register"),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Color(0Xff4c505b),
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                              },
                              child: const Text(
                                'Forget Password',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  color: Color(0Xff4c505b),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ):
    Scaffold(
    backgroundColor: Colors.white,
    body: Center(

    child: CircularProgressIndicator(),
    ),
    );
  }
}
