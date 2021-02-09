import 'package:acm_widget_mobile_app/pages/checklist_page.dart';
import 'package:acm_widget_mobile_app/pages/home.dart';
import 'package:acm_widget_mobile_app/pages/recipe_page.dart';
import 'package:acm_widget_mobile_app/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  List<Widget> list = [
    HomePage(),
    WeatherPage(),
    RecipePage(),
    ChecklistPage()
  ];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clutter',
      theme: ThemeData(
        // This is the theme of your application.

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text("Clutter"),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/menu.svg',
              color: Colors.white,
              height: 25,
              width: 25,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: list[index],
        drawer: NavDrawer(onTap: (ctx, i) {
          setState(() {
            index = i;
            Navigator.pop(ctx);
          });
        }),
      ),
    );
  }
}

//Container(
//                 margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//                 child: GestureDetector(
//                   onTap: ()=>print('menu pressed'),
//                   child: SvgPicture.asset(
//                     'assets/menu.svg',
//                     height: 30,
//                     width: 30,
//                     color: Colors.white,
//                   ),
//                 ))
class NavDrawer extends StatelessWidget {
  final Function onTap;

  NavDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: 140,
                        height: 130,
                        child: Image(
                          image: AssetImage('assets/acm_logo.png'),
                        ))
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => onTap(context, 0),
            ),
            Divider(height: 5),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Weather'),
              onTap: () => onTap(context, 1),
            ),
            Divider(height: 5),
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Recipe'),
              onTap: () => onTap(context, 2),
            ),
            Divider(height: 5),
            ListTile(
              leading: Icon(Icons.assignment_turned_in_rounded),
              title: Text('Checklist'),
              onTap: () => onTap(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}
