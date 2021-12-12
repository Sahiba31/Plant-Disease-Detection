import 'package:async/async.dart';
import 'package:multiple_language/MyApp.dart';
import 'package:multiple_language/image_picker.dart';
import 'package:multiple_language/screens/home.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'getOutput.dart';

// A screen that allows users to take a picture using a given camera.
class Recognize extends StatefulWidget {
  final CameraDescription camera;

  const Recognize({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  RecognizeState createState() => RecognizeState();
}

class RecognizeState extends State<Recognize> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Take a picture'),
        ),
        backgroundColor: Colors.white,
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: Column(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              child: FlatButton(
                height: 80,
                minWidth: 80,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38),
                ),
                onPressed: () async {
                  try {
                    // Ensure that the camera is initialized.
                    await _initializeControllerFuture;

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller.takePicture();
                    final file = File(image.path);
                    // If the picture was taken, display it on a new screen.
                    //_upload(file);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image?.path,
                          filePath: file,
                        ),
                      ),
                    );
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.blueAccent,
                  size: 68,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
var myResponse;

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final filePath;
  const DisplayPictureScreen({Key key, this.imagePath, this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _markAttendance() async {
      var url = Uri.parse("http://192.168.0.10/cgi-bin/file.py");
      myResponse = await http.get(url);
      print('Response body: ${myResponse.body}');
    }

    _upload(imageFile) async {
      await _markAttendance();
    }

    return WillPopScope(
      onWillPop: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Preview'),
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        //body: Image.file(File(imagePath)),
        //body: Image.file(File(imagePath)),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width,
                child: Image.file(File(imagePath)),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => Navigator.pop(context),
                    iconSize: 80,
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      await _upload(filePath);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OutputScreen(response: myResponse)));
                    },
                    iconSize: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
