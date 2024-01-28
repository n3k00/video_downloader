import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_downloader/controller/main_wrapper_controller.dart';
import 'package:video_downloader/resource/dimen.dart';
import 'package:video_downloader/view/download_page.dart';
import 'package:video_downloader/view/home_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainWrapper extends StatelessWidget {
  final MainWrapperController controller = Get.put(MainWrapperController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.currentPage.value == 0 ? "Home" : "Download",
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.animatedToTab,
        children: [
          HomePage(),
          DownloadPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        notchMargin: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomAppBarItem(
                    context,
                    icon: Icons.home,
                    page: 0,
                    label: "Home",
                  ),
                  _bottomAppBarItem(
                    context,
                    icon: Icons.download,
                    page: 1,
                    label: "Download",
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required icon,
    required page,
    required label,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              icon,
              color: controller.currentPage == page
                  ? Colors.lightBlueAccent
                  : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: controller.currentPage == page
                    ? Colors.lightBlueAccent
                    : Colors.grey,
                fontWeight:
                    controller.currentPage == page ? FontWeight.w600 : null,
                fontSize: TEXT_REGULAR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
