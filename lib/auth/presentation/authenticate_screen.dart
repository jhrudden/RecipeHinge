import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';

class AuthenticateScreen extends StatefulWidget {
  AuthenticateScreen({Key key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  // bool used to toggle between login and sign up page
  bool _viewToggled = true;

  // switch the _viewToggled bool
  void toggleView() {
    setState(() => _viewToggled = !_viewToggled);
  }

  @override
  Widget build(BuildContext context) {
    if (_viewToggled) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
