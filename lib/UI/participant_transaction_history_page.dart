// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pardna_app/widgets/pardna_participant_transaction_upper_tile.dart';
import 'package:pardna_app/widgets/pardna_transaction_expired_date_tile.dart';

class ParticipantTransactionHistory extends StatefulWidget {
  const ParticipantTransactionHistory(
      {Key? key, required this.pardnaParticipant, required this.singlePardna})
      : super(key: key);

  final DocumentSnapshot pardnaParticipant;
  final DocumentSnapshot singlePardna;

  @override
  State<ParticipantTransactionHistory> createState() =>
      _ParticipantTransactionHistoryState();
}

class _ParticipantTransactionHistoryState
    extends State<ParticipantTransactionHistory> {
  late Stream<QuerySnapshot> participantInstallmentsStream;

  String selectedTransactionFilter = "All";
  String localWithdrawStatus = "Unavailable";

  @override
  void initState() {
    super.initState();
    localWithdrawStatus =
        (widget.pardnaParticipant.data() as Map)['withdraw_status'] ??
            "Unavailable";
    FirebaseFirestore.instance
        .collection("pardna_participant_payment")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .where("participant", isEqualTo: widget.pardnaParticipant.id)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        num duration = calculateDuration(
            (widget.singlePardna.data() as Map)['payment_frequency']);
        for (int i = 0; i < duration; i++) {
          FirebaseFirestore.instance
              .collection("pardna_participant_payment")
              .add({
            'pardna': widget.singlePardna.id,
            'participant': widget.pardnaParticipant.id,
            'installment': i,
            'id': "${widget.singlePardna.id}-${widget.pardnaParticipant.id}-$i",
            'payment_status': false,
            'expected_date': calculatePaymentDates(
                    (widget.singlePardna.data() as Map)['payment_frequency'], i)
                .toIso8601String()
          });
        }
      }
    });
    participantInstallmentsStream = FirebaseFirestore.instance
        .collection("pardna_participant_payment")
        .where("pardna", isEqualTo: widget.singlePardna.id)
        .where("participant", isEqualTo: widget.pardnaParticipant.id)
        .orderBy("installment")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.pardnaParticipant.data() as Map)['name'],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              PardnaParticipantUpperTile(
                pardnaParticipant: widget.pardnaParticipant,
              ),
              ListTile(
                onTap: () {
                  if (localWithdrawStatus == "Done") {
                    FirebaseFirestore.instance
                        .collection("pardna_participant")
                        .doc(widget.pardnaParticipant.id)
                        .update({
                      'withdraw_status': "Pending",
                      'withdraw_amount': (widget.singlePardna.data()
                          as Map)['contribution_amount'],
                      'withdraw_date': DateTime.now().toIso8601String(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ Withdraw Status Updated"),
                      ),
                    );
                    setState(() {
                      localWithdrawStatus = "Pending";
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection("pardna_participant")
                        .doc(widget.pardnaParticipant.id)
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
                    setState(() {
                      localWithdrawStatus = "Done";
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                trailing: Chip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Color(0xFF029247).withOpacity(0.06),
                  label: Text(
                    localWithdrawStatus,
                  ),
                ),
                tileColor: localWithdrawStatus == "Done"
                    ? Colors.green.shade200
                    : Colors.orange.shade200,
                leading: Icon(Icons.upload),
                title: Text("Withdraw Status"),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'INSTALLMENTS',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Show Only"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedTransactionFilter = "All";
                                            participantInstallmentsStream =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        "pardna_participant_payment")
                                                    .where("pardna",
                                                        isEqualTo: widget
                                                            .singlePardna.id)
                                                    .where("participant",
                                                        isEqualTo: widget
                                                            .pardnaParticipant
                                                            .id)
                                                    .orderBy("installment")
                                                    .snapshots();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("1. All")),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedTransactionFilter = "Paid";
                                            participantInstallmentsStream =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        "pardna_participant_payment")
                                                    .where("pardna",
                                                        isEqualTo: widget
                                                            .singlePardna.id)
                                                    .where("participant",
                                                        isEqualTo: widget
                                                            .pardnaParticipant
                                                            .id)
                                                    .where("payment_status",
                                                        isEqualTo: true)
                                                    .orderBy("installment")
                                                    .snapshots();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text("2. Paid")),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedTransactionFilter = "Due";
                                            participantInstallmentsStream =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        "pardna_participant_payment")
                                                    .where("pardna",
                                                        isEqualTo: widget
                                                            .singlePardna.id)
                                                    .where("participant",
                                                        isEqualTo: widget
                                                            .pardnaParticipant
                                                            .id)
                                                    .where("payment_status",
                                                        isEqualTo: false)
                                                    .orderBy("installment")
                                                    .snapshots();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text("3. Due")),
                                  ],
                                ),
                              ));
                    },
                    icon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        size: 18,
                        color: Color(0xFF000000).withOpacity(0.74),
                      ),
                      onPressed: () {},
                    ),
                    label: Text(
                      selectedTransactionFilter,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000000).withOpacity(0.74),
                        letterSpacing: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: participantInstallmentsStream,
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
                      return PardnaTransacttionExpiredDateTile(
                        singlePardna: widget.singlePardna,
                        pardnaParticipant: widget.pardnaParticipant,
                        singlePaymentInstallement:
                            snapshot.data!.docs.elementAt(index),
                        installmentNumber: index + 1,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  num calculateDuration(String? paymentFrequencyValue) {
    DateTime startSelectedDate = DateTime.parse(
        (widget.singlePardna.data() as Map)['start_date_internal']);
    DateTime endSelectedDate = DateTime.parse(
        (widget.singlePardna.data() as Map)['end_date_internal']);
    if (paymentFrequencyValue != null) {
      if (paymentFrequencyValue == "Weekly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ]).diff(
            Jiffy([
              startSelectedDate.year,
              startSelectedDate.month,
              startSelectedDate.day
            ]),
            Units.WEEK);
      } else if (paymentFrequencyValue == "Monthly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ]).diff(
            Jiffy([
              startSelectedDate.year,
              startSelectedDate.month,
              startSelectedDate.day
            ]),
            Units.MONTH);
      } else if (paymentFrequencyValue == "Yearly") {
        return Jiffy([
          endSelectedDate.year,
          endSelectedDate.month,
          endSelectedDate.day
        ]).diff(
            Jiffy([
              startSelectedDate.year,
              startSelectedDate.month,
              startSelectedDate.day
            ]),
            Units.YEAR);
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  DateTime calculatePaymentDates(
      String? paymentFrequencyValue, int iterationNumber) {
    DateTime startSelectedDate = DateTime.parse(
        (widget.singlePardna.data() as Map)['start_date_internal']);

    if (paymentFrequencyValue != null) {
      if (paymentFrequencyValue == "Weekly") {
        Jiffy jiff = Jiffy([
          startSelectedDate.year,
          startSelectedDate.month,
          startSelectedDate.day
        ]).add(weeks: iterationNumber);

        return jiff.dateTime;
      } else if (paymentFrequencyValue == "Monthly") {
        Jiffy jiff = Jiffy([
          startSelectedDate.year,
          startSelectedDate.month,
          startSelectedDate.day
        ]).add(months: iterationNumber);

        return jiff.dateTime;
      } else if (paymentFrequencyValue == "Yearly") {
        Jiffy jiff = Jiffy([
          startSelectedDate.year,
          startSelectedDate.month,
          startSelectedDate.day
        ]).add(years: iterationNumber);

        return jiff.dateTime;
      } else {
        return DateTime.now();
      }
    } else {
      return DateTime.now();
    }
  }
}
