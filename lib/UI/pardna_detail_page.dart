// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pardna_app/UI/edit_pardna_page.dart';
import 'package:timelines/timelines.dart';

class PardnaDetailPage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singlePardna;
  const PardnaDetailPage({Key? key, required this.singlePardna})
      : super(key: key);

  @override
  State<PardnaDetailPage> createState() => _PardnaDetailPageState();
}

class _PardnaDetailPageState extends State<PardnaDetailPage> {
  num totalBankerExpected = 0;
  num totalBankerEarned = 0;
  num bankerHandAmount = 0;
  num pardnaParticipantCount = 0;
  QuerySnapshot<Map<String, dynamic>>? pardnaParticipants;
  QuerySnapshot<Map<String, dynamic>>? pardnaParticipantsForWithdraw;
  @override
  void initState() {
    super.initState();

    loadPardnaParticipants();
    loadPardnaParticipantForWithdraw();
  }

  void loadPardnaParticipants() {
    FirebaseFirestore.instance
        .collection("pardna_participant")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        pardnaParticipants = value;
        bankerHandAmount = num.parse(
                (widget.singlePardna.data() as Map)['contribution_amount']) /
            value.docs.length;
        pardnaParticipantCount = value.docs.length;
      }
      setState(() {});
    });
  }

  void loadPardnaParticipantForWithdraw() {
    FirebaseFirestore.instance
        .collection("pardna_participant")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .where("withdraw_status", isEqualTo: "Pending")
        .orderBy("name")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        pardnaParticipantsForWithdraw = value;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 34, 0, 0),
        child: Column(
          children: [
            Visibility(
              visible: pardnaParticipantsForWithdraw?.docs.isNotEmpty ?? false,
              child: ListTile(
                onTap: () {
                  if (pardnaParticipantsForWithdraw != null &&
                      pardnaParticipantsForWithdraw!.docs.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection("pardna_participant")
                        .doc(
                            pardnaParticipantsForWithdraw?.docs.elementAt(0).id)
                        .update({
                      'withdraw_status': "Done",
                      'withdraw_amount': (widget.singlePardna.data()
                          as Map)['contribution_amount'],
                      'withdraw_date': DateTime.now().toIso8601String(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ Withdraw Status Updated"),
                      ),
                    );
                    loadPardnaParticipantForWithdraw();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                trailing: Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Color(0xFF029247).withOpacity(0.06),
                  label: Text(
                    (pardnaParticipantsForWithdraw?.docs.first
                            .data())?['withdraw_status'] ??
                        "Unavailable",
                  ),
                ),
                tileColor: (pardnaParticipantsForWithdraw?.docs.first
                            .data())?['withdraw_status'] ==
                        "Done"
                    ? Colors.green.shade200
                    : Colors.orange.shade200,
                leading: Icon(Icons.upload),
                title: Text(
                    "${(pardnaParticipantsForWithdraw?.docs.first.data())?['name'] ?? "Participant Name"}"),
                subtitle: Text("Upcoming Withdraw"),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${(widget.singlePardna.data() as Map)['name']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Starts, ${(widget.singlePardna.data() as Map)['start_date']}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Finishes, ${(widget.singlePardna.data() as Map)['end_date']}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.repeat,
                        color: Colors.black.withOpacity(0.74),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "£ ${(widget.singlePardna.data() as Map)['contribution_amount']}/participant (${(widget.singlePardna.data() as Map)['payment_frequency']})",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.74),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.money,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Single Hand',
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "£ ${bankerHandAmount.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.summarize,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total (£${bankerHandAmount.toStringAsFixed(0)} Hand x ${calculateDuration((widget.singlePardna.data() as Map)['payment_frequency'], DateTime.parse((widget.singlePardna.data() as Map)['start_date_internal']), DateTime.parse((widget.singlePardna.data() as Map)['end_date_internal']))})',
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "£ ${(bankerHandAmount * calculateDurationInDouble((widget.singlePardna.data() as Map)['payment_frequency'], DateTime.parse((widget.singlePardna.data() as Map)['start_date_internal']), DateTime.parse((widget.singlePardna.data() as Map)['end_date_internal']))).toStringAsFixed(0)}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () async {
                          bool? wasDeleted = await showDeletePopup();
                          if (wasDeleted ?? false) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPardna(singlePardna: widget.singlePardna),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'TIMELINE',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            FixedTimeline(
              children: [
                Row(
                  children: [
                    DotIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Text(
                      "Start: ${(widget.singlePardna.data() as Map)['start_date']}",
                      maxLines: 2,
                    ))
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 7.5,
                    ),
                    SizedBox(
                      height: 30.0,
                      child: DashedLineConnector(
                        space: 0,
                        endIndent: 0,
                        gap: 0.5,
                        color: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DotIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Text(
                      "Duration: ${calculateDuration((widget.singlePardna.data() as Map)['payment_frequency'], DateTime.parse((widget.singlePardna.data() as Map)['start_date_internal']), DateTime.parse((widget.singlePardna.data() as Map)['end_date_internal']))}",
                      maxLines: 2,
                    ))
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 7.5,
                    ),
                    SizedBox(
                      height: 30.0,
                      child: DashedLineConnector(
                        space: 0,
                        endIndent: 0,
                        gap: 0.5,
                        color: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    DotIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Text(
                      "End: ${(widget.singlePardna.data() as Map)['end_date']}",
                      maxLines: 2,
                    ))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> showDeletePopup() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Pardna'),
        content: Text('Do you want to Delete this Pardna?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              final snackBarDeleted =
                  SnackBar(content: Text('Pardna Deleted Successfully'));
              final snackBarerrored =
                  SnackBar(content: Text('Something went wrong!'));

              final collection =
                  FirebaseFirestore.instance.collection('pardna');
              collection.doc(widget.singlePardna.id).delete().then((_) {
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

  String calculateDuration(String? paymentFrequencyValue,
      DateTime startSelectedDate, DateTime endSelectedDate) {
    if (paymentFrequencyValue != null) {
      if (paymentFrequencyValue == "Weekly") {
        return "${Jiffy([
              endSelectedDate.year,
              endSelectedDate.month,
              endSelectedDate.day
            ]).diff(Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]), Units.WEEK)} Weeks";
      } else if (paymentFrequencyValue == "Monthly") {
        return "${Jiffy([
              endSelectedDate.year,
              endSelectedDate.month,
              endSelectedDate.day
            ]).diff(Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]), Units.MONTH)} Months";
      } else if (paymentFrequencyValue == "Yearly") {
        return "${Jiffy([
              endSelectedDate.year,
              endSelectedDate.month,
              endSelectedDate.day
            ]).diff(Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]), Units.YEAR)} Years";
      } else {
        return "No duration specified yet.";
      }
    } else {
      return "No duration specified yet.";
    }
  }

  double calculateDurationInDouble(String? paymentFrequencyValue,
      DateTime startSelectedDate, DateTime endSelectedDate) {
    if (paymentFrequencyValue != null) {
      if (paymentFrequencyValue == "Weekly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ])
            .diff(
                Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]),
                Units.WEEK)
            .toDouble();
      } else if (paymentFrequencyValue == "Monthly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ])
            .diff(
                Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]),
                Units.MONTH)
            .toDouble();
      } else if (paymentFrequencyValue == "Yearly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ])
            .diff(
                Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]),
                Units.YEAR)
            .toDouble();
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }
}
