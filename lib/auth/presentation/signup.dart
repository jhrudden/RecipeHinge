import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../../presentation/util/widgets/loading_page.dart';
import '../infrastructure/authentication_service.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({Key key, @required this.toggleView}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  /// Signup strings
  String _email;
  String _password;
  String _displayName;

  /// used for error messages if email already exists
  bool _invalidEmail = false;

  /// for loading screen
  bool isLoading = false;

  /// checks if a given password is exits, is of length 8, and contains atleast
  /// 1 special character
  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  /// check if given email is in the correct format
  final Function(String) _emailValidator = (String value) => MultiValidator([
        RequiredValidator(errorText: 'email is required'),
        EmailValidator(errorText: 'enter a valid email address')
      ]).call(value.trim());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text Input Widget, create email input
  Widget _buildDisplayName() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Display Name',
      ),
      onSaved: (String value) {
        _displayName = value.trim();
      },
    );
  }

  /// Text Input Widget, create email input
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email',
          errorText: _invalidEmail ? "Email already in use" : null),
      validator: _emailValidator,
      onSaved: (String value) {
        _email = value.trim();
      },
      onChanged: (value) {
        if (_invalidEmail) {
          this.setState(() {
            _invalidEmail = false;
          });
        }
      },
    );
  }

  /// Text Input Widget, create password input
  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: _passwordValidator,
      onChanged: (String value) {
        _password = value;
      },
    );
  }

  /// Text Input Widget, confirm password input
  Widget _buildComfirmPassword() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: 'Confirm Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) => MatchValidator(
              errorText: 'Password needs to match confirmed password')
          .validateMatch(value, _password),
    );
  }

  /// Widget Button, Build signup button that intializes adding a user to
  /// database if input email, password, and confirmed password are valid
  _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 200,
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
      onTap: () async {
        FocusScopeNode currentFocus = FocusScope.of(context);

        // if current button is selected then quit keyboard pop up
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        /// check if all textformfields have valid inputs, if they do then get
        /// funky
        if (_formKey.currentState.validate()) {
          setState(() => isLoading = true);
          _formKey.currentState.save();
          User signUp = await context
              .read<AuthenticationService>()
              .registerUserWithEmailAndPassword(
                displayName: _displayName,
                email: _email,
                password: _password,
              );
          if (signUp == null) {
            setState(() {
              _invalidEmail = true;
              isLoading = false;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.south),
          onPressed: widget.toggleView,
        ),
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
                        child: Text('Sign Up',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      SizedBox(height: 20),
                      _buildDisplayName(),
                      _buildEmail(),
                      _buildPassword(),
                      _buildComfirmPassword(),
                      SizedBox(height: 40),
                      _buildSignUpButton(context)
                    ],
                  ),
                ),
              ),
            ),
            Opacity(
              child: (isLoading) ? LoadingPage() : Container(),
              opacity: 0.7,
            )
          ],
        ));
  }
}
