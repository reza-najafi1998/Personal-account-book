
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

 Future saveFile(String fileName, List<int> bytes) async {
    Directory? directory;
    File? file;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        //downloads folder - android only - API>30
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }


      bool hasExisted = await directory.exists();
      if (!hasExisted) {
        directory.create();
      }

      //file to saved
      file = File("${directory.path}${Platform.pathSeparator}$fileName.txt");
      if (!file.existsSync()) {
        await file.create();
      }
      file.writeAsBytesSync(bytes);
    } catch (e) {
      if (file != null && file.existsSync()) {
        file.deleteSync();
      }
      rethrow;
    }
  }