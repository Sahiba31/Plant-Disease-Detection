import 'package:flutter/material.dart';
import 'package:multiple_language/MyApp.dart';
import 'package:multiple_language/screens/home.dart';

class OutputScreen extends StatelessWidget {
  final response;
  const OutputScreen({
    Key key,
    @required this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: Text('Output'),
            ),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "The Plant Disease Level is identified as:",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${response.body}',
                      style: TextStyle(fontSize: 200),
                    ),
                  ],
                ),
              ),
            )));
  }
}
