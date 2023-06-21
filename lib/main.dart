import 'package:flutter/material.dart';
import 'package:mark_1/login.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mark_1/register.dart';
void main(){
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
      MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes:{
      'login':(context)=>const MyLogin(),
      'register':(context)=>const MyRegister()
    },
  ));
}
