import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/error/auth_exception.dart';
import 'package:shop_project/error/error_dialog.dart';
import 'package:shop_project/providers/auth_provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> {
  bool _isLoading = false;

  GlobalKey<FormState> _form = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void showErrorDialog({String msg}) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(error: msg),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) return;

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    AuthProvider auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
            email: _authData['email'], password: _authData['password']);
      } else {
        await auth.signup(
            email: _authData['email'], password: _authData['password']);
      }
    } on AuthException catch (error) {
      showErrorDialog(msg: error.toString());
    } catch (error) {
      showErrorDialog(msg: error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _authMode == AuthMode.Login ? 340 : 400,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid e-mail';
                  }

                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Invalid password.';
                  }

                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'The passwords are different.';
                          }

                          return null;
                        }
                      : null,
                ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryTextTheme.button.color),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                      )),
                  child: Text(
                    _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                  ),
                  onPressed: () => _submit(),
                ),
              TextButton(
                child: Text(
                  "${_authMode == AuthMode.Login ? 'New Here? Click Here (Register)' : 'Login'}",
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: _switchAuthMode,
              )
            ],
          ),
        ),
      ),
    );
  }
}
