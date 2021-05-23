import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drop_anchor/tool/security_set_state.dart';
import 'device_local_storage_tree.dart';
import 'lib_index.dart';
import 'setting.dart';
import 'show_mark_down.dart';

class IndexFrame extends StatefulWidget {
  final List<Widget> showPageList = [
    ShowMarkdown(),
    LibIndex(),
    DeviceLocalStorageTree(),
    Setting(),
  ];

  IndexFrame();

  @override
  State<StatefulWidget> createState() {
    return IndexFrameState();
  }
}

class IndexFrameState extends SecurityState<IndexFrame>
    with TickerProviderStateMixin {
  late TabController tabController;

  IndexFrameState() {
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: widget.showPageList,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: LayoutBuilder(builder: (bc,con){
          if(con.maxWidth<900){
            return TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              controller: tabController,
              indicatorWeight: 3.0,
              unselectedLabelStyle: TextStyle(fontSize: 12.0),
              tabs: [
                FittedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        "./assets/redb.png",
                        width: 36,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Show",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        "./assets/blues.png",
                        width: 30,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Lib",
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                FittedBox(
                    child: Row(
                      children: [
                        Image.asset(
                          "./assets/pc.png",
                          width: 36,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FittedBox(
                          child: const Text(
                            "Local",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    )),
                FittedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        "./assets/setting.png",
                        width: 36,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Setting",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              ],
            );
          }else{
            return  TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              controller: tabController,
              indicatorWeight: 3.0,
              unselectedLabelStyle: TextStyle(fontSize: 12.0),
              tabs: [
                FittedBox(
                  child: Column(
                    children: [
                      Image.asset(
                        "./assets/redb.png",
                        width: 36,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Show",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                FittedBox(
                  child: Column(
                    children: [
                      Image.asset(
                        "./assets/blues.png",
                        width: 30,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Lib",
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                FittedBox(
                    child: Column(
                      children: [
                        Image.asset(
                          "./assets/pc.png",
                          width: 36,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FittedBox(
                          child: const Text(
                            "Local",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    )),
                FittedBox(
                  child: Column(
                    children: [
                      Image.asset(
                        "./assets/setting.png",
                        width: 36,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      FittedBox(
                        child: const Text(
                          "Setting",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              ],
            );
          }
        } ,) ,
        color: Colors.white,
      ),
    );
  }
}
