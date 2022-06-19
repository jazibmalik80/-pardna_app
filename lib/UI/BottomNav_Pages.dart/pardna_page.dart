// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/add_new_pardna_page.dart';
import 'package:pardna_app/UI/pardna_information_page.dart';
import 'package:pardna_app/widgets/pardna_container.dart';

class PardnaPage extends StatefulWidget {
  const PardnaPage({Key? key}) : super(key: key);

  @override
  _PardnaPageState createState() => _PardnaPageState();
}

class _PardnaPageState extends State<PardnaPage> {
  Stream<QuerySnapshot> pardnaQuery = FirebaseFirestore.instance
      .collection('pardna')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Pardnas'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(4, 14, 4, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Expanded(
                  //   child: Card(
                  //     child: TextField(
                  //       onSubmitted: (String s) {
                  //         setState(() {});
                  //       },
                  //       controller: searchController,
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(16),
                  //         hintText: 'Search Pardna',
                  //         enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.grey),
                  //         ),
                  //         focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.grey),
                  //         ),
                  //         border: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.grey),
                  //         ),
                  //         suffixIcon: IconButton(
                  //           icon: Icon(Icons.search_outlined,
                  //               color: Colors.black.withOpacity(0.74)),
                  //           onPressed: () {},
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 6),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pardna')
                        .where("banker",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Color(0xFF029247).withOpacity(0.06),
                          label: Text(
                            'Total Pardnas: 0',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.green,
                            ),
                          ),
                        );
                      }
                      return Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(0xFF029247).withOpacity(0.06),
                        label: Text(
                          "Total Pardnas: ${snapshot.data!.docs.length.toString()}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('pardna')
                      .where("banker",
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
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
                                      builder: (context) =>
                                          PardnaInformationPage(
                                              singlePardna: snapshot.data!.docs
                                                  .elementAt(index)),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    PardnaContainer(
                                      singlePardna:
                                          snapshot.data!.docs.elementAt(index),
                                    ),
                                    SizedBox(height: 12),
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
                                Text("You have not started any Pardnas yet")
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
            MaterialPageRoute(builder: (context) => AddNewpardna()),
          );
        },
      ),
    );
  }
}
