import 'package:get/get.dart';
import 'package:video_downloader/model/data/playlist_model.dart';

class YoutubeHelper extends GetxController {
  RxBool loaded = false.obs;
  RxBool loading = false.obs;
  RxList<PlayListModel> newPlayList = RxList();
}
