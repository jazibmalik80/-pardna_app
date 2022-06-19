// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/add_new_participant.dart';
import 'package:pardna_app/UI/participant_detail_page.dart';
import 'package:pardna_app/widgets/address_book_tile.dart';
import 'package:pardna_app/widgets/custom_search_bar.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({Key? key}) : super(key: key);

  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('participant')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Directory'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 14, 6, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CustomSearchBar(searchBarName: "Participants"),
              SizedBox(height: 04),
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
                    return snapshot.data!.docs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParticipantDetail(
                                          singleParticipant: snapshot.data!.docs
                                              .elementAt(index)),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    AddressBookTile(
                                      singleParticipant:
                                          snapshot.data!.docs.elementAt(index),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.block,
                                  color: Colors.grey,
                                ),
                                Text("Address book is empty")
                              ],
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
    );
  }
}
