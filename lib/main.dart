import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_downloader/controller/permission_binding.dart';
import 'package:video_downloader/main_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Video Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialBinding: PermissionBinding(),
      home: MainWrapper(),
    );
  }
}
