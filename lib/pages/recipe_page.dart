import 'package:acm_widget_mobile_app/data/global_data.dart';
import 'package:acm_widget_mobile_app/widgets/recipe_seach_bar.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  bool isLoading = false;
  Map edamamReturned;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Stack(children: <Widget>[
            Positioned(
                bottom: 20,
                right: 125,
                child: Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.black54),
                )),
            //Top Right Circle
            Positioned(
                bottom: 150,
                left: 150,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: Colors.black87),
                )),
            //Bottom Right Circle
            Positioned(
                top: 80,
                left: 200,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(125),
                      color: Colors.black38),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                  )),
              child: Column(children: <Widget>[
                SearchBar(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: RaisedButton(
                      onPressed: () async {
                        var currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        setState(() {
                          isLoading = true;
                        });

                        await getData(SearchBar.normalController.text);

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text("Search"),
                      color: Colors.lightBlue),
                ),
              ]),
            ),
          ]),
        ),
        Expanded(flex: 3, child: processRecipesWithLoading())
      ],
    );
  }

  Widget processRecipesWithLoading() {
    if (isLoading) {
      return Center(
          child: SpinKitCircle(
        color: Colors.grey,
        size: 50.0,
      ));
    } else {
      return processRecipes();
    }
  }

  Future<void> getData(String searchQuery) async {
    String request;
    // parse the search query into the correct format for the API
    request = "https://api.edamam.com/search?q=" +
        searchQuery +
        "&app_id=${GlobalData.edamamAPIAppID}&app_key=${GlobalData.edamamAPIKey}";

    // fetch data from the API
    try {
      Response res = await get(request);
      Map data = jsonDecode(res.body);

      edamamReturned = data;
    } catch (e) {
      print(e);
    }
  }

  Widget processRecipes() {
    if (edamamReturned == null) {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
          child: Text("recipes will appear here!",
              style: TextStyle(color: Colors.grey[400])));
    }

    List<Widget> recipeWidgets = [];
    int recipes = edamamReturned["hits"].length;

    // if there are no results from the API
    if (recipes == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
        child: Text("No results found :( try widening your search!",
            style: TextStyle(color: Colors.grey[500])),
      );
    }

    for (int i = 0; i < recipes; i++) {
      recipeWidgets.add(edamamRecipeTemplate(i));
    }

    // return a scrollable view of all 10 recipes
    return SingleChildScrollView(child: Column(children: recipeWidgets));
  }

  Widget edamamRecipeTemplate(int i) {
    if (edamamReturned.isNotEmpty) {
      // get the map containing the information of the recipe that we're on
      Map recipeInfo = edamamReturned["hits"][i]["recipe"];

      // turn the list of ingredients into a string
      String ingredientStr = recipeInfo["ingredientLines"].join("\n");

      // if the recipe label is too long, shrink its size
      double labelSize =
          (recipeInfo["label"].toString().length <= 40) ? 20 : 18;

      return Card(
          margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(recipeInfo["image"]),
                        radius: 35),
                    SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        recipeInfo["label"],
                        style:
                            TextStyle(fontSize: labelSize, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Ingredients:", style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 6),
                Text(ingredientStr),
                SizedBox(height: 10),
                Text("Full recipe link:", style: TextStyle(fontSize: 12)),
                RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                        text: recipeInfo["url"],
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (await canLaunch(recipeInfo["url"])) {
                              await launch(recipeInfo["url"]);
                            } else {
                              throw "Cannot launch URL";
                            }
                          }))
              ],
            ),
          ));
    }

    return SizedBox(height: 0);
  }
}
