import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import '../infrastructure/authentication_service.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // for resetting password
  String _email = '';

  // for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // test controller
  TextEditingController _emailContoller = TextEditingController();

  /// check if given email is in the correct format
  final Function(String) _emailValidator = (String value) => MultiValidator([
        RequiredValidator(errorText: 'email is required'),
        EmailValidator(errorText: 'enter a valid email address')
      ]).call(value.trim());

  /// create email input box
  Widget _buildEmail() {
    return TextFormField(
      controller: _emailContoller,
      decoration: InputDecoration(
          labelText: 'Email', labelStyle: TextStyle(color: Colors.grey)),
      onSaved: (String value) {
        _email = value.trim();
      },
      validator: _emailValidator,
    );
  }

  /// Widget Button, which if given a valid email, sends a password reset email
  /// to the input email address
  Widget _buildResetPassButton(BuildContext context) {
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
            'Reset Password',
            style: TextStyle(fontSize: 20),
          ),
        ),
        onTap: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _emailContoller.clear();
            print(_email);
            await context.read<AuthenticationService>().resetPassword(
                  email: _email,
                );
          }
          _emailContoller.clear();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.arrow_downward)),
        body: Stack(
          children: [
            Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Reset Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Enter the email address you signed up with. We'll email you a link to log in and reset your password.",
                          style: TextStyle(fontSize: 12),
                        ),
                        _buildEmail(),
                        SizedBox(height: 40),
                        _buildResetPassButton(context)
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
