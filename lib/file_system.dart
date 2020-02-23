import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';

class FileSystem {
  Future<Directory> get _appDir async => await getApplicationDocumentsDirectory();

  Future<String> get databasePath async => "${(await this._appDir).path}/JumpRope.db";

  Future<Directory> get mediaDir async => await this._getMediaDir();

  Future<Directory> _getMediaDir() async {
    final mediaDirPath = "${(await this._appDir).path}/media";
    final mediaDir = Directory(mediaDirPath);
    if (await mediaDir.exists()) {
      return mediaDir;
    } else {
      await mediaDir.create(recursive: true);
      return mediaDir;
    }
  }

  Future<bool> exists(String path) async {
    return await File(path).exists();
  }

  Future<String> getMediaFilePath(String fileName) async {
    if (fileName == null) {
      fileName = "${formatDate(DateTime.now().toUtc(),
          [yyyy, "-", mm, "-", dd, "_", HH, ":", nn, ":", ss])}.mp4";
    }

    if (fileName.endsWith(".mp4")) {
      fileName += ".mp4";
    }

    return "${await this.mediaDir}/$fileName";
  }
}
