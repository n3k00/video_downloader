import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_downloader/utils/download_manager.dart';

class PermissionController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initPermission();
  }

  Future<void> initPermission() async {
    try {
      if (await requestPermission(Permission.manageExternalStorage)) {
        Directory? directory1 =
            Directory('/storage/emulated/0/Download/YoutubeDownloader');
        if (!directory1.existsSync()) {
          directory1.createSync();
        }
        Directory? directory2 =
            Directory('/storage/emulated/0/Download/YoutubeDownloader/.temp');
        if (!directory2.existsSync()) {
          directory2.createSync();
        }
      }
    } catch (e) {
      e.printError();
    }
  }
}
