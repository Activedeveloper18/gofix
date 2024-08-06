import 'package:flutter/material.dart';
import 'package:goffix/screens/home/data/homeData.dart';
import 'package:goffix/screens/home/models/homePageModel.dart';
import "package:collection/collection.dart";

class HomeProvider with ChangeNotifier {
  List<HomeItem> list = [];
  List<List<HomeItem>> homeList = [];
  List<HomeItem> servicesList = [];
  List<HomeItem> searchList = [];

  HomeProvider() {
    getHomeData();
  }

  getHomeData() async {
    String homeRawData = await HomeData.getHomeData();
    var homeData = homePageModelFromJson(homeRawData);
    list.clear();
    for (int i = 0; i < homeData.response!.result!.data!.length; i++) {
      list.add(HomeItem(
        aId: homeData.response!.result!.data![i].aId,
        aDt: homeData.response!.result!.data![i].aDt,
        aType: homeData.response!.result!.data![i].aType,
        aImg: homeData.response!.result!.data![i].aImg,
        aLink: homeData.response!.result!.data![i].aLink,
        aNote: homeData.response!.result!.data![i].aNote,
        aTitle: homeData.response!.result!.data![i].aTitle,
        aDescription: homeData.response!.result!.data![i].aDescription,
        aPrice: homeData.response!.result!.data![i].aPrice,
        aStat: homeData.response!.result!.data![i].aStat,
        aExDt: homeData.response!.result!.data![i].aExDt,
        sectionImg: homeData.response!.result!.data![i].sectionImg,
        sectionText: homeData.response!.result!.data![i].sectionText,
        verticalSqid: homeData.response!.result!.data![i].verticalSqid,
        horizontalSqid: homeData.response!.result!.data![i].horizontalSqid,
        dataId: homeData.response!.result!.data![i].dataId,
        atypeId: homeData.response!.result!.data![i].atypeId,
        atypeName: homeData.response!.result!.data![i].atypeName,
        atypeRefnum: homeData.response!.result!.data![i].atypeRefnum,
        atypeCreated: homeData.response!.result!.data![i].atypeCreated,
        atypeHeight: homeData.response!.result!.data![i].atypeHeight,
        atypeWidth: homeData.response!.result!.data![i].atypeWidth,
      ));
    }
    list.removeWhere((element) => element.verticalSqid == null);

    list.sort(
      (a, b) => int.parse(a.verticalSqid.toString()).compareTo(int.parse(b.verticalSqid.toString())),
    );
    groupBy(list, (HomeItem e) => e.verticalSqid)
        .map((key, value) => MapEntry(key, value))
        .forEach((key, value) {
      homeList.add(value);
    });

    // servicesList = homeList[0].where((element) => element.aType == 0);
    // searchList = homeList[0].where(((element) => element.aType == 2));

    notifyListeners();
  }
}
