// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PardnaTransacttionFutureDateTile extends StatelessWidget {
  const PardnaTransacttionFutureDateTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Column(
        children: [
          Row(
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
                            backgroundColor:
                                Color(0xFF029247).withOpacity(0.06),
                            label: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
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
                            "Thuesday, 03 Mar 2022",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF121212).withOpacity(0.87),
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Was 2 months ago",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.green,
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
                  Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.green,
                    label: Text(
                      'Paid £120',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14),
          Divider(),
        ],
      ),
    );
  }
}
