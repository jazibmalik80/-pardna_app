// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PercentageBarCard extends StatefulWidget {
  const PercentageBarCard({Key? key}) : super(key: key);

  @override
  State<PercentageBarCard> createState() => _PercentageBarCardState();
}

class _PercentageBarCardState extends State<PercentageBarCard> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('pardna')
      .where("banker", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 10, 14, 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '''PARDNAS' PROGRESS''',
                  style: TextStyle(
                    color: Color(0xFF000000).withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            StreamBuilder(
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
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${(snapshot.data!.docs.elementAt(index).data() as Map)['name']}",
                                        style: TextStyle(
                                          color: Color(0xFF121212)
                                              .withOpacity(0.74),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      SizedBox(height: 04),
                                      LinearPercentIndicator(
                                        padding: EdgeInsets.all(0),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                200,
                                        animation: true,
                                        lineHeight: 12.0,
                                        animationDuration: 2500,
                                        percent: (double.parse(
                                              daysBetween(
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'start_date_internal'],
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'end_date_internal'],
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'payment_frequency'],
                                              ),
                                            ) /
                                            100),
                                        trailing: Row(
                                          children: [
                                            SizedBox(width: 16),
                                            Text(
                                              daysBetweenMessage(
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'start_date_internal'],
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'end_date_internal'],
                                                (snapshot.data!.docs
                                                        .elementAt(index)
                                                        .data() as Map)[
                                                    'payment_frequency'],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "(${daysBetween((snapshot.data!.docs.elementAt(index).data() as Map)['start_date_internal'], (snapshot.data!.docs.elementAt(index).data() as Map)['end_date_internal'], (snapshot.data!.docs.elementAt(index).data() as Map)['payment_frequency'])} %)",
                                              style: TextStyle(
                                                color: Color(0xFF121212)
                                                    .withOpacity(0.74),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                        barRadius: Radius.circular(10),
                                        progressColor: Colors.green,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                            ],
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      )
                    : Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.block,
                              color: Colors.grey,
                            ),
                            Text("You have not started any pardnas yet.")
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  String daysBetween(
      String startDate, String endDate, String paymentFrequency) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime nowDate = DateTime.now();
    if (paymentFrequency == "Weekly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.WEEK);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.WEEK);
      if (completed < 0) completed = 0;
      return ((completed / total) * 100).toStringAsFixed(0);
    } else if (paymentFrequency == "Monthly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.MONTH);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.MONTH);
      if (completed < 0) completed = 0;
      return ((completed / total) * 100).toStringAsFixed(0);
    } else if (paymentFrequency == "Yearly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.YEAR);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.YEAR);
      if (completed < 0) completed = 0;
      return ((completed / total) * 100).toStringAsFixed(0);
    }
    return "0";
  }

  String daysBetweenMessage(
      String startDate, String endDate, String paymentFrequency) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime nowDate = DateTime.now();
    if (paymentFrequency == "Weekly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.WEEK);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.WEEK);
      if (completed < 0) completed = 0;

      return "$completed / $total Weeks";
    } else if (paymentFrequency == "Monthly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.MONTH);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.MONTH);
      if (completed < 0) completed = 0;
      return "$completed / $total Months";
    } else if (paymentFrequency == "Yearly") {
      num total = Jiffy([end.year, end.month, end.day])
          .diff([start.year, start.month, start.day], Units.YEAR);
      num completed = Jiffy([nowDate.year, nowDate.month, nowDate.day])
          .diff([start.year, start.month, start.day], Units.YEAR);
      if (completed < 0) completed = 0;
      return "$completed / $total Years";
    }
    return "0";
  }
}
