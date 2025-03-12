import 'dart:math';

import 'package:flutter/material.dart';

class AttendanceCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String attendanceId;

  const AttendanceCardWidget(
      {super.key,
        required this.data,
        required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white54,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  (data['name']?.isNotEmpty ?? false)
                      ? data['name'][0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        data['name'], style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Attendance Status: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        data['description'], style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Date & Time: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        data['datetime'], style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Address : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data['address'], style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
