import 'package:drop_anchor/data.dart';
import 'package:flutter/material.dart';
import 'package:drop_anchor/model/IndexSource.dart';
import 'package:provider/provider.dart';

IndexSource goInPath(List<String> startP, IndexSource rootSource) {
  final goPathList = startP;
  var nowNode = rootSource;
  if (goPathList.last == '..') {
    goPathList.removeLast();
    goPathList.removeLast();
  }
  for (int i = 0; i < goPathList.length; i++) {
    for (int ii = 0; ii < nowNode.child.length; ii++) {
      if (nowNode.child[ii].path == goPathList[i]) {
        nowNode = nowNode.child[ii];
        break;
      }
      if (ii == nowNode.child.length) {
        print(
          'no find ${goPathList.join('/')}\nnow path ${goPathList.sublist(0, i).join('/')}',
        );
        return nowNode;
      }
    }
  }
  return nowNode;
}

class BookIndex extends StatelessWidget {
  BookIndex() {}

  createLibChild(List<IndexSource> childData) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: childData
                .map(
                  (e) => InkWell(
                    child: e.createView(),
                    onTap: () {
                      switch (e.type) {
                        case 0:
                          AppDataSourceElem.showPath.add(e.path);
                          AppDataSourceElem.nowIndexSource = goInPath(
                            AppDataSourceElem.showPath,
                            AppDataSourceElem.useIndexSource!,
                          );
                          AppDataSourceElem.notifyListeners();
                          break;
                        case 1:
                          break;
                      }
                    },
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppDataSourceElem),
      ],
      child: StatefulBuilder(builder: (bc, ns) {
        List<IndexSource> rootChild = [];
        if (bc.read<AppDataSource>().nowIndexSource != null) {
          rootChild.addAll(bc.read<AppDataSource>().nowIndexSource!.child);
        }
        return Scaffold(
          appBar: AppBar(
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text("/${bc.watch<AppDataSource>().showPath.join("/")}"),
              width: double.infinity,
            ),
            actions: [
              SizedBox(
                width: 30,
                child: Image.asset(
                  "assets/infoi.png",
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          body: createLibChild(rootChild),
        );
      }),
    );
  }
}
