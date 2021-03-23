import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  static final normalController = TextEditingController();

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(30, 16, 0, 0),
          child: Row(
            children: <Widget>[
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 10),
              Text("Recipe Search",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(40, 7, 40, 0),
          child: TextField(
              style: TextStyle(color: Colors.white),
              controller: SearchBar.normalController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Enter recipe name",
                hintStyle: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }
}
