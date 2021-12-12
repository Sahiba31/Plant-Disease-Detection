import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiple_language/localization/locale_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyApp.dart';
import 'image_picker.dart';
import 'screens/home.dart';
import 'package:camera/camera.dart';

int initScreen;
SharedPreferences prefs;

Future<void> main() async {
  // Obtain a list of the available cameras on the device.

  // Get a specific camera from the list of available cameras.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  print('initScreen ${initScreen}');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: initScreen == 0 || initScreen == null ? "/first" : "/",
    routes: {
      '/': (context) => MyApp(),
      "/first": (context) => OnboardingScreen(),
    },
  ));
}

// class MyHome extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {

//   }
// }

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Image.asset('Assets/images/intro.gif'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: _selectLanguage(context),
            ),
          ],
        ),
      ),
    );
  }
}

_selectLanguage(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(15.0)))),
    child: DropdownButton<String>(
      underline: Container(),
      iconSize: 30,
      hint: Text("Choose Language"),
      onChanged: (e) async {
        if (e == "English") {
          setLocale('en');
        } else if (e == "Hindi")
          setLocale('hi');
        else if (e == "Punjabi") setLocale('pa');
        Navigator.pushNamed(context, "/");
        await prefs.setInt("initScreen", 1);
      },
      items: ["English", "Hindi", "Punjabi"]
          .map<DropdownMenuItem<String>>(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    e,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}
