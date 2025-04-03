// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';

class AuthScreen
    extends
        StatefulWidget {
  const AuthScreen({
    super.key,
  });
  @override
  AuthScreenState createState() =>
      AuthScreenState();
}

class AuthScreenState
    extends
        State<
          AuthScreen
        > {
  final _formKey =
      GlobalKey<
        FormState
      >();
  bool _isLogin =
      true;

  String _email =
      '';
  String _password =
      '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Implement authentication logic
      if (true) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      appBar: AppBar(
        elevation:
            0,
        backgroundColor:
            Colors.transparent,
        title: Text(
          'Reviva Access',
          style: TextStyle(
            color:
                Colors.black87,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        centerTitle:
            true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                16.0,
              ),
              child: Card(
                elevation:
                    8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    24.0,
                  ),
                  child: Form(
                    key:
                        _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin
                              ? 'Welcome Back'
                              : 'Create Account',
                          style: TextStyle(
                            fontSize:
                                24,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(
                          height:
                              20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color:
                                  Colors.blue.shade600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            filled:
                                true,
                            fillColor:
                                Colors.blue.shade50,
                          ),
                          validator: (
                            value,
                          ) {
                            return value!.contains(
                                  '@',
                                )
                                ? null
                                : 'Invalid email';
                          },
                          onSaved:
                              (
                                value,
                              ) =>
                                  _email =
                                      value!,
                        ),
                        SizedBox(
                          height:
                              16,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color:
                                  Colors.blue.shade600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            filled:
                                true,
                            fillColor:
                                Colors.blue.shade50,
                          ),
                          obscureText:
                              true,
                          validator: (
                            value,
                          ) {
                            return value!.length >
                                    6
                                ? null
                                : 'Too short';
                          },
                          onSaved:
                              (
                                value,
                              ) =>
                                  _password =
                                      value!,
                        ),
                        SizedBox(
                          height:
                              20,
                        ),
                        ElevatedButton(
                          onPressed:
                              _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue.shade700,
                            minimumSize: Size(
                              double.infinity,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: Text(
                            _isLogin
                                ? 'Login'
                                : 'Sign Up',
                            style: TextStyle(
                              fontSize:
                                  16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              10,
                        ),
                        TextButton(
                          onPressed:
                              () => setState(
                                () =>
                                    _isLogin =
                                        !_isLogin,
                              ),
                          child: Text(
                            _isLogin
                                ? 'Create new account'
                                : 'Already have an account? Login',
                            style: TextStyle(
                              color:
                                  Colors.blue.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
