import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_downloader/controller/home_controller.dart';
import 'package:video_downloader/resource/download_type_enum.dart';
import 'package:video_downloader/utils/playlist_helper.dart';
import 'package:video_downloader/utils/youtube_helper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final yt = YoutubeExplode();
// ignore: prefer_typing_uninitialized_variables
var controller = Get.find<HomeController>();

/*Future<Set> getVideoQualityList(videoUrl) async {
  var manifest = await yt.videos.streamsClient.getManifest(videoUrl);
  var video = manifest.muxed.getAllVideoQualities();
  return video;
}*/

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
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
    if (await requestPermission(Permission.manageExternalStorage)) {
      Directory dir =
          Directory('/storage/emulated/0/Download/YoutubeDownloader');

      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      var file = File('${dir.path}/$fileName');
      if (file.existsSync()) {
        file.deleteSync();
      }
      print(index);
      print(controller.youtubeHelper.newPlayList);
      print(controller.youtubeHelper.newPlayList.elementAt(index).video.title);
      controller.youtubeHelper.newPlayList
          .elementAt(index)
          .setDownloadStart(true);
      controller.youtubeHelper.newPlayList
          .elementAt(index)
          .setDownloading(true);
      controller.youtubeHelper.newPlayList.refresh();
      print("test");
      var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);

      var len = audio.size.totalBytes;
      var count = 0;

      await for (final data in audioStream) {
        count += data.length;
        var progress = ((count / len) * 100).ceil();
        controller.youtubeHelper.newPlayList
            .elementAt(index)
            .setProgressBar(progress);
        controller.youtubeHelper.newPlayList.refresh();
        fileStream.add(data);
      }
      controller.youtubeHelper.newPlayList
          .elementAt(index)
          .setDownloading(false);
      controller.youtubeHelper.newPlayList.elementAt(index).setCompleted(true);
      await fileStream.flush();
      await fileStream.close();
    }
  } catch (e) {
    e.printError();
  }
}
