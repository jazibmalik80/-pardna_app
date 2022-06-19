// ignore_for_file: prefer_const_constructors, implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/loginpage.dart';
import 'package:pardna_app/core/services/authentication_service.dart';
import 'package:provider/src/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  bool obscureText = true;
  bool loading = false;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'PARDNA',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Image(
                  //   image: AssetImage(
                  //     'assets/pardna_logo.png',
                  //   ),
                  // ),
                  SizedBox(height: 25),
                  TextFormField(
                    autofocus: false,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    autofocus: false,
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      suffixIcon: obscureText == false
                          ? IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.grey[600],
                              ),
                              onPressed: toggle,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: toggle,
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    autofocus: false,
                    controller: cPasswordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      suffixIcon: obscureText == false
                          ? IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: Colors.grey[600],
                              ),
                              onPressed: toggle,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: toggle,
                            ),
                    ),
                  ),
                  SizedBox(height: 40),
                  loading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CupertinoButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (passwordController.text ==
                                cPasswordController.text) {
                              String? message = await context
                                  .read<AuthenticationService>()
                                  .signUp(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                              if (message == 'Sign up Successfull ✔') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$message')));
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginPage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$message')));
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Password does not match')));
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text('Sign Up'),
                          color: Colors.green,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          CupertinoButton(
            child: Text(
              'Log In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
            },
          ),
        ],
      ),
    );
  }
}
