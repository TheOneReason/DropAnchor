import 'package:drop_anchor/tool/SecuritySetState.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends SecurityState<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
          ListTile(title: Text("123"),),
        ],
      ),
    );
  }
}
