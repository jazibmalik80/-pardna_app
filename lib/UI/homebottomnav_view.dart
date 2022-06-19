// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pardna_app/UI/BottomNav_Pages.dart/address_book_page.dart';
import 'package:pardna_app/UI/BottomNav_Pages.dart/homepage.dart';
import 'package:pardna_app/UI/BottomNav_Pages.dart/pardna_page.dart';

class HomeBottomNavView extends StatefulWidget {
  const HomeBottomNavView({Key? key}) : super(key: key);

  @override
  _HomeBottomNavViewState createState() => _HomeBottomNavViewState();
}

class _HomeBottomNavViewState extends State<HomeBottomNavView> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          Homepage(),
          PardnaPage(),
          AddressBookPage(),
        ],
        onPageChanged: onPageChange,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        onTap: itemTapped,
        currentIndex: selectedindex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Pardna',
            icon: Icon(Icons.savings),
          ),
          BottomNavigationBarItem(
            label: 'Address Book',
            icon: Icon(Icons.account_circle),
          ),
        ],
        selectedLabelStyle: TextStyle(color: Colors.green),
        unselectedLabelStyle: TextStyle(color: Color(0x99000000)),
        showSelectedLabels: true,
        unselectedItemColor: Color(0x99000000),
      ),
    );
  }

  PageController pageController = PageController();

  void onPageChange(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  void itemTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
  }
}
