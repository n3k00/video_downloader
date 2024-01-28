import 'package:get/get.dart';
import 'package:video_downloader/controller/permission_controller.dart';
import 'package:video_downloader/utils/playlist_helper.dart';
import 'package:video_downloader/utils/youtube_helper.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionController());
    Get.put(YoutubeHelper());
    Get.put(PlaylistHelper());
    /*Get.put(NetworkController());
    Get.put(ShareReceiveController());*/
  }
}
