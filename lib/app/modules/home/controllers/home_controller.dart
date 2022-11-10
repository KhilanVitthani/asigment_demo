import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:asigment_demo/app/models/Api_models.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  RxList<Apimodels> Apilist = RxList<Apimodels>([]);
  Apimodels apimodels = Apimodels();
  RxInt page = 0.obs;
  RxBool hasData = false.obs;
  RxBool isEnablePullUp = true.obs;
  RxBool pagenation = false.obs;
  RefreshController refreshController = RefreshController();
  void onInit() {
    assigmrntApi();
    super.onInit();
  }

  assigmrntApi({bool isLoading = false}) async {
    if (!isLoading) {
      hasData.value = false;
      isEnablePullUp.value = true;
      page.value = 1;
      //Apilist.clear();
    }
    var url = Uri.parse(
        "https://api.github.com/users/JakeWharton/repos?page=${page.value}&per_page=15");
    var response = await http.get(url);
    print(response.body.runtimeType);
    List<dynamic> data = jsonDecode(response.body);
    if (!isNullEmptyOrFalse(data)) {
      data.forEach((element) {
        Apimodels res = Apimodels.fromJson(element);
        Apilist.add(res);
        pagenation.value = true;

        hasData.value = true;
      });
      page.value = Apilist.length;
      if (isLoading) {}
    } else {
      if (isLoading) {
        isEnablePullUp.value = false;
      }
      hasData.value = true;
    }
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
