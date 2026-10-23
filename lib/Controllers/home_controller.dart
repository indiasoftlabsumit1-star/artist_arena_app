import 'package:get/get.dart';

class HomeController  extends GetxController{
RxInt selectedIndex = 0.obs;

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