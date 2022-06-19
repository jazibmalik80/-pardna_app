// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddressBookTile extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> singleParticipant;
  const AddressBookTile({Key? key, required this.singleParticipant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.account_circle),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(singleParticipant.data() as Map)['name'] ?? "No name"}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${(singleParticipant.data() as Map)['phone_number'] ?? "No phone"}",
                        style: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${(singleParticipant.data() as Map)['email'] ?? "No email"}",
                        style: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
