import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wellfyn_task/pages/home_page.dart';
import 'package:wellfyn_task/pages/login_page.dart';
import 'package:wellfyn_task/pages/signup_page.dart';

import 'constants.dart';
final auth=FirebaseAuth.instance;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:  ColorScheme.fromSeed(seedColor:  primaryColor,primary: primaryColor),
        //appBarTheme: const AppBarTheme(backgroundColor: Color(0xff241370)),

      ),
      initialRoute: auth.currentUser==null?Login.id: Home.id,
      routes: {
        Home.id:(context)=>const Home(),
        Login.id:(context)=>const Login(),
        SignUp.id:(context)=>const SignUp(),
      },
    );
  }
}
