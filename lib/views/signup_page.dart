import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wellfyn_task/views/login_page.dart';

import '../components/rounded_button.dart';
import '../constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const id = "signup_page";
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  RegExp passValid = RegExp(r"\d\d\d\d");
  double passwordStrength = 0;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool showSpinner = false;
  bool validatePassword(String pass) {
    String password = pass.trim();
    if (password.isEmpty) {
      setState(() {
        passwordStrength = 0.0;
      });
    } else if (password.length < 2) {
      setState(() {
        passwordStrength = 1 / 4;
      });
    } else if (password.length < 3) {
      setState(() {
        passwordStrength = 2 / 4;
      });
    } else if (password.length < 4) {
      setState(() {
        passwordStrength = 3 / 4;
      });
    } else if (password.length > 4) {
      setState(() {
        passwordStrength = 0 / 4;
      });
    } else if (password.length == 4) {
      if (passValid.hasMatch(password)) {
        setState(() {
          passwordStrength = 1;
        });
        return true;
      } else {
        setState(() {
          passwordStrength = 3 / 4;
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                  validator: emailValidator,
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                  style: kButtonTextStyle,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "enter email ID", labelText: "Email ID"),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  controller: pinController,
                  validator: pinValidator,
                  onSaved: (value) {
                    pinController.text = value!;
                  },
                  style: kButtonTextStyle,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "enter your Pin", labelText: "Pin"),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: LinearProgressIndicator(
                    value: passwordStrength,
                    minHeight: 5,
                    color: progressIndicatorColor(),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                RoundedButton1(
                  onPressed: () async {
                    await signUpBtnAction(context);
                  },
                  title1: "Sign Up",
                  colour: primaryColor,
                ),
                SizedBox(
                  height: height * 0.001,
                ),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already a user?",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                        onPressed: () {
                          /*go to login screen*/
                          Navigator.popAndPushNamed(context, Login.id);
                        },
                        child: const Text(
                          "Login",
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
      ),
    );
  }

  Future<void> signUpBtnAction(BuildContext context) async {
    setState(() {
       showSpinner=true;
    });
    try {
      validatePassword(pinController.text);
      if (_formkey.currentState!.validate()) {
        if (passwordStrength == 1) {
          setState(() {
            showSpinner = true;
          });
          final newUser = await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: "00${pinController.text}");
          if (kDebugMode) {
            print(newUser);
            print("*************************");
          }

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered succcefully!!")));
          if (kDebugMode) {
            print("user created");
          }
          Navigator.popAndPushNamed(context, Login.id);
        }
      }

      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Registration Failed"),
              content: const Text(
                  "The email is already in use. Please try again with a different email."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    emailController.clear();
                    pinController.clear();
                    showSpinner = false;
                    validatePassword(pinController.text);
                  },
                ),
              ],
            );
          },
        );
      } else {
        if (kDebugMode) {
          print("Error: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  MaterialColor progressIndicatorColor() => passwordStrength <= 1 / 4
      ? Colors.red
      : passwordStrength == 2 / 4
          ? Colors.yellow
          : passwordStrength == 3 / 4
              ? Colors.blue
              : Colors.green;

  String? pinValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Some Pin";
    } else {
      bool result = validatePassword(value);
      if (result) {
        return null;
      } else {
        return "Pin must be of length 4";
      }
    }
  }

  String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Some Text";
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
      return "Please enter a valid email";
    } else {
      return null;
    }
  }
}
