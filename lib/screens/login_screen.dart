import 'package:blog_app/screens/forget_password.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = "", password = "";
  bool showSpinner = false;
  final _formkey = GlobalKey<FormState>();

  _saveForm() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email.toString().trim(),
            password: password.toString().trim());
        if (user != null) {
          setState(() {
            showSpinner = false;
          });
          print('success');
          toastMessage('Successfully Login!');
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => HomeScreen()));
      } catch (e) {
        print(e.toString());
        toastMessage(e.toString());
        setState(() {
          showSpinner = false;
        });
      }
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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Login'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Form(
                      key: _formkey,
                      child: Column(children: [
                        TextFormField(
                          onChanged: (val) {
                            email = val;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: 'name@gmail.com',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email)),
                          validator: (val) {
                            return val!.isEmpty ? 'Enter Email' : null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          onChanged: (val) {
                            password = val;
                          },
                          validator: (val) {
                            return val!.isEmpty ? 'Enter Password' : null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'more than 6 character',
                              prefixIcon: Icon(Icons.password)),
                        ),
                      ]),
                    ),
                  ),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgetPassword()));
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Forget Password ?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColor))),
                      ),
                    ),
                    RoundButton(
                        title: 'Login',
                        onPress: () {
                          _saveForm();
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                  ])
                ],
              ),
            )),
      ),
    );
  }
}
