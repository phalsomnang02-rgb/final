import 'package:flutter/material.dart';
import 'package:flutter_application_1/movie_gridstyle_logic.dart';
import 'package:flutter_application_1/movie_theme_logic.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<MovieThemeLogic>().dark;
    bool gridStyle = context.watch<MovieGridstyleLogic>().gridStyle;
    return Scaffold(

      appBar: AppBar(
        title:Text("Setting"),

      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child:Image.asset("images/love1.png",height: 200,)          ),
          Divider(),
           Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text("Switch to ${dark ? "Light" : "Dark"} Mode"),
              trailing: Icon(dark ? Icons.light_mode: Icons.dark_mode),
              onTap: () {
                context.read<MovieThemeLogic>().toggleDark();
              },
    
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("Switch to ${gridStyle ? "Grid" : "List"} Style"),
              trailing: Icon(gridStyle ? Icons.grid_on : Icons.list),
              onTap: () {
                context.read<MovieGridstyleLogic>().toggleStyle();
              },
    
            ),
          )
        ],
      ),
    );
  }
}
