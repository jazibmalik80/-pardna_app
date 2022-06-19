// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 287,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                currentAccountPicture: CircleAvatar(),
                accountName: Text(
                  'Gunnar Anderson',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                accountEmail: Text(
                  'katlyn58@yahoo.com',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.receipt_long_outlined,
                color: Colors.grey[600],
              ),
              title: Text(
                'All Pardna',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.receipt_outlined,
                color: Colors.grey[600],
              ),
              title: Text(
                'All Transactions',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[600],
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.grey[600],
              ),
              title: Text(
                'Log out',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
