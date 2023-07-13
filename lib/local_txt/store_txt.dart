import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ProfileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/health_profile.txt');
  }

  Future<File> writeProfile(String year, String month, String day,
      String height, String weight) async {
    final file = await _localFile;
    var recordString = '$year,$month,$day,$height,$weight\n';
    // Write the file
    try {
      return file.writeAsString(recordString, mode: FileMode.append);
    } catch (e) {
      print('파일을 새로 작성합니다.');
      return file.writeAsString(recordString, mode: FileMode.write);
    }
  }
}
