// ignore_for_file: prefer_const_constructors, implementation_imports

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/homebottomnav_view.dart';
import 'package:pardna_app/UI/signup_page.dart';
import 'package:pardna_app/core/services/authentication_service.dart';
import 'package:provider/src/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(height: 40),
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
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
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
                            String? message = await context
                                .read<AuthenticationService>()
                                .signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                            if (message == 'Successfully Logged In ✔') {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomeBottomNavView(),
                                ),
                                (Route<dynamic> route) => false,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$message')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$message')));
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text('Log In'),
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
            "Don't have an account?",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          CupertinoButton(
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => SignupPage(),
                ),
                (Route<dynamic> route) => false,
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SignupPage()),
              // );
            },
          ),
        ],
      ),
    );
  }
}
