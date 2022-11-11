import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:asigment_demo/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:asigment_demo/app/models/Api_models.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../utilities/progress_dialog_utils.dart';

class HomeController extends GetxController {
  RxList<Apimodels> ApiList = RxList<Apimodels>([]);
  Apimodels apimodels = Apimodels();
  RxList<BiometricType> availableBiometric = RxList<BiometricType>([]);
  RxInt page = 1.obs;
  RxBool hasData = false.obs;
  RxBool isAuth = false.obs;
  RxBool isEnablePullUp = true.obs;
  RxBool canCheckBiometric = false.obs;
  RxBool pagenation = false.obs;
  RefreshController refreshController = RefreshController();
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> onInit() async {
    var connectivity = await Connectivity().checkConnectivity();
    canCheckBiometric.value = await auth.canCheckBiometrics;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (connectivity != ConnectivityResult.none) {
        assigmrntApi();
      } else {
        showAnimatedDialog(
          context: Get.context!,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[100],
              title: Center(
                child: Text("Error"),
              ),
              contentPadding: EdgeInsets.only(left: 60, top: 10),
              actions: [
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("OK")),
                )
              ],
              content: Text("No Internet Connection"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            );
          },
          animationType: DialogTransitionType.slideFromTop,
          curve: Curves.easeIn,
          duration: Duration(seconds: 1),
        );
        getDataFromLocalDatabase(context: Get.context!);
      }
    });
    super.onInit();
  }

  checkAuth() async {
    try {
      await auth.getAvailableBiometrics().then((value) {
        if (!isNullEmptyOrFalse(value)) {
          availableBiometric.value = value;
        }
      });
    } on PlatformException catch (e) {
      getIt<CustomDialogs>().getDialog(
          title: "Failed",
          desc: "Please enable security feature on your device.");
      print(e);
    }
    try {
      await auth
          .authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
        options: AuthenticationOptions(
          biometricOnly: false,
        ),
      )
          .then((value) {
        if (!isNullEmptyOrFalse(value)) {
          isAuth.value = true;
        }
      });
    } catch (e) {
      PlatformException error = e as PlatformException;
      if (error.code == "auth_in_progress") {
        getIt<CustomDialogs>()
            .getDialog(title: "Failed", desc: "${error.message}");
      }
      print(e);
    }
  }

  assigmrntApi({bool isForLoading = false}) async {
    if (isForLoading) {
      isEnablePullUp.value = true;
      page.value++;
      hasData.value = false;
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
            ApiList.add(res);
            pagenation.value = true;
          });
        }
        if (!isNullEmptyOrFalse(ApiList)) {
          box.write(ArgumentConstant.data, jsonEncode(ApiList));
          print("Local data 2 := ${box.read(ArgumentConstant.data)}");
        }
        // print(result);
        if (isForLoading) {
          refreshController.loadComplete();
        }
      } else {
        if (isForLoading) {
          refreshController.loadComplete();
          isEnablePullUp.value = false;
        }
        hasData.value = true;
      }
    }).catchError((error) {
      hasData.value = true;
      print(error);
    });
  }

  getDataFromLocalDatabase({required BuildContext context}) {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.data))) {
      ApiList.clear();
      List<dynamic> TempList = jsonDecode(box.read(ArgumentConstant.data));
      print(box.read(ArgumentConstant.data).runtimeType);

      if (!isNullEmptyOrFalse(TempList)) {
        TempList.forEach((element) {
          Apimodels res = Apimodels.fromJson(element);
          ApiList.add(res);
        });
      }
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
