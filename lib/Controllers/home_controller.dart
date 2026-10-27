import 'dart:io';

import 'package:artist_arena_app/Service/apiService.dart';
import 'package:get/get.dart';

class HomeController  extends GetxController{
RxInt selectedIndex = 0.obs;
final Apiservice apiservice=Apiservice();
final List<String> titles = [
  'Home',
  'Search',
  'Create',
  'Profile',
  'Setting',
];

void changeIndex(int index) {
  selectedIndex.value = index;
}

String get currentTitle {
  return titles[selectedIndex.value];
}



}