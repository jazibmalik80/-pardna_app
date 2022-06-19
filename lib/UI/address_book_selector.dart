// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/participant_detail_page.dart';
import 'package:pardna_app/widgets/address_book_selector_tile.dart';

import 'add_new_participant.dart';

class AddressBookSelector extends StatefulWidget {
  final String singlePardnaID;
  const AddressBookSelector({Key? key, required this.singlePardnaID})
      : super(key: key);

  @override
  _AddressBookSelectorState createState() => _AddressBookSelectorState();
}

class _AddressBookSelectorState extends State<AddressBookSelector> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('participant')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewParticipant(
                pardnaID: null,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("DONE"),
        ),
      ),
      appBar: AppBar(
        title: Text('Add Participants to Pardna'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 14, 6, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder(
                  stream: _usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParticipantDetail(
                                    singleParticipant:
                                        snapshot.data!.docs.elementAt(index)),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              AddressBookSelectorTile(
                                singlePardnaID: widget.singlePardnaID,
                                singleParticipant:
                                    snapshot.data!.docs.elementAt(index),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
