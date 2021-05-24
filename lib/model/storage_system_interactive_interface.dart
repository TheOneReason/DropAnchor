import 'dart:async';

import 'package:drop_anchor/model/service_source.dart';

import 'api_res_package.dart';
import 'index_source.dart';

abstract class StorageSystemInteractiveInterface {

  Future<bool> uploadFile(IndexSource indexSource) {
    throw UnimplementedError();
  }

  Future<bool> downloadFile() {
    throw UnimplementedError();
  }


  Future<Iterable<int>> getFileContent({required IndexSource fromIndexSource }) {
    throw UnimplementedError();
  }

  Future<bool> createDir(){
    throw UnimplementedError();
  }

  Future<bool> delete(IndexSource targetIndexSource) {
    throw UnimplementedError();
  }

  Future<bool> rename() {
    throw UnimplementedError();
  }
  Future<ApiResPackage> getServerPublicDataIndex(){
    throw UnimplementedError();
  }
}
