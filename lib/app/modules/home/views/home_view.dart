import 'package:asigment_demo/app/modules/home/views/data_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constants/sizeConstant.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Home View"),
        ),
        body: (controller.isAuth.value)
            ? (controller.hasData.value)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: (isNullEmptyOrFalse(controller.ApiList))
                        ? Center(
                            child: Text("No Data Available"),
                          )
                        : DataListScreen(homeController: controller),
                  )
            : Container(
                height: MySize.safeHeight,
                width: MySize.safeWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.checkAuth();
                      },
                      child: Container(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: MySize.getHeight(50),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      );
    });
  }
}
