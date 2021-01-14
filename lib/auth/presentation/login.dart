import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../../presentation/util/widgets/loading_page.dart';
import '../infrastructure/authentication_service.dart';
import 'password_reset.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleView;
  LoginScreen({Key key, @required this.toggleView}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Validaty of Login info
  bool _invalidPassOrUser = false;
  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  ]);
  final Function(String) _emailValidator = (String value) => MultiValidator([
        RequiredValidator(errorText: 'email is required'),
        EmailValidator(errorText: 'enter a valid email address')
      ]).call(value.trim());

  // text fields
  String _email;
  String _password;
  final TextEditingController _passControl = TextEditingController();

  // for form widget
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // for loading widget
  bool isLoading = false;

  /// create email input box
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      validator: _emailValidator,
      onSaved: (String value) {
        _email = value.trim();
      },
      onChanged: (String value) {
        if (_invalidPassOrUser) {
          setState(() => _invalidPassOrUser = false);
        }
      },
    );
  }

  /// build password input widget
  Widget _buildPassword() {
    return TextFormField(
      controller: _passControl,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: _passwordValidator,
      onSaved: (String value) {
        _password = value;
      },
      onChanged: (String value) {
        if (_invalidPassOrUser) {
          setState(() => _invalidPassOrUser = false);
        }
      },
    );
  }

  /// Widget Button, which logs user in if given email and password map to a
  /// valid user or prompts them to fix there username or password
  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
        child: Container(
          width: 150,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
              ]),
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20),
          ),
        ),
        onTap: () async {
          FocusScopeNode currentFocus = FocusScope.of(context);

          // if current button is selected then quit keyboard pop up
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }

          // validate that all textformFields have valid inputs
          if (_formKey.currentState.validate()) {
            setState(() => isLoading = true);
            _formKey.currentState.save();
            User signIn = await context
                .read<AuthenticationService>()
                .signInUserWithEmailAndPassword(
                  email: _email,
                  password: _password,
                );
            if (signIn == null) {
              setState(() {
                _invalidPassOrUser = true;
                isLoading = false;
              });
              _passControl.clear();
            }
          }
        });
  }

  /// Widget Button, which sends the user to the Signup Page
  Widget _buildSignUpButton() {
    return GestureDetector(
      child: Container(
        width: 150,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
            ]),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Sign up',
          style: TextStyle(fontSize: 20),
        ),
      ),
      onTap: widget.toggleView,
    );
  }

  /// Display an error text if either the password or username is invalid
  Widget _buildInvalidPassOrUser() {
    return Center(
        child: (_invalidPassOrUser)
            ? Text(
                'Invalid password or email',
                style: TextStyle(color: Colors.red),
              )
            : Container());
  }

  /// Reset password functionality
  Widget _buildResetPasswordButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerRight,
        height: 40,
        child: Text(
          'Forgot?',
          style: TextStyle(fontSize: 15),
        ),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 180),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Login',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  SizedBox(height: 20),
                  _buildEmail(),
                  _buildPassword(),
                  _buildResetPasswordButton(context),
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLoginButton(context),
                        _buildSignUpButton()
                      ]),
                  SizedBox(height: 40),
                  _buildInvalidPassOrUser()
                ],
              ),
            ),
          ),
        ),
        Opacity(
          child: (isLoading) ? LoadingPage() : Container(),
          opacity: 0.7,
        ),
      ],
    ));
  }
}
