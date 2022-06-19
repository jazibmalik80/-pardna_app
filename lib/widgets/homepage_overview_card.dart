// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HompageOverViewCard extends StatelessWidget {
  HompageOverViewCard({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> _usersStreamPardnas = FirebaseFirestore.instance
      .collection('pardna')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  final Stream<QuerySnapshot> _usersStreamParticipant = FirebaseFirestore
      .instance
      .collection('participant')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 14, 14, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.green,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'OVERVIEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: _usersStreamPardnas,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error !!'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(14, 20, 14, 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.savings_outlined,
                                color: Colors.green,
                              ),
                              TextButton.icon(
                                label: Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.trending_up),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total Pardnas',
                                    style: TextStyle(
                                      color: Color(0xFF000000).withOpacity(0.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Card(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14, 20, 14, 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.savings,
                              color: Colors.green,
                            ),
                            TextButton.icon(
                              label: Text(
                                snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(Icons.trending_up),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total Pardnas',
                                  style: TextStyle(
                                    color: Color(0xFF000000).withOpacity(0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                    stream: _usersStreamParticipant,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error !!'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(08, 20, 08, 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.group,
                                  color: Colors.green,
                                ),
                                TextButton.icon(
                                  label: Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.trending_up),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total Participants',
                                      style: TextStyle(
                                        color:
                                            Color(0xFF000000).withOpacity(0.6),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(08, 20, 08, 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.group,
                                color: Colors.green,
                              ),
                              TextButton.icon(
                                label: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.trending_up),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total Participants',
                                    style: TextStyle(
                                      color: Color(0xFF000000).withOpacity(0.6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
