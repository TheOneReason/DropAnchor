import 'dart:convert';
import 'dart:io';
import 'package:drop_anchor/error/local_error.dart';
import 'package:drop_anchor/model/file_type.dart';
import 'package:drop_anchor/model/index_source.dart';
import 'package:drop_anchor/model/service_source.dart';
import 'package:drop_anchor/tool/file_suffix_analysis.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 单例
/// 设备本地存储驱动
/// 程序启动时初始化建立Local本地IndexSource树
/// 抽象化访问本地Local的流程
/// 带有本地树的缓存 (Local IndexSource Tree cache)
class DeviceLocalStorage {
  ///存储目录Name
  static const String saveRootDirName = "DEVICELOCALSTORAGE";

  ///单例缓存
  static DeviceLocalStorage? _deviceLocalStorageElem;

  late String saveRootDirPath;
  late Directory saveRootDirSource;
  late Future loadState;
  late final IndexSource? rootIndexSource;
  late final ServiceSourceBase serverSource;

  /// 获取IndexSource的实际路径
  String getIndexSourceFileSystemPath(IndexSource indexSource) {
    print(path.relative(
        path.join(saveRootDirPath, "./${indexSource.getCompletePath()}")));
    return path.relative(
        path.join(saveRootDirPath, "./${indexSource.getCompletePath()}"));
  }

  /// 构建IndexSource树
  Future<IndexSource> _buildIndexSource(
    String analysisPath,
    IndexSource? parent,
  ) async {
    final name = path.split(analysisPath).last;
    final fNode = IndexSource(FsFileType.DIR, name, [],
        parent: parent, fileType: FileType.UNDEFINITION);
    final childList = <IndexSource>[];
    final childSourceList =
        await (await Directory(analysisPath).list()).toList();
    for (final nextSource in childSourceList) {
      if (nextSource is File) {
        childList.add(
          IndexSource(
            FsFileType.FILE,
            path.split(nextSource.path).last,
            [],
            parent: fNode,
            fileType: FileTypeSuffixAnalysis().testFileType(
              path.basename(nextSource.path),
            ),
          ),
        );
      } else if (nextSource is Directory) {
        childList.add(await _buildIndexSource(nextSource.path, fNode));
      }
    }
    fNode.child = childList;
    return fNode;
  }

  /// 更新本地Local树
  Future<void> buildLocalIndexSourceTree() async {
    rootIndexSource = await _buildIndexSource(saveRootDirPath, null);
  }

  //以下为单例常规方法和初始化

  /// 单例工厂
  factory DeviceLocalStorage() {
    if (_deviceLocalStorageElem == null) {
      _deviceLocalStorageElem = DeviceLocalStorage._init();
    }
    return _deviceLocalStorageElem!;
  }

  /// 初始化
  DeviceLocalStorage._init() {
    loadState = Future(() async {
      final appDocPath = (await getApplicationSupportDirectory()).path;
      saveRootDirPath = path.join(appDocPath, saveRootDirName);
      serverSource = LocalStorageServerSource(source: saveRootDirPath);
      saveRootDirSource = Directory(saveRootDirPath);
      if (!await saveRootDirSource.exists()) {
        await saveRootDirSource.create(recursive: true);
      }
      await buildLocalIndexSourceTree();
    });
  }

  /// 获取单例
  static DeviceLocalStorage get getOnlyElem {
    return DeviceLocalStorage();
  }
}
