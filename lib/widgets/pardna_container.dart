// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/add_new_participant.dart';
import 'package:pardna_app/UI/address_book_selector.dart';

class PardnaContainer extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singlePardna;
  const PardnaContainer({Key? key, required this.singlePardna})
      : super(key: key);

  @override
  State<PardnaContainer> createState() => _PardnaContainerState();
}

class _PardnaContainerState extends State<PardnaContainer> {
  int paymentsDue = 0;
  num bankerHandAmount = 0;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("pardna_participant_payment")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .where("payment_status", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          paymentsDue = value.docs.length;
        });
      }
    });

    FirebaseFirestore.instance
        .collection("pardna_participant")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        bankerHandAmount = num.parse(
                (widget.singlePardna.data() as Map)['contribution_amount']) /
            value.docs.length;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${(widget.singlePardna.data() as Map)['name']}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Chip(
                labelPadding: EdgeInsets.fromLTRB(4, -2, 4, -2),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Color(0xFFB00020).withOpacity(0.06),
                label: Text(
                  '$paymentsDue Payments Due',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB00020),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${(widget.singlePardna.data() as Map)['start_date']}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.repeat,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "£ ${(widget.singlePardna.data() as Map)['contribution_amount']} ${(widget.singlePardna.data() as Map)['payment_frequency']}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${(widget.singlePardna.data() as Map)['end_date']}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.money,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "£ ${bankerHandAmount.toStringAsFixed(0)} Hand",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Add Participant Options"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewParticipant(
                                    pardnaID: widget.singlePardna.id,
                                    pardnaName:
                                        "${(widget.singlePardna.data() as Map)['name']}",
                                  ),
                                ),
                              );
                            },
                            child: Text("1. Add participant details"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressBookSelector(
                                    singlePardnaID: widget.singlePardna.id,
                                  ),
                                ),
                              );
                            },
                            child:
                                Text("2. Choose from directory (recommended)"),
                          )
                        ],
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text(
                  'ADD NEW MEMBER',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
