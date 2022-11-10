import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:asigment_demo/app/models/Api_models.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../constants/api_constants.dart';

class HomeController extends GetxController {
  RxList<Apimodels> Apilist = RxList<Apimodels>([]);
  Apimodels apimodels = Apimodels();
  RxInt page = 1.obs;
  RxBool hasData = false.obs;
  RxBool isEnablePullUp = true.obs;
  RxBool pagenation = false.obs;
  RefreshController refreshController = RefreshController();
  void onInit() {
    assigmrntApi();
    super.onInit();
  }

  assigmrntApi({bool isForLoading = false}) async {
    if (isForLoading) {
      isEnablePullUp.value = true;
      page.value++;
      //Apilist.clear();
    }
    pagenation.value = false;
    var url = Uri.parse(
        baseUrl + ApiConstant.getGitList + "?page=${page.value}&per_page=15");
    var response;
    await http.get(url).then((value) async {
      if (value.statusCode == 200) {
        response = value;
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        List<dynamic> result = jsonDecode(response.body);
        if (!isNullEmptyOrFalse(result)) {
          result.forEach((element) {
            Apimodels res = Apimodels.fromJson(element);
            Apilist.add(res);
            pagenation.value = true;
          });
        }

        print(result);
        if (isForLoading) {
          refreshController.loadComplete();
        }
      } else {
        if (isForLoading) {
          refreshController.loadComplete();
          isEnablePullUp.value = false;
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}
