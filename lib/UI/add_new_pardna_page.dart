// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pardna_app/UI/add_new_participant.dart';
import 'package:pardna_app/UI/address_book_selector.dart';
import 'package:pardna_app/widgets/address_book_tile.dart';

class AddNewpardna extends StatefulWidget {
  const AddNewpardna({Key? key}) : super(key: key);

  @override
  State<AddNewpardna> createState() => _AddNewpardnaState();
}

class _AddNewpardnaState extends State<AddNewpardna> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController paymentDurationController =
      TextEditingController();
  final TextEditingController contributionAmountController =
      TextEditingController();
  final TextEditingController bankerFeeController = TextEditingController();

  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now();
  String? paymentFrequencyValue;

  bool canAddParticipants = false;
  String? createdPardnaID;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Pardna & Participants'),
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
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Payment/Draw Cycle',
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
                        contentPadding: EdgeInsets.fromLTRB(10, 12, 12, 12),
                      ),
                      items: <String>['Weekly', 'Monthly', 'Yearly']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          alignment: AlignmentDirectional.center,
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          paymentFrequencyValue = value.toString();
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        hintText: "Click on icon to pick date ➡️",
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            _startSelectDate(context);
                          },
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
                    TextFormField(
                      readOnly: true,
                      controller: endDateController,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        hintText: "Click on icon to pick date ➡️",
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            _endSelectDate(context);
                          },
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
                    TextFormField(
                      controller: paymentDurationController
                        ..text = calculateDuration(),
                      enabled: true,
                      onFieldSubmitted: (String s) {},
                      decoration: InputDecoration(
                        suffix: Text(paymentFrequencyLabel()),
                        labelText: paymentFrequencyValue != null
                            ? 'Duration in ${paymentFrequencyLabel()}'
                            : "Please select Payment/Draw Cycle",
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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: contributionAmountController,
                      decoration: InputDecoration(
                        labelText: 'Contribution Amount (£)',
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
                    // TextFormField(
                    //   keyboardType: TextInputType.number,
                    //   controller: bankerFeeController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Banker Fee/Hand (£)',
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
              Visibility(
                visible: canAddParticipants,
                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                pardnaID: createdPardnaID,
                                                pardnaName: nameController.text,
                                              ),
                                            ),
                                          );
                                        },
                                        child:
                                            Text("1. Add participant details"),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressBookSelector(
                                                  singlePardnaID:
                                                      createdPardnaID ?? "",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                              "2. Choose from direcectory (recommended)"))
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
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        createdPardnaID == null
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  if (!checkValidation()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "ℹ️ Heads up! Some fields are either missing or have incorrect values")));
                    return;
                  }
                  final snackBaradded = SnackBar(
                    content: Text('Pardna Added Successfully'),
                  );
                  final snackBarerrored = SnackBar(
                    content: Text('Something went wrong!'),
                  );

                  createPardnaFirestore().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBaradded);
                    createdPardnaID = value.id;
                    setState(() {
                      canAddParticipants = true;
                    });
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBarerrored);
                  });
                },
                child: const Text(
                  'CREATE',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Theme.of(context).primaryColor)),
                child: Center(child: Text("✅ Pardna Created")),
              ),
      ],
    );
  }

  bool checkValidation() {
    if (nameController.text.isEmpty ||
        paymentFrequencyValue!.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        contributionAmountController.text.isEmpty ||
        FirebaseAuth.instance.currentUser == null ||
        startSelectedDate.isAfter(endSelectedDate) ||
        endSelectedDate.isBefore(startSelectedDate) ||
        calculateDurationInDouble() <= 0) {
      return false;
    } else {
      return true;
    }
  }

  Widget pardnaParticipantList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("pardna_participant")
          .where("pardna", isEqualTo: createdPardnaID)
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

  String paymentFrequencyLabel() {
    if (paymentFrequencyValue != null) {
      if (paymentFrequencyValue == "Weekly") {
        return "Weeks";
      }
      if (paymentFrequencyValue == "Monthly") {
        return "Months";
      }
      if (paymentFrequencyValue == "Yearly") {
        return "Years";
      }
    }
    return "-";
  }

  String calculateDuration() {
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
                ]), Units.WEEK)}";
      } else if (paymentFrequencyValue == "Monthly") {
        return "${Jiffy([
              endSelectedDate.year,
              endSelectedDate.month,
              endSelectedDate.day
            ]).diff(Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]), Units.MONTH)}";
      } else if (paymentFrequencyValue == "Yearly") {
        return "${Jiffy([
              endSelectedDate.year,
              endSelectedDate.month,
              endSelectedDate.day
            ]).diff(Jiffy([
                  startSelectedDate.year,
                  startSelectedDate.month,
                  startSelectedDate.day
                ]), Units.YEAR)}";
      } else {
        return "No duration specified yet.";
      }
    } else {
      return "No duration specified yet.";
    }
  }

  Future createPardnaFirestore() async {
    return FirebaseFirestore.instance.collection('pardna').add({
      'banker': FirebaseAuth.instance.currentUser?.uid ?? "UID MISSING",
      'name': nameController.text,
      'payment_frequency': paymentFrequencyValue,
      'start_date': startDateController.text,
      'start_date_internal': startSelectedDate.toIso8601String(),
      'duration': durationController.text,
      'end_date': endDateController.text,
      'end_date_internal': endSelectedDate.toIso8601String(),
      'contribution_amount': contributionAmountController.text,
      'banker_fee': bankerFeeController.text,
    });
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
