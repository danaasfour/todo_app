import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/views/screens/home_screen.dart';
import 'package:todoa_app/views/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isInvisible = true;
  late String _email, _password;

  _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final response = await Provider.of<DatabaseProvider>(context, listen: false)
        .login(_email, _password);
    if (response['result']) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(response['msg']),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ],
              ));
    }
  }

  bool _isValid(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                25, MediaQuery.of(context).padding.top + 50, 25, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Hello',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('Sign into you account',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 80),
                  TextFormField(
                    onSaved: (value) {
                      _email = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Email address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!_isValid(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _isInvisible,
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isInvisible = !_isInvisible;
                              });
                            },
                            icon: _isInvisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {},
                        child: const Text('Forget Password?')),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _login,
                        child: const Text('LOG IN',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google.png', height: 25),
                          const SizedBox(width: 10),
                          Text('Sign in with Google',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                  const SizedBox(height: 80),
                  const Text('Don\'t have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(SignUpScreen.route),
                      child: const Text('REGISTER')),
                ],
              ),
            )),
      ),
    );
  }
}
