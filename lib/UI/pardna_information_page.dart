// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pardna_app/UI/pardna_detail_page.dart';
import 'package:pardna_app/UI/pardna_participants_page.dart';

class PardnaInformationPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singlePardna;
  const PardnaInformationPage({Key? key, required this.singlePardna})
      : super(key: key);

  @override
  State<PardnaInformationPage> createState() => _PardnaInformationPageState();
}

class _PardnaInformationPageState extends State<PardnaInformationPage> {
  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(
            child: Text(
              'DETAIL',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Tab(
            child: Text(
              'PARTICIPANTS',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${(widget.singlePardna.data() as Map)['name']}"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: ColoredBox(
                  color: Colors.white,
                  child: _tabBar,
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: TabBarView(
                  children: [
                    PardnaDetailPage(singlePardna: widget.singlePardna),
                    PardnaParticipantsPage(
                      singlePardna: widget.singlePardna,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
