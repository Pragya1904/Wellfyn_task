import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfyn_task/pages/signup_page.dart';

import '../components/rounded_button.dart';
import '../constants.dart';
import 'home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const id = "login_page";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool showSpinner = false;
  late User loggedInUser;
  late SharedPreferences loginData;
  bool newUser = false;
  // String pin='';
  // String email='';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    isLoggedIn();
    emailController.clear();
    pinController.clear();
  }

  void isLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('Login') ?? true);
    if (newUser == false) {
      Navigator.pushNamed(context, Home.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: height * 0.15,
                    child: Image.asset('images/logo.jpeg'),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Some Text";
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]")
                      .hasMatch(value)) {
                    return "Please enter a valid email";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  emailController.text = value!;
                },
                style: kButtonTextStyle,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "enter your email ID", labelText: "Email ID"),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                obscureText: true,
                controller: pinController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Some Text";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  pinController.text = value!;
                },
                style: kButtonTextStyle,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "enter your 4 digit pin", labelText: "Pin"),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RoundedButton1(
                  onPressed: () async {
                    setState(() {
                     // showSpinner = true;
                    });

                    // authentication
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: "00${pinController.text}");
                      if (user != null) {
                        loginData.setBool('login', false);
                        loginData.setString('email', emailController.text);
                        Navigator.pushNamed(context, Home.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                      if (e is FirebaseAuthException &&
                          e.code == 'wrong-password') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Login Failed"),
                              content: Text(
                                  "Invalid username or password. Please try again."),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    emailController.clear();
                                    pinController.clear();
                                    showSpinner = false;
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print("Unhandled Exception: $e");
                      }
                    }
                  },
                  title1: "Log in",
                  colour: primaryColor),
              SizedBox(
                height: height * 0.001,
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not a User?",
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () {
                        /*go to signup screen*/
                        Navigator.popAndPushNamed(context, SignUp.id);
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: primaryColor),
                      ))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }
}
