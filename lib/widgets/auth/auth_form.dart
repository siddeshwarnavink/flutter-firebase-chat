import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function authHandler;
  final bool isLoading;

  AuthForm(this.authHandler, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      print(_userImageFile);
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.authHandler(_userEmail.trim(), _userPassword, _userName.trim(),
          _isLogin, _userImageFile, context);
    }
  }

  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Please enter a valid email address!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'E-mail address'),
                    onSaved: (val) {
                      _userEmail = val;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return 'Username must be atleast 4 characters long!';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userName = val;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Password must be atleast 7 characters long!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userPassword = val;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(_isLogin ? 'Login' : 'Sign up'),
                          onPressed: _trySubmit,
                        ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'Already have an account?'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
