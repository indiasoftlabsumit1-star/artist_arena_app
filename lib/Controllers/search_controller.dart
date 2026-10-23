


import 'package:get/get.dart';

class SearchController extends GetxController {
  Rxn<Map<String, String>> selectedItem = Rxn<Map<String, String>>();

  void selectItem(Map<String, String> item) {
    selectedItem.value = item;
  }

  void clearSelection() {
    selectedItem.value = null;
  }
}