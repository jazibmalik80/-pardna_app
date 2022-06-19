// ignore_for_file: implementation_imports, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pardna_app/UI/homepage_drawer.dart';
import 'package:pardna_app/UI/loginpage.dart';
import 'package:pardna_app/core/services/authentication_service.dart';
import 'package:pardna_app/widgets/homepage_overview_card.dart';
import 'package:pardna_app/widgets/homepage_percent_bar_card.dart';
import 'package:provider/src/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Pardna App'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await context.read<AuthenticationService>().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 14, 10, 14),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    ' Hello, Banker! 👋🏼',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 08),
              Row(
                children: [
                  Text(
                    ' Welcome to Pardna Portal.',
                    style: TextStyle(
                      color: Color(0xFF000000).withOpacity(0.74),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              HompageOverViewCard(),
              SizedBox(height: 24),
              PercentageBarCard(),
            ],
          ),
        ),
      ),
    );
  }
}
