// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class PardnaTransacttionExpiredDateTile extends StatelessWidget {
  const PardnaTransacttionExpiredDateTile(
      {Key? key,
      required this.installmentNumber,
      required this.singlePaymentInstallement,
      required this.singlePardna,
      required this.pardnaParticipant})
      : super(key: key);
  final int installmentNumber;
  final DocumentSnapshot pardnaParticipant;
  final DocumentSnapshot singlePardna;
  final DocumentSnapshot singlePaymentInstallement;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Color(0xFF029247).withOpacity(0.06),
                          label: Text(
                            ((singlePaymentInstallement.data()
                                        as Map)["installment"] +
                                    1)
                                .toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB00020),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Installment",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF121212).withOpacity(0.87),
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Due ${Jiffy((singlePaymentInstallement.data() as Map)["expected_date"], "yyyy-MM-dd").yMMMEd}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.grey,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                singlePaymentInstallement['payment_status']
                    ? GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("pardna_participant_payment")
                              .doc(singlePaymentInstallement.id)
                              .update({'payment_status': false});
                        },
                        child: Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.green,
                          label: Text(
                            'Paid £${(singlePardna.data() as Map)['contribution_amount']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("pardna_participant_payment")
                              .doc(singlePaymentInstallement.id)
                              .update({'payment_status': true});
                        },
                        child: Chip(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Color(0xFFB00020),
                          label: Text(
                            '${getProperMessage((singlePaymentInstallement.data() as Map)["expected_date"])} £${(singlePardna.data() as Map)['contribution_amount']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getProperMessage(String expectedDate) {
    DateTime expected = DateTime.parse(expectedDate);
    if (expected.isAfter(DateTime.now())) {
      return "Due";
    } else {
      return "Overdue";
    }
  }
}
