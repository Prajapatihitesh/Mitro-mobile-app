import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mark_1/login.dart';

import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
bool _isloader = false;

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  void Formvalidation(){
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isloader = true;
      });
      register();
    }
  }
  Future register() async {
    // var link = "http://192.168.1.49/Flutter_api/Registration.php";
    var link = "https://mitro-college-project.000webhostapp.com/Api/Registration.php";




    final Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      "fname": _fname.text,
      "lname": _lname.text,
      "username": _email.text,
      "password": _pass.text,
      "confirm_password": _cpass.text,
    }).timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        setState(() {
        _isloader = false;
      });
        return jsonDecode('Error');

      },
    );


    var data = jsonDecode(response.body);
    if (data == "Error") {
      setState(() {
        _isloader = false;
      });
      Fluttertoast.showToast(
          msg: "This user already Exit!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "password not same") {
      setState(() {
        _isloader = false;
      });
      Fluttertoast.showToast(
          msg: "Confirm Password and Password are not same",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "connection issue") {
      setState(() {
        _isloader = false;
      });
      Fluttertoast.showToast(
          msg: "network issue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "success") {
      setState(() {
        _isloader = false;
      });
      Fluttertoast.showToast(
          msg: "Registration successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MyLogin(),
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

          ModalRoute.withName("/login")
      );
    } else {
      setState(() {
        _isloader = false;
      });
      Fluttertoast.showToast(
          msg: "undefined problem",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloader == false ?
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(

          color: Colors.black,
          size: 30,
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0,
                    right: 35,
                    left: 35,
                    bottom: 50),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 150, child: Image.asset('assets/MITRO.png')),
                    ),
                    const Text(
                      'Registration',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 33,
                          fontWeight: FontWeight.bold),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _fname,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Data Are Not Empty"),

                            ]) 
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _lname,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                            ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Data Are Not Empty"),
                              ])
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))
                            ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Data Are Not Empty"),
                                EmailValidator(errorText: "Not Valid Email Format"),
                              ])
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Data Are Not Empty"),
                              ])
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _cpass,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                labelText: 'Confirm Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Data Are Not Empty"),
                              ])
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
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
                          Container(
                            padding: const EdgeInsets.only(
                                right: 25, top: 25, left: 25),
                            child: Row(
                              children: [
                                const Text(
                                  'Already have an account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0Xff4c505b),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => const MyLogin(),
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
                                        ModalRoute.withName("/login")
                                    );

                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 18,
                                      color: Color(0Xff4c505b),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
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
