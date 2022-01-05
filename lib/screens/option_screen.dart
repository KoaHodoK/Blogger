import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/sign_in.dart';
import 'package:blog_app/widgets/round_button.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('images/blog_logo.png'),
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 40,
              ),
              RoundButton(title: 'Login', onPress: () {
                 Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => Login()));
              }),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'Register',
                  onPress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => SignIn()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
