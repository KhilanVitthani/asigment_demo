import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Container(
          height: MediaQuery.of(context).size.height,
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
                  child: ListView.builder(
                    itemCount: controller.Apilist.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(padding: EdgeInsets.all(18)),
                          Row(
                            children: [
                              Text(controller.Apilist[index].name.toString(),
                                  style: TextStyle(fontSize: 15)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(index.toString()),
                            ],
                          ),
                        ],
                      );
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
