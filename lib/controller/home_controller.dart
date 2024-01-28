import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_downloader/model/data/playlist_model.dart';
import 'package:video_downloader/resource/download_type_enum.dart';
import 'package:video_downloader/utils/download_manager.dart';
import 'package:video_downloader/utils/youtube_helper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeController extends GetxController {
  YoutubeHelper youtubeHelper = YoutubeHelper();
  TextEditingController urlController = TextEditingController();
  Rx<DownloadType> downloadTypeView = DownloadType.mp4.obs;
  RxBool isSelected = false.obs;
  RxString videoID = ''.obs;
  RxString videoTitle = ''.obs;
  RxBool isUrlEmpty = true.obs;
  RxBool isLoading = false.obs;

  @override
  void dispose() {
    super.dispose();
    urlController.dispose();
  }

  changeType(Set<DownloadType> newSelected) {
    if (newSelected.isNotEmpty) {
      isSelected.value = true;
      downloadTypeView.value = newSelected.first;
    } else {
      isSelected.value = false;
    }
  }

  /// Past Text form copy
  void pastText() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata!.text!.isEmpty) {
      Get.snackbar("Warning", "You have no copy link!");
    } else {
      urlController.text = cdata.text!;
      isUrlEmpty.value = false;
    }
  }

  /// Remove text from TextField
  void removeText() {
    urlController.text = "";
    isUrlEmpty.value = true;
    videoID.value = '';
  }

  /// Get Video Info
  Future<void> getVideoInfo(url) async {
    try {
      isLoading(true);
      var youtubeInfo = YoutubeExplode();
      var video = await youtubeInfo.videos.get(url);
      videoID.value = video.id.toString();
      videoTitle.value = video.title;
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        "Warning",
        "Your link is wrong!",
        backgroundColor: Colors.red,
      );
      print("Error Video");
      videoID.value = '';
      videoTitle.value = '';
    } finally {
      isLoading(false);
    }
  }

  //download function
  Future<void> downloadVideo(url) async {
    var permission = await Permission.manageExternalStorage.request();
    if (permission.isGranted) {
      print("Download");
      try {
        Video video = await YoutubeExplode().videos.get(url);
        PlayListModel listModel = PlayListModel();
        listModel.setVideo(video);
        youtubeHelper.newPlayList.add(listModel);
        youtubeHelper.newPlayList.refresh();
        youtubeHelper.loaded.value = true;
        int index = youtubeHelper.newPlayList.length - 1;
        downloadPlaylistVideo(video, index, downloadTypeView.value);
      } catch (error) {
        Get.showSnackbar(const GetSnackBar(
          title: "Invalid Video Url",
          message: "Invalid Youtube video ID or URL",
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        ));
      }
    } else {
      print("no grant Storage");
      await Permission.manageExternalStorage.request();
    }
  }

  downloadPlaylistVideo(Video videoD, index, type) async {
    try {
      var youtubeExplode = YoutubeExplode();
      var manifest =
          await youtubeExplode.videos.streamsClient.getManifest(videoD.url);
      var video = await youtubeExplode.videos.get(videoD.url);
      //var video = manifest.muxed.elementAt(qualityNo);

      var streams = type == DownloadType.mp3
          ? manifest.audio.withHighestBitrate()
          : manifest.muxed.withHighestBitrate();
      var audio = streams;
      var audioStream = youtubeExplode.videos.streamsClient.get(audio);

      var fileName = videoD.title;
      //var vidStream = yt.videos.streamsClient.get(video);
      // String appDocPath = appDocDir.path;

      if (await requestPermission(Permission.manageExternalStorage)) {
        Directory dir =
            Directory('/storage/emulated/0/Download/YoutubeDownloader');

        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        String extention = type == DownloadType.mp3 ? 'mp3' : 'mp4';
        var file = File('${dir.path}/$fileName.$extention');
        if (file.existsSync()) {
          file.deleteSync();
        }
        print(index);
        print(youtubeHelper.newPlayList);
        print(youtubeHelper.newPlayList.elementAt(index).video.title);
        youtubeHelper.newPlayList.elementAt(index).setDownloadStart(true);
        youtubeHelper.newPlayList.elementAt(index).setDownloading(true);
        youtubeHelper.newPlayList.refresh();
        print("test");
        var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);

        var len = audio.size.totalBytes;
        var count = 0;

        await for (final data in audioStream) {
          count += data.length;
          var progress = ((count / len) * 100).ceil();
          youtubeHelper.newPlayList.elementAt(index).setProgressBar(progress);
          youtubeHelper.newPlayList.refresh();
          fileStream.add(data);
        }
        youtubeHelper.newPlayList.elementAt(index).setDownloading(false);
        youtubeHelper.newPlayList.elementAt(index).setCompleted(true);
        youtubeHelper.newPlayList.removeAt(index);
        await fileStream.flush();
        await fileStream.close();
      }
    } catch (e) {
      e.printError();
    }
  }
}
