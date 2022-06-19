// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/edit_participant_page.dart';

class ParticipantDetail extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singleParticipant;
  const ParticipantDetail({Key? key, required this.singleParticipant})
      : super(key: key);

  @override
  State<ParticipantDetail> createState() => _ParticipantDetailState();
}

class _ParticipantDetailState extends State<ParticipantDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${(widget.singleParticipant.data() as Map)['name']}"),
        actions: [
          IconButton(
            onPressed: () async {
              bool? wasDeleted = await showDeletePopup();
              if (wasDeleted ?? false) {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.delete_outline_outlined),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
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
                                "${(widget.singleParticipant.data() as Map)['name']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${(widget.singleParticipant.data() as Map)['email']}",
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
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditParticipant(
                                  singleParticipant: widget.singleParticipant),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 08),
            Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    color: Color(0xFF000000).withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 08),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color(0xFF000000).withOpacity(0.06),
              ),
              padding: EdgeInsets.fromLTRB(16, 16, 6, 16),
              child: Row(
                children: [
                  Text("${(widget.singleParticipant.data() as Map)['name']}"),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Color(0xFF000000).withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 08),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color(0xFF000000).withOpacity(0.06),
              ),
              padding: EdgeInsets.fromLTRB(16, 16, 6, 16),
              child: Row(
                children: [
                  Text(
                      "${(widget.singleParticipant.data() as Map)['phone_number']}"),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Email Address',
                  style: TextStyle(
                    color: Color(0xFF000000).withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 08),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color(0xFF000000).withOpacity(0.06),
              ),
              padding: EdgeInsets.fromLTRB(16, 16, 6, 16),
              child: Row(
                children: [
                  Text("${(widget.singleParticipant.data() as Map)['email']}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showDeletePopup() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Participant'),
        content: Text('Do you want to Delete this Participant?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              final snackBarDeleted =
                  SnackBar(content: Text('Participant Deleted Successfully'));
              final snackBarerrored =
                  SnackBar(content: Text('Something went wrong!'));

              final collection =
                  FirebaseFirestore.instance.collection('participant');
              collection.doc(widget.singleParticipant.id).delete().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(snackBarDeleted);
                Navigator.pop(context, true);
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(snackBarerrored);
              });
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
