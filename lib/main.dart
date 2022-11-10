import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'app/routes/app_pages.dart';

final getIt = GetIt.instance;

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
