import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_downloader/controller/home_controller.dart';
import 'package:video_downloader/resource/constant.dart';
import 'package:video_downloader/utils/video_helper.dart';

import '../utils/download_manager.dart';

class DownloadPage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => controller.youtubeHelper.loaded.value
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: controller.youtubeHelper.newPlayList.length,
                itemBuilder: (context, i) {
                  int index =
                      controller.youtubeHelper.newPlayList.length - (i + 1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(4),
                      leading: Image.network(
                          "$IMAGE_URL${controller.youtubeHelper.newPlayList.elementAt(index).getVideo.id}$IMAGE_EXTENSION"),
                      title: Center(
                        child: Text(
                            controller.youtubeHelper.newPlayList
                                .elementAt(index)
                                .getVideo
                                .title,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13)),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: controller.youtubeHelper.newPlayList
                                .elementAt(index)
                                .downloading
                            ? IconButton(
                                splashRadius: 24,
                                onPressed: () {
                                  controller.youtubeHelper.newPlayList
                                      .elementAt(index)
                                      .cancelDownload;
                                  controller.youtubeHelper.newPlayList
                                      .removeAt(index);
                                },
                                icon: const Icon(Icons.pause),
                              )
                            : controller.youtubeHelper.newPlayList
                                    .elementAt(index)
                                    .getCompleted
                                ? const CircleAvatar(
                                    maxRadius: 12,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.done,
                                      size: 16,
                                      color: Colors.white,
                                    ))
                                : IconButton(
                                    splashRadius: 24,
                                    onPressed: () {
                                      controller.downloadPlaylistVideo(
                                          controller.youtubeHelper.newPlayList
                                              .elementAt(index)
                                              .getVideo,
                                          index,
                                          controller.downloadTypeView.value);
                                    },
                                    icon: const Icon(Icons.download),
                                  ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: controller.youtubeHelper.newPlayList
                                .elementAt(index)
                                .getDownloadStart
                            ? controller.youtubeHelper.newPlayList
                                    .elementAt(index)
                                    .getCompleted
                                ? const Center(
                                    child: Text(
                                      "Completed!",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Center(
                                    child: LinearPercentIndicator(
                                      lineHeight: 12.0,
                                      percent: controller
                                              .youtubeHelper.newPlayList
                                              .elementAt(index)
                                              .getProgressBar
                                              .toDouble() /
                                          100,
                                      barRadius: const Radius.circular(50),
                                      center: Text(
                                        "${controller.youtubeHelper.newPlayList.elementAt(index).getProgressBar}%",
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                      progressColor: Colors.black,
                                    ),
                                  )
                            : Placeholder(),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text("There is no download song"),
              )),
        Expanded(
          child: FutureBuilder(
            future: VideoHelper.getVideoFiles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                          trailing: const CircleAvatar(
                              maxRadius: 12,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.done,
                                size: 16,
                              )),
                          leading: FutureBuilder(
                            future: VideoHelper.getVideoThumbnail(
                                snapshot.data!.elementAt(index).path),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data! != '') {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    child: Image(
                                      image: FileImage(
                                        File(snapshot.data!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return Image.asset(
                                      'assets/images/thumbnail.png');
                                }
                              } else {
                                return Image.asset('assets/images/loading.gif');
                              }
                            },
                          ),
                          title: Text(
                            snapshot.data!
                                .elementAt(index)
                                .path
                                .split('/')
                                .last,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: const Center(
                            child: Text(
                              "Completed!",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ));
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
