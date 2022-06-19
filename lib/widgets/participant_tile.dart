// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParticipantTile extends StatefulWidget {
  const ParticipantTile(
      {Key? key, required this.pardnaParticipant, required this.singlePardna})
      : super(key: key);
  final DocumentSnapshot pardnaParticipant;
  final DocumentSnapshot singlePardna;

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  int paymentsDue = 0;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("pardna_participant_payment")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .where("participant", isEqualTo: widget.pardnaParticipant.id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          if (!(element.data())['payment_status']) {
            paymentsDue++;
          }
        }
        setState(() {});
      }
    });
  }

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
                  CircleAvatar(
                    child: Icon(Icons.account_circle),
                  ),
                  SizedBox(width: 12),
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
                        'Phone: ${(widget.pardnaParticipant.data() as Map)['phone_number']}',
                        style: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.upload,
                            color: Colors.grey,
                          ),
                          Text(
                            (widget.pardnaParticipant.data()
                                    as Map)['withdraw_status'] ??
                                "Unavailable",
                            style: TextStyle(
                                color: (widget.pardnaParticipant.data()
                                            as Map)['withdraw_status'] ==
                                        "Done"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Text(
                '$paymentsDue Payments Due',
                style: TextStyle(
                  color: Color(0xFFB00020),
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
