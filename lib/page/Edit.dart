import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditState with ChangeNotifier, DiagnosticableTreeMixin {
  late TextEditingController textEditingController;

  EditState() {
    textEditingController = new TextEditingController();
  }
}

class Edit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (bc) => EditState())],
      child: StatefulBuilder(
        builder: (bc, ns) => Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: SizedBox(
                    height: 30,
                    child: ListView(
                      shrinkWrap: true,
                      children: [Text("123123")],
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  actions: [
                    Column(
                      children: [
                        PopupMenuButton<Function>(
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              3,
                            ),
                          ),
                          itemBuilder: (bc){
                            return [
                              PopupMenuItem(
                                value: () {
                                  print("save");
                                },
                                height: 20,
                                child: Text("Save"),
                              ),
                            ];
                          },
                          onSelected: (callbackFunc){
                            callbackFunc();
                          },
                          child: Image.asset(
                            "assets/menuless.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: TextField(
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(border: InputBorder.none),
                      controller: bc.read<EditState>().textEditingController,
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
