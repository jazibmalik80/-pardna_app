// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressBookSelectorTile extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singleParticipant;
  final String singlePardnaID;
  const AddressBookSelectorTile(
      {Key? key, required this.singleParticipant, required this.singlePardnaID})
      : super(key: key);

  @override
  State<AddressBookSelectorTile> createState() =>
      _AddressBookSelectorTileState();
}

class _AddressBookSelectorTileState extends State<AddressBookSelectorTile> {
  bool? isSelected = false;
  String? isAddedID = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("pardna_participant")
        .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("pardna", isEqualTo: widget.singlePardnaID)
        .where("email",
            isEqualTo: (widget.singleParticipant.data() as Map)['email'])
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          isAddedID = value.docs.first.id;
          isSelected = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Checkbox(
              value: isSelected,
              onChanged: (bool? checkbox) {
                setState(() {
                  isSelected = checkbox;
                });
                if (checkbox ?? false) {
                  addPardnaParticipant();
                } else {
                  removeAddedParticipant();
                }
              }),
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
                        "${(widget.singleParticipant.data() as Map)['name'] ?? "No name"}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${(widget.singleParticipant.data() as Map)['phone_number'] ?? "No phone"}",
                        style: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${(widget.singleParticipant.data() as Map)['email'] ?? "No email"}",
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

  void addPardnaParticipant() {
    FirebaseFirestore.instance.collection("pardna_participant").add({
      'banker': FirebaseAuth.instance.currentUser?.uid,
      'email': (widget.singleParticipant.data() as Map)['email'],
      'name': (widget.singleParticipant.data() as Map)['name'],
      'phone_number': (widget.singleParticipant.data() as Map)['phone_number'],
      'pardna': widget.singlePardnaID,
    }).then((value) {
      isAddedID = value.id;
    });
  }

  void removeAddedParticipant() {
    if (isAddedID != null && isAddedID!.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("pardna_participant")
          .doc(isAddedID)
          .delete();
    }
  }
}
