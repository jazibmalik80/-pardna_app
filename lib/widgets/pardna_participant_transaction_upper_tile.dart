// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/single_participant_transaction_detail.dart';

class PardnaParticipantUpperTile extends StatefulWidget {
  const PardnaParticipantUpperTile({Key? key, required this.pardnaParticipant})
      : super(key: key);
  final DocumentSnapshot pardnaParticipant;

  @override
  State<PardnaParticipantUpperTile> createState() =>
      _PardnaParticipantUpperTileState();
}

class _PardnaParticipantUpperTileState
    extends State<PardnaParticipantUpperTile> {
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.account_circle),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (widget.pardnaParticipant.data() as Map)['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        (widget.pardnaParticipant.data()
                            as Map)['phone_number'],
                        style: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        (widget.pardnaParticipant.data() as Map)['email'],
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: PopupMenuButton(
                  color: Colors.white,
                  elevation: 20,
                  enabled: true,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text("Edit"),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: GestureDetector(
                        child: Text("Detail"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleParticipantTransactionDetail(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
