import 'dart:io';
import 'dart:ui';

import 'package:video_thumbnail/video_thumbnail.dart';

class VideoHelper {
  static final List fileFormat = ['.mp4', '.mp3'];
  static Future<List<File>> getVideoFiles() async {
    List<File> files = [];
    Directory? directory =
        Directory('/storage/emulated/0/Download/YoutubeDownloader');
    if (await directory.exists()) {
      List<FileSystemEntity> entities = directory.listSync(recursive: true);
      for (var entity in entities) {
        if (entity is File &&
            fileFormat.any((element) => entity.path.endsWith(element))) {
          files.add(entity);
        }
      }
    } else {
      directory.createSync(recursive: true);
    }
    return files;
  }

  static Future<String> getVideoThumbnail(String path) async {
    try {
      var thumbPath = await VideoThumbnail.thumbnailFile(
        video: path,
        thumbnailPath: '/storage/emulated/0/Download/YoutubeDownloader/.temp',
        imageFormat: ImageFormat.JPEG,
        maxWidth: 360,
        quality: 25,
      );
      return thumbPath!;
    } catch (e) {
      e.toString();
    }
    return "";
  }
}
