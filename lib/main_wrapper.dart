import 'package:flutter/material.dart';
import 'package:video_downloader/view/download_page.dart';
import 'package:video_downloader/view/home_page.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [HomePage(), DownloadPage()],
      ),
    );
  }
}
