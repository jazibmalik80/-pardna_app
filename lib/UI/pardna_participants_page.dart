// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/participant_transaction_history_page.dart';
import 'package:pardna_app/widgets/participant_tile.dart';

class PardnaParticipantsPage extends StatelessWidget {
  const PardnaParticipantsPage({Key? key, required this.singlePardna})
      : super(key: key);

  final DocumentSnapshot singlePardna;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 06, 0, 14),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("pardna_participant")
              .where("pardna", isEqualTo: singlePardna.id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                // CustomSearchBar(searchBarName: "Participants"),
                SizedBox(height: 16),
                Row(
                  children: [
                    Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Color(0xFF029247).withOpacity(0.06),
                      label: Text(
                        'Total Participants: ${snapshot.data?.docs.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Visibility(
                  visible: snapshot.data!.docs.isNotEmpty,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ParticipantTransactionHistory(
                                singlePardna: singlePardna,
                                pardnaParticipant:
                                    snapshot.data!.docs.elementAt(index),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ParticipantTile(
                                singlePardna: singlePardna,
                                pardnaParticipant:
                                    snapshot.data!.docs.elementAt(index)),
                            Divider(),
                          ],
                        ),
                      );
                    },
                    itemCount: snapshot.data?.docs.length,
                  ),
                ),
                Visibility(
                    visible: snapshot.data!.docs.isEmpty,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.block,
                            color: Colors.grey,
                          ),
                          Text("Participant list is empty")
                        ],
                      ),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
