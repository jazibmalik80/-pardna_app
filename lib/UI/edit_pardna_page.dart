// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pardna_app/UI/add_new_participant.dart';
import 'package:pardna_app/UI/address_book_selector.dart';
import 'package:pardna_app/widgets/address_book_tile.dart';

class EditPardna extends StatefulWidget {
  final QueryDocumentSnapshot singlePardna;
  const EditPardna({Key? key, required this.singlePardna}) : super(key: key);

  @override
  State<EditPardna> createState() => _EditPardnaState();
}

class _EditPardnaState extends State<EditPardna> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController paymentFrequencyController =
      TextEditingController();
  final TextEditingController startDateController =
      TextEditingController(text: '');
  final TextEditingController durationController = TextEditingController();
  final TextEditingController endDateController =
      TextEditingController(text: '');
  final TextEditingController contributionAmountController =
      TextEditingController();
  final TextEditingController bankerFeeController = TextEditingController();

  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();
  late String paymentFrequencyValue;

  _startSelectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != startSelectedDate) {
      setState(() {
        startSelectedDate = selected;
        startDateController.text =
            DateFormat.yMMMd('en_US').format(startSelectedDate);
      });
    }
  }

  _endSelectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (selected != null && selected != endSelectedDate) {
      setState(() {
        endSelectedDate = selected;
        endDateController.text =
            DateFormat.yMMMd('en_US').format(endSelectedDate);
      });
    }
  }

  @override
  void initState() {
    nameController.text = "${(widget.singlePardna.data() as Map)['name']}";
    paymentFrequencyValue =
        "${(widget.singlePardna.data() as Map)['payment_frequency']}";
    startDateController.text =
        "${(widget.singlePardna.data() as Map)['start_date']}";
    durationController.text =
        "${(widget.singlePardna.data() as Map)['duration']}";
    endDateController.text =
        "${(widget.singlePardna.data() as Map)['end_date']}";
    contributionAmountController.text =
        "${(widget.singlePardna.data() as Map)['contribution_amount']}";
    bankerFeeController.text =
        "${(widget.singlePardna.data() as Map)['banker_fee']}";
    startSelectedDate = DateTime.parse(
        (widget.singlePardna.data() as Map)['start_date_internal']);
    endSelectedDate = DateTime.parse(
        (widget.singlePardna.data() as Map)['end_date_internal']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Pardna'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                      ),
                    ),
                    SizedBox(height: 16),
                    // DropdownButtonFormField(
                    //   value: paymentFrequencyValue,
                    //   decoration: InputDecoration(
                    //     labelText: 'Payment Frequency',
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 12, 12, 12),
                    //   ),
                    //   items: <String>['Weekly', 'Monthly', 'Yearly']
                    //       .map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       alignment: AlignmentDirectional.center,
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     paymentFrequencyValue = value.toString();
                    //   },
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   readOnly: true,
                    //   controller: startDateController,
                    //   decoration: InputDecoration(
                    //     labelText: "Start Date",
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         Icons.calendar_view_month_outlined,
                    //         color: Colors.black87,
                    //       ),
                    //       onPressed: () {
                    //         _startSelectDate(context);
                    //       },
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   controller: durationController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Duration',
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   readOnly: true,
                    //   controller: endDateController,
                    //   decoration: InputDecoration(
                    //     labelText: "End Date",
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         Icons.calendar_view_month_outlined,
                    //         color: Colors.black87,
                    //       ),
                    //       onPressed: () {
                    //         _endSelectDate(context);
                    //       },
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   controller: contributionAmountController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Contribution amount (£)',
                    //     hintText: 'Contribution amount (£)',
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // TextFormField(
                    //   controller: bankerFeeController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Banker Fee/Hand (£)',
                    //     hintText: 'Banker Fee/Hand (£)',
                    //     labelStyle: TextStyle(
                    //       color: Colors.grey[600],
                    //     ),
                    //     border: OutlineInputBorder(),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     isDense: true,
                    //     contentPadding: EdgeInsets.fromLTRB(10, 15, 15, 15),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      children: [
                        Text('PARTICIPANTS'),
                      ],
                    ),
                    SizedBox(height: 8),
                    pardnaParticipantList(),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
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
                                              builder: (context) =>
                                                  AddNewParticipant(
                                                pardnaID:
                                                    widget.singlePardna.id,
                                                pardnaName: (widget.singlePardna
                                                    .data() as Map)['name'],
                                              ),
                                            ),
                                          );
                                        },
                                        child:
                                            Text("1. Add participant details")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressBookSelector(
                                                singlePardnaID:
                                                    widget.singlePardna.id,
                                              ),
                                            ),
                                          );
                                        },
                                        child:
                                            Text("2. Choose from direcectory"))
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add),
                          label: Text('ADD PARTICIPANTS'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            side: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: const Size.fromHeight(40),
          ),
          onPressed: () {
            final snackBarUpdated =
                SnackBar(content: Text('Pardna Updated Successfully'));
            final snackBarerrored =
                SnackBar(content: Text('Something went wrong!'));

            final collection = FirebaseFirestore.instance.collection('pardna');
            collection.doc(widget.singlePardna.id).update({
              'name': nameController.text,
              'contribution_amount': contributionAmountController.text,
              'banker_fee': bankerFeeController.text,
            }).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
              Navigator.pop(context, {});
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarerrored);
            });
          },
          child: const Text(
            'UPDATE',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget pardnaParticipantList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("pardna_participant")
          .where("pardna", isEqualTo: widget.singlePardna.id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Visibility(
              visible: snapshot.data?.docs.isNotEmpty ?? false,
              child: Row(
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
                    "£ ${double.parse(contributionAmountController.text) / ((snapshot.data?.docs.length)?.toDouble() as num)}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Visibility(
              visible: snapshot.data?.docs.isNotEmpty ?? false,
              child: Row(
                children: [
                  Icon(
                    Icons.summarize,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Total Commission',
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "£ ${(double.parse(contributionAmountController.text) / ((snapshot.data?.docs.length)?.toDouble() as num)) * calculateDurationInDouble()}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AddressBookTile(
                          singleParticipant:
                              snapshot.data!.docs.elementAt(index),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("pardna_participant")
                                .doc(snapshot.data!.docs.elementAt(index).id)
                                .delete();

                            FirebaseFirestore.instance
                                .collection("pardna_participant_payment")
                                .where("pardna",
                                    isEqualTo: widget.singlePardna.id)
                                .where("participant",
                                    isEqualTo:
                                        snapshot.data!.docs.elementAt(index).id)
                                .get()
                                .then((value) {
                              if (value.docs.isNotEmpty) {
                                for (var elem in value.docs) {
                                  FirebaseFirestore.instance
                                      .collection("pardna_participant_payment")
                                      .doc(elem.id)
                                      .delete();
                                }
                              }
                            });
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                        )
                      ],
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: snapshot.data!.docs.length,
            ),
          ],
        );
      },
    );
  }

  double calculateDurationInDouble() {
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
