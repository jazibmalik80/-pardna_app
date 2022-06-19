// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNewParticipant extends StatefulWidget {
  const AddNewParticipant({Key? key, required this.pardnaID, this.pardnaName})
      : super(key: key);
  final String? pardnaID;
  final String? pardnaName;

  @override
  State<AddNewParticipant> createState() => _AddNewParticipantState();
}

class _AddNewParticipantState extends State<AddNewParticipant> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: const Size.fromHeight(50),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () {
            if (checkValidation()) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("ℹ️ Please fill all the details")));
              return;
            }
            final successMessage =
                SnackBar(content: Text('Participant Added Successfully'));
            final errorMessage =
                SnackBar(content: Text('Something went wrong!'));

            if (widget.pardnaID != null) {
              addPardnaParticipant().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(successMessage);
              }).catchError((e) {});
            } else {
              addRegularParticipant().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(successMessage);
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(errorMessage);
              });
            }
          },
          child: const Text(
            'ADD NEW PARTICIPANT',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('New Participant'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(14),
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
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              SizedBox(
                height: 16,
              ),
              Visibility(
                visible: widget.pardnaID != null,
                child: Column(
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "Note: This participant will be added to \"${widget.pardnaName}\"",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future addRegularParticipant() async {
    Map<String, String> payload = {
      'name': nameController.text,
      'phone_number': phoneController.text,
      'email': emailController.text,
      'banker': FirebaseAuth.instance.currentUser!.uid
    };
    return await FirebaseFirestore.instance
        .collection('participant')
        .add(payload);
  }

  Future addPardnaParticipant() async {
    Map<String, dynamic> payload = {
      'name': nameController.text,
      'phone_number': phoneController.text,
      'email': emailController.text,
      'banker': FirebaseAuth.instance.currentUser!.uid,
      'withdraw_status': "Pending",
      'withdraw_amount': 0,
      'withdraw_date': DateTime.now().toIso8601String(),
      'pardna': widget.pardnaID ?? "PARDNA MISSING"
    };
    return await FirebaseFirestore.instance
        .collection('pardna_participant')
        .add(payload);
  }

  bool checkValidation() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
