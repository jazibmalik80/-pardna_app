// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditParticipant extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> singleParticipant;
  const EditParticipant({Key? key, required this.singleParticipant})
      : super(key: key);

  @override
  State<EditParticipant> createState() => _EditParticipantState();
}

class _EditParticipantState extends State<EditParticipant> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    nameController.text = "${(widget.singleParticipant.data() as Map)['name']}";

    phoneController.text =
        "${(widget.singleParticipant.data() as Map)['phone_number']}";
    emailController.text =
        "${(widget.singleParticipant.data() as Map)['email']}";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${(widget.singleParticipant.data() as Map)['name']}"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.account_circle,
                  size: 36,
                ),
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  final snackBarUpdated = SnackBar(
                      content: Text('Participant Updated Successfully'));
                  final snackBarerrored =
                      SnackBar(content: Text('Something went wrong!'));

                  final collection =
                      FirebaseFirestore.instance.collection('participant');
                  collection.doc(widget.singleParticipant.id).update({
                    'name': nameController.text,
                    'phone_number': phoneController.text,
                    'email': emailController.text,
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
          ),
        ),
      ),
    );
  }
}
