import 'package:drop_anchor/model/server_source.dart';
import 'package:drop_anchor/state/data.dart';
import 'package:drop_anchor/tool/security_set_state.dart';
import 'package:drop_anchor/widget/free_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:drop_anchor/model/index_source.dart';
import 'package:drop_anchor/widget/free_popup_menu_button.dart';

typedef onTapIndexSourceElemCallback = void Function(IndexSource);

void setShowIndexSource({
  required IndexSource indexSource,
  required ServerSourceBase useServerSource,
  required IndexSource rootIndexSource,
}) {
  AppDataSource.getOnlyExist.activationIndexSourceManage
      .fromLocalReadIndexSource(
    useServerSource,
    rootIndexSource: rootIndexSource,
    showIndexSource: indexSource,
  );
  AppDataSource.getOnlyExist.activationIndexSourceManage.setShowIndexSource =
      indexSource;
  AppDataSource.getOnlyExist.notifyListeners();
}

/// 下拉子元素内容渲染
FreeExpansionPanel indexSourceCreateView(
  IndexSource indexSource, {
  required ServerSourceBase? useServerSource,
  required IndexSource rootIndexSource,
  required bool showBook,
  onTapIndexSourceElemCallback? onTap,
  List<PopupMenuItem<Function>>? dirDownPopupMenus,
  List<PopupMenuItem<Function>>? fileDownPopupMenus,
}) {
  assert(
    (useServerSource == null && rootIndexSource == null) ||
        (useServerSource != null && rootIndexSource != null),
  );

  // 抹除 local source 和 net source 的 ServerSourceBase 来源差异
  final nowTargetServer = useServerSource ??
      AppDataSource.getOnlyExist.activationIndexSourceManage.serverSource;
  switch (indexSource.type) {
    //DIR
    case 0:
      return FreeExpansionPanel(
        canTapOnHeader: true,
        openStateIcon: Container(),
        closeStateIcon: Container(),
        isExpanded: indexSource.isOpenChildList,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            8,
            0,
            0,
            0,
          ),
          //向下传递
          child: BookIndex.createLibChild(
            indexSource.child,
            useServerSource: useServerSource,
            rootIndexSource: rootIndexSource,
            showBook: showBook,
            onTap: onTap,
            dirDownPopupMenus: dirDownPopupMenus,
            fileDownPopupMenus: fileDownPopupMenus,
          ),
        ),
        headerBuilder: (bc, openState) => FreePopupMenuButton<Function>(
          // onTap: onTap != null ? () => onTap(indexSource) : null,
          padding: const EdgeInsets.all(0),
          enabled: true,
          offset: const Offset(10, 10),
          onSelected: (useF) {
            useF();
          },
          itemBuilder: (BuildContext context) {
            return [
              ...(dirDownPopupMenus ?? []),
              PopupMenuItem(
                child: const Text("修改名称"),
                value: () {
                  print("修改名称");
                },
              ),
              PopupMenuItem(
                child: const Text("添加子文件夹"),
                value: () {
                  print("添加子文件夹");
                },
              ),
              PopupMenuItem(
                child: const Text("创建新文件"),
                value: () {
                  print("创建新文件");
                },
              ),
            ];
          },
          child: ListTile(
            title: Text(
              indexSource.name,
              style: const TextStyle(fontSize: 14),
            ),
            leading: SizedBox(
              child: indexSourceTypeLogo(indexSource.type,
                  typeState: indexSource.isOpenChildList ? 1 : 0),
              width: 35,
            ),
          ),
        ),
      );
    //FILE
    case 1:
    default:
      return FreeExpansionPanel(
        canTapOnHeader: true,
        openStateIcon: Container(),
        closeStateIcon: Container(),
        headerBuilder: (bc, openState) => FreePopupMenuButton<Function>(
            onSelected: (selectRunFunc) {
              selectRunFunc();
            },
            itemBuilder: (bc) => [
                  ...(fileDownPopupMenus ?? []),
                  PopupMenuItem(
                    child: const Text("查看"),
                    value: () {
                      setShowIndexSource(
                        indexSource: indexSource,
                        useServerSource: useServerSource!,
                        rootIndexSource: rootIndexSource,
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("修改"),
                    value: () {
                      print("修改");
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("下载"),
                    value: () {
                      print("下载");
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("删除"),
                    value: () {
                      showDialog(
                          context: bc,
                          builder: (bc) {
                            return AlertDialog(
                              content: Text(
                                "是否删除 ${indexSource.getCompletePath()} ?",
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(bc);
                                  },
                                  child: const Text("取消"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: bc,
                                      builder: (bc) => FutureBuilder(
                                        future: nowTargetServer!
                                            .delete(indexSource),
                                        builder: (bc, futureState) {
                                          if (futureState.connectionState !=
                                              ConnectionState.done) {
                                            return CircularProgressIndicator();
                                          }
                                          Future(() => Navigator.of(bc).pop())
                                              .then((value) =>
                                                  Navigator.of(bc).pop());
                                          return Container();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text("确定"),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                      print("删除");
                    },
                  ),
                ],
            child: ListTile(
              title: Text(
                indexSource.name,
                style: const TextStyle(fontSize: 14),
              ),
              leading: SizedBox(
                child: indexSourceTypeLogo(indexSource.type),
                width: 35,
              ),
            ),
            offset: const Offset(
              0,
              40,
            ),
            onTap: () {
              onTap != null ? (() => onTap(indexSource))() : null;
            }),
        body: Container(),
      );
  }
}

class BookIndex extends StatelessWidget {
  /// 下拉子元素框架
  static Widget createLibChild(
    List<IndexSource> childData, {
    required ServerSourceBase? useServerSource,
    required IndexSource rootIndexSource,
    onTapIndexSourceElemCallback? onTap,
    bool showBook = true,
    List<PopupMenuItem<Function>>? dirDownPopupMenus,
    List<PopupMenuItem<Function>>? fileDownPopupMenus,
  }) {
    childData = List.from(childData);
    return SecurityStatefulBuilder(
      builder: (bc, ns) {
        return Column(
          children: [
            FreeExpansionPanelList(
              elevation: 0,
              expansionCallback: (index, openState) {
                childData[index].isOpenChildList = !openState;

                ns(() => null);
              },
              expandedHeaderPadding: const EdgeInsets.all(0),
              children: (showBook
                      ? childData
                      : (childData
                        ..removeWhere(
                            (element) => element.type == FsFileType.FILE)))
                  .map(
                    (e) => indexSourceCreateView(
                      e,
                      useServerSource: useServerSource,
                      rootIndexSource: rootIndexSource,
                      showBook: showBook,
                      onTap: onTap,
                      fileDownPopupMenus: fileDownPopupMenus,
                      dirDownPopupMenus: dirDownPopupMenus,
                    ),
                  )
                  .toList(),
            )
          ],
        );
      },
    );
  }

  late ServerSourceBase? useServerSource;
  late IndexSource rootIndexSource;
  late List<PopupMenuItem<Function>>? dirDownPopupMenus;
  late List<PopupMenuItem<Function>>? fileDownPopupMenus;

  BookIndex({
    ServerSourceBase? useServerSource,
    IndexSource? rootIndexSource,
    this.dirDownPopupMenus,
    this.fileDownPopupMenus,
  }) : assert(
          (useServerSource == null && rootIndexSource == null) ||
              (useServerSource != null && rootIndexSource != null),
        ) {
    //抹除来源差异
    this.useServerSource = useServerSource ??
        AppDataSource.getOnlyExist.activationIndexSourceManage.serverSource;
    this.rootIndexSource = (rootIndexSource ??
        AppDataSource
            .getOnlyExist.activationIndexSourceManage.rootIndexSource)!;
  }

  @override
  Widget build(BuildContext context) {
    final rootChild = <IndexSource>[];
    if (useServerSource != null) {
      rootChild.addAll(rootIndexSource.child);
    }
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 10,
        ),
        createLibChild(
          rootChild,
          useServerSource: useServerSource,
          rootIndexSource: rootIndexSource,
          dirDownPopupMenus: dirDownPopupMenus,
          fileDownPopupMenus: fileDownPopupMenus,
          onTap: (indexSource) => useServerSource != null
              ? setShowIndexSource(
                  indexSource: indexSource,
                  useServerSource: useServerSource!,
                  rootIndexSource: rootIndexSource,
                )
              : null,
        )
      ],
    );
  }
}
