import 'package:asigment_demo/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constants/sizeConstant.dart';

class DataListScreen extends StatefulWidget {
  DataListScreen({required this.homeController, Key? key}) : super(key: key);
  HomeController homeController;

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  HomeController controller = HomeController();
  @override
  void initState() {
    controller = widget.homeController;
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: MySize.safeHeight,
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  controller: controller.refreshController,
                  enablePullDown: false,
                  enablePullUp: controller.isEnablePullUp.value,
                  onLoading: () {
                    if (controller.pagenation.value) {
                      controller.assigmrntApi(isForLoading: true);
                    } else {
                      controller.refreshController.loadComplete();
                    }
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: MySize.getHeight(5),
                      );
                    },
                    itemCount: controller.ApiList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MySize.getWidth(8),
                          ),
                          child: AnimationLimiter(
                              child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(seconds: 1),
                                childAnimationBuilder: (p0) => FlipAnimation(
                                      child: SlideAnimation(
                                        child: FadeInAnimation(
                                          child: p0,
                                        ),
                                      ),
                                    ),
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Icon(Icons.book,
                                            size: MySize.getHeight(50)),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MySize.getWidth(270),
                                                child: Text(
                                                  controller.ApiList[index].name
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize:
                                                        MySize.getHeight(15),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(index.toString()),
                                            ],
                                          ),
                                          Container(
                                            width: MySize.getWidth(300),
                                            child: Text(
                                              controller.ApiList[index]
                                                      .description ??
                                                  "".toString(),
                                              style: TextStyle(
                                                fontSize: MySize.getHeight(12),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          )));
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
