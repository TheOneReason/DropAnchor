import 'package:drop_anchor/tool/SecuritySetState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../mddata.dart';

class ShowMarkDown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShowMarkDownState();
  }
}

class ShowMarkDownState extends SecurityState<ShowMarkDown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('is MarkDown Title'),
      ),
      body: Markdown(
        data: v1mdstr,
        selectable: true,
        physics: BouncingScrollPhysics(),
        onTapLink: (String text, String? href, String title) {
          print([
            text,
            href ?? null,
            title,
          ]);
        },
      ),
    );
  }
}
