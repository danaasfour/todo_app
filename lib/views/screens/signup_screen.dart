import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/views/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = '/signup';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordInvisible = true;
  bool _isConfirmPasswordInvisible = true;
  final _passwordController = TextEditingController();
  late String _name, _email, _password;

  bool _isValid(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final response = await Provider.of<DatabaseProvider>(context, listen: false)
        .signUp(_name, _email, _password);
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
                  const Text('Create your account',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.person_outline,
                            size: 100, color: Colors.indigo),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade300,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.indigo)),
                            child: const Icon(Icons.edit, color: Colors.indigo),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    onSaved: (value) {
                      _name = value!;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: 'Full name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                    onSaved: (value) {
                      _password = value!;
                    },
                    obscureText: _isPasswordInvisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordInvisible = !_isPasswordInvisible;
                              });
                            },
                            icon: _isPasswordInvisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: _isConfirmPasswordInvisible,
                    decoration: InputDecoration(
                        hintText: 'Confirm password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordInvisible =
                                    !_isConfirmPasswordInvisible;
                              });
                            },
                            icon: _isConfirmPasswordInvisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility))),
                    validator: (value) {
                      if (_passwordController.text != value) {
                        return 'Passwords don\'t match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _signUp,
                        child: const Text('SIGN UP',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Do you already have an account?',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}
