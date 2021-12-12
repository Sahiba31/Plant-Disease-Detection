import 'package:flutter/material.dart';
import 'package:multiple_language/captureImage.dart';
import 'package:multiple_language/image_picker.dart';
import 'package:multiple_language/localization/language/languages.dart';
import 'package:multiple_language/localization/locale_constant.dart';
import 'package:multiple_language/model/language_data.dart';
import 'package:multiple_language/main.dart';

import 'package:camera/camera.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
    var firstCamera;
    getCamera() async{
      
    WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
    }
  @override
  void initState(){
    super.initState();
    getCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.white),
              ),
              child: DropdownButton<LanguageData>(
                icon: Container(
                  child: Center(
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 10),
                ),
                iconSize: 40,
                underline: Container(),
                onChanged: (LanguageData language) {
                  changeLanguage(context, language.languageCode);
                },
                items: LanguageData.languageList()
                    .map<DropdownMenuItem<LanguageData>>(
                      (e) => DropdownMenuItem<LanguageData>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              e.name,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          title: Text(Languages.of(context).appName),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset('Assets/images/ladki.gif'),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  Languages.of(context).labelWelcome,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  Languages.of(context).labelInfo,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.camera),
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Recognize(
                          camera: firstCamera,
            ))),
                      },
                    ),
                    IconButton(
                      iconSize: 40,
                      icon: Icon(Icons.image),
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyImagePicker())),
                      },
                    ),
                  ],
                ),
                // _createLanguageDropDown()
              ],
            ),
          ),
        ),
      );

  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages.of(context).labelSelectLanguage),
      onChanged: (LanguageData language) {
        changeLanguage(context, language.languageCode);
      },
      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) => DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    e.flag,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(e.name)
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
