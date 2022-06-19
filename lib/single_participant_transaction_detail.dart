// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class SingleParticipantTransactionDetail extends StatelessWidget {
  const SingleParticipantTransactionDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Katun Dogan'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Katun Doğan',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Was 2 month ago',
                                style: TextStyle(
                                  color: Color(0xFF029247),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '£120',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          letterSpacing: 0.15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Paid',
                        style: TextStyle(
                          color: Color(0xFF029247),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 14),
              decoration: BoxDecoration(
                color: Color(0xFF000000).withOpacity(0.04),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Color(0xFF000000).withOpacity(0.74),
                        ),
                      ),
                      Text(
                        '£1440',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Paid',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Color(0xFF000000).withOpacity(0.74),
                        ),
                      ),
                      Text(
                        '£480',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Left',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Color(0xFF000000).withOpacity(0.74),
                        ),
                      ),
                      Text(
                        '£960',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Drawing Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Color(0xFF000000).withOpacity(0.74),
                        ),
                      ),
                      Text(
                        '£200',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount to pay per month ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Color(0xFF000000).withOpacity(0.74),
                        ),
                      ),
                      Text(
                        '£120',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
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
              onPressed: () {},
              child: const Text(
                'ALL TRANSACTIONS',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
