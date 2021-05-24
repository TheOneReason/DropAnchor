import 'dart:convert';
import 'dart:io';

import 'package:drop_anchor/api/server_public_data.dart';
import 'package:drop_anchor/api/state_code.dart';
import 'package:drop_anchor/error/api_error.dart';
import 'package:drop_anchor/error/local_error.dart';
import 'package:drop_anchor/model/api_res_package.dart';
import 'package:drop_anchor/model/storage_system_interactive_interface.dart';
import 'package:drop_anchor/model/token.dart';
import 'package:drop_anchor/state/device_local_storage.dart';

import 'index_source.dart';

/// 基础抽象类 [ServiceSourceBase]
/// 网络  [ServiceSource]
/// 本地  [LocalStorageServerSource]
abstract class ServiceSourceBase implements Token, StorageSystemInteractiveInterface {
  String source;
  String name;
  String agreement;
  int port;

  ServiceSourceBase(this.name, this.source, this.port,
      {this.agreement = "http"});

  Map<String, dynamic> toMap() {
    return {
      "source": source,
      "name": name,
      "port": port
    };
  }

  @override
  String token() {
    return '$source-$port';
  }

  String getUri() => "$agreement://$source:$port";


  @override
  Future<bool> delete(IndexSource targetIndexSource) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> downloadFile() {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future<Iterable<int>> getFileContent(
      {required IndexSource fromIndexSource }) async {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  Future<bool> rename() {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadFile(IndexSource indexSource) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Future<bool> createDir() {
    // TODO: implement createDir
    throw UnimplementedError();
  }

  @override
  Future<ApiResPackage> getServerPublicDataIndex() {
    // TODO: implement getServerIndex
    throw UnimplementedError();
  }

}

/// 网络来源
class ServiceSource extends ServiceSourceBase {
  ServiceSource(String name, String source, int port)
      : super(name, source, port);

  @override
  Future<Iterable<int>> getFileContent(
      {required IndexSource fromIndexSource }) async {
    // TODO: implement rename
    var _base64Data;
    final getResPackage = await getServerPublicData(
        this, fromIndexSource.getCompletePath());
    switch (getResPackage.stateCode) {
      case StateCode.RES_OK:
        _base64Data = getResPackage.data;
        return base64Decode(_base64Data!);
      case StateCode.RES_ERROR_PATH_FIND_NOT:
        throw PathFindNot(errorMessage: 'Target is Not Find');
      default:
        throw ApiErrorBash(
            errorApiStateCode: getResPackage.stateCode,
            errorMessage: "contrary to expectation state code");
    }
  }

  Future<bool> delete(IndexSource targetIndexSource)async{
    print("Network Delete ..");
    return Future.value(false);
  }

}

///本地来源
class LocalStorageServerSource implements ServiceSourceBase {
  static const String staticToken = 'LocalStorageSource';

  @override
  String agreement = "";

  @override
  String name = "LocalStorage";

  @override
  int port = 0;

  @override
  String source = "";

  LocalStorageServerSource({required this.source});

  @override
  String getUri() {
    return source;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "agreement": agreement,
      "name": name,
      "port": port,
      "source": source
    };
  }

  @override
  String token() {
    return staticToken;
  }

  @override
  ///根据IndexSource 获取路径来删除文件
  Future<bool> delete(IndexSource targetIndexSource) async {
    try {
      final targetPath = DeviceLocalStorage.getOnlyElem
          .getIndexSourceFileSystemPath(targetIndexSource);
      await File(targetPath).delete();
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> downloadFile() {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future<Iterable<int>> getFileContent({required IndexSource fromIndexSource}) {
    return Future<Iterable<int>>(() async {
      final targetPath = DeviceLocalStorage.getOnlyElem
          .getIndexSourceFileSystemPath(fromIndexSource);
      final targetFile = File(targetPath);
      final targetFileStat = await targetFile.stat();
      if (targetFileStat.type == FileSystemEntityType.file) {
        final data = await targetFile.readAsString();
        return utf8.encode(data);
      } else {
        throw LocalError(errorMessage: "Local File Type Error");
      }
    });
  }

  @override
  Future<bool> rename() {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadFile(IndexSource newIndexSource) {
    // newIndexSource.getCompletePath();
    // DeviceLocalStorage.getOnlyElem.getIndexSourceFileSystemPath(newIndexSource);
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Future<bool> createDir() {
    // TODO: implement createDir
    throw UnimplementedError();
  }

  @override
  Future<ApiResPackage> getServerPublicDataIndex() {
    // TODO: implement getServerPublicDataIndex
    throw UnimplementedError();
  }
}