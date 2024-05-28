import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveFile(String fileName, String content) async {
  Directory? directory;
  File? file;
  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // فولدر دانلود - تنها برای اندروید - API > 30
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    bool hasExisted = await directory.exists();
    if (!hasExisted) {
      directory.create();
    }

    // فایل برای ذخیره
    file = File("${directory.path}${Platform.pathSeparator}$fileName.txt");
    if (!file.existsSync()) {
      await file.create();
    }

    // ذخیره محتوا به صورت متنی
    await file.writeAsString(content);
  } catch (e) {
    if (file != null && file.existsSync()) {
      file.deleteSync();
    }
    rethrow;
  }
}
