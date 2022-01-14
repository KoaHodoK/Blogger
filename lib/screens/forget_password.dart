import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  String email = "";
  bool showSpinner = false;
  final _formkey = GlobalKey<FormState>();

  _saveForm() async {
    setState(() {
      showSpinner = true;
    });
    try {
      _auth
          .sendPasswordResetEmail(email: emailController.text.toString())
          .then((value) {
        toastMessage('Please check your email to reset password..');
        setState(() {
          showSpinner = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }).onError((error, stackTrace) {
        toastMessage(error.toString());
        setState(() {
          showSpinner = false;
        });
      });
    } catch (e) {
      print(e.toString());
      toastMessage(e.toString());
    }
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Rest Password'.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black),
          ),
        ),
      ),
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
                    validator: (val) {
                      return val!.isEmpty ? 'Enter email' : null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'name@gmail.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundButton(
                      title: 'Recover Password',
                      onPress: () {
                        _saveForm();
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
