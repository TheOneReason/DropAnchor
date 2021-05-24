import 'dart:async';
import 'dart:convert';

import 'package:drop_anchor/api/server_public_data.dart';
import 'package:drop_anchor/api/state_code.dart';
import 'package:drop_anchor/model/file_type.dart';
import 'package:drop_anchor/state/device_local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drop_anchor/model/index_source.dart';
import 'package:drop_anchor/model/service_source.dart';
import 'package:drop_anchor/tool/persist.dart';

typedef ActivationIndexSourceManage = _ActivationIndexSourceManage;


IndexSource deIndex(String pathStruct) {
  final deres = jsonDecode(pathStruct);
  return IndexSource.helperCreate(deres, parent: null);
}

class _ManageRemoteServer {
  late final Future loadState;
  late final List<ServiceSource> listServer;
  late final PersistData listServerPersist;
  late final Map<String, Map<String, TextEditingController>> listServerNameConMap = {};

  _ManageRemoteServer() {
    loadState = Future(() async {
      listServerPersist = await Persist.usePersist("LIBDATA", jsonEncode([]));
      //use vir data
      var libList = List<dynamic>.from(await listServerPersist.read())
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      listServer = libList
          .map((e) => ServiceSource(
                e['name'],
                e['source'],
                e['port'],
              ))
          .toList();
      //init con
      listServer.forEach(addListServerCont);
    })
      ..then((_) async {
        await saveServer();
      });
  }

  void addListServerCont(ServiceSourceBase serverSource) {
    final createMap = <String, TextEditingController>{};
    final editNameCon = TextEditingController();
    createMap['editName'] = editNameCon;
    editNameCon.text = serverSource.name;
    listServerNameConMap[serverSource.token()] = createMap;
  }

  Future saveServer() async {
    await loadState;
    await listServerPersist
        .save(jsonEncode(listServer.map((e) => e.toMap()).toList()));
  }

  Future deleteServer(ServiceSourceBase removeServerSource) async {
    await loadState;
    listServer.remove(removeServerSource);
    await saveServer();
  }

  Future addServer(String name, String source, int port) async {
    await loadState;
    final newServerSource = ServiceSource(name, source, port);
    listServer.add(newServerSource);
    addListServerCont(newServerSource);
    await saveServer();
  }
}

class _ActivationIndexSourceManage with ChangeNotifier {
  IndexSource? _rootIndexSource;
  IndexSource? _showIndexSource;
  ServiceSourceBase? _serviceSource;
  Future<bool>? activationLoad;


  ServiceSourceBase? get serviceSource => _serviceSource;
  IndexSource? get getShowIndexSource => _showIndexSource;
  IndexSource? get rootIndexSource => _rootIndexSource;


  ///设置显示内容
  set setShowIndexSource(IndexSource showIndexSource) {
    if (_serviceSource != null) {
      _showIndexSource = showIndexSource;
    }
  }

  /// 从远程Remote读取IndexSource来源
  Future<bool> fromRemoteServerReadIndexSource(ServiceSourceBase serviceSource) {
    _serviceSource = serviceSource;
    activationLoad = Future<bool>(() async {
      final resPack = await serviceSource.getServerPublicDataIndex();
      switch (resPack.stateCode) {
        case StateCode.RES_OK:
          _rootIndexSource = IndexSource(
            FsFileType.DIR,
            "RemoteLibExport",
            resPack.data,
            parent: null,
            fileType: FileType.UNDEFINITION,
          );
          return true;
        default:
          // throw error
          print(resPack);
          return false;
      }
    });
    return activationLoad ?? Future.value(false);
  }


  /// 刷新 IndexSource
  Future<bool> reFromRemoteServerReadIndexSource(){
    if(this.serviceSource!=null){
      if(this.serviceSource!.token()==LocalStorageServerSource.staticToken){
        DeviceLocalStorage().buildLocalIndexSourceTree();
        this._rootIndexSource=DeviceLocalStorage().rootIndexSource;
        Future(()async=>this.notifyListeners());
        return Future.value(true);
      }else{
        Future(()async=>this.notifyListeners());
        return fromRemoteServerReadIndexSource(this.serviceSource!);
      }
    }
    return Future.value(false);
  }

  /// 设置显示内容和IndexSource树
  Future<bool> fromLocalReadIndexSource(
    ServiceSourceBase serverSource, {
    required IndexSource rootIndexSource,
    required IndexSource showIndexSource,
  }) {
    _serviceSource = serverSource;
    _rootIndexSource = rootIndexSource;
    _showIndexSource = showIndexSource;
    activationLoad = Future.value(true);
    // ???
    return Future.value(true);
  }

  _ActivationIndexSourceManage() {
    _rootIndexSource = null;
  }

}

class AppDataSource with ChangeNotifier, DiagnosticableTreeMixin {
  late final Future<AppDataSource> initState;
  final _ManageRemoteServer manageRemoteServer = _ManageRemoteServer();
  final _ActivationIndexSourceManage activationIndexSourceManage =
      _ActivationIndexSourceManage();
  ///单例缓存
  static AppDataSource? _appDataSourceElem;
  ///工厂
  factory AppDataSource() => getOnlyExist;
  ///获取单例
  static AppDataSource get getOnlyExist {
    if (_appDataSourceElem == null) {
      _appDataSourceElem = AppDataSource._initOnlyExist();
    }
    return _appDataSourceElem!;
  }
  ///初始化
  @override
  AppDataSource._initOnlyExist() {
    initState = Future(() async {
      await manageRemoteServer.loadState;
      return this;
    });
  }

}