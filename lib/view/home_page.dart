import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_downloader/controller/home_controller.dart';
import 'package:video_downloader/resource/constant.dart';
import 'package:video_downloader/resource/dimen.dart';
import 'package:video_downloader/resource/download_type_enum.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.isLoading.value,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2,
            vertical: MARGIN_MEDIUM,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Enter Youtube URL",
                    style: TextStyle(
                      fontSize: TEXT_REGULAR_2X,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MARGIN_MEDIUM_2),
                  TextField(
                    controller: controller.urlController,
                    decoration: InputDecoration(
                      hintText: "Enter Youtube Link/URL",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_10),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: Obx(
                        () {
                          if (controller.isUrlEmpty.value) {
                            return IconButton(
                              icon: Icon(FontAwesomeIcons.link),
                              onPressed: controller.pastText,
                            );
                          } else {
                            return IconButton(
                              icon: Icon(FontAwesomeIcons.xmark),
                              onPressed: controller.removeText,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MARGIN_MEDIUM_2),
                  MaterialButton(
                    onPressed: () {
                      controller.getVideoInfo(controller.urlController.text);
                    },
                    color: Colors.lightBlueAccent,
                    height: 45,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_10),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        )),
                    child: Text(
                      "Generate Video Content",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: MARGIN_MEDIUM_2),
                  Obx(() => SegmentedButton<DownloadType>(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(MARGIN_MEDIUM_10),
                            ),
                          ),
                        ),
                        emptySelectionAllowed: true,
                        segments: const <ButtonSegment<DownloadType>>[
                          ButtonSegment<DownloadType>(
                            value: DownloadType.mp4,
                            label: Text('mp4(HD)'),
                          ),
                          /*ButtonSegment<DownloadType>(
                          value: DownloadType.sd,
                          label: Text('mp4(SD)'),
                        ),*/
                          ButtonSegment<DownloadType>(
                            value: DownloadType.mp3,
                            label: Text('mp3'),
                          ),
                        ],
                        selected: controller.isSelected.value
                            ? <DownloadType>{controller.downloadTypeView.value}
                            : <DownloadType>{},
                        onSelectionChanged: (Set<DownloadType> newSelection) {
                          controller.changeType(newSelection);
                        },
                      )),
                  SizedBox(height: MARGIN_MEDIUM_2),
                  Obx(() {
                    if (controller.videoID.isEmpty) {
                      return DottedBorder(
                        color: Colors.black,
                        borderType: BorderType.RRect,
                        strokeWidth: 1,
                        radius: Radius.circular(MARGIN_MEDIUM_10),
                        dashPattern: [3, 6],
                        child: Container(
                            height: 250,
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.film),
                                  Text("Video Preview goes here"),
                                ],
                              ),
                            )),
                      );
                    } else {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MARGIN_MEDIUM_10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "$IMAGE_URL${controller.videoID}$IMAGE_EXTENSION"),
                              fit: BoxFit.fill,
                            )),
                      );
                    }
                  }),
                  SizedBox(height: MARGIN_MEDIUM_2),
                ],
              ),
              Positioned(
                bottom: MARGIN_MEDIUM_2,
                right: 0,
                left: 0,
                child: MaterialButton(
                  onPressed: () {
                    controller.downloadVideo(controller.urlController.text);
                  },
                  color: Colors.lightBlueAccent,
                  height: 45,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MARGIN_MEDIUM_10),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  child: Text(
                    "Download Video",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
