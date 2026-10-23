



import 'package:artist_arena_app/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Screens/my_story_screen.dart';
import '../Utils/appThemeStyle.dart';

class CustomBottomNav extends StatelessWidget {
  CustomBottomNav({super.key});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        // final double width=constraints.maxWidth;
        // final double height=constraints.maxHeight;
        // final bool landScape=width>500&&width<900;
        return Obx(
              () => Container(
                // height: landScape?40:null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(21.sp),
                topLeft: Radius.circular(21.sp),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(21.sp),
                topLeft: Radius.circular(21.sp),
              ),
              child: BottomNavigationBar(


                currentIndex: homeController.selectedIndex.value,
                onTap: (index) {
                  if (index == 2) {
                    Get.to(() => MyStoryScreen());
                    return;
                  }

                  homeController.changeIndex(index);
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.white,
                selectedIconTheme: IconThemeData(
                  color: AppColores.custtombtnColor,
                ),
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,

                        ),
                        padding: EdgeInsets.all(15.sp),
                        child: const Icon(Icons.add,color: Colors.white,)),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: '',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


class CustomRightNav extends StatelessWidget {
  const CustomRightNav({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(
          () => Container(
        width: 60,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            bottomLeft: Radius.circular(15.sp),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(-2, 0),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => homeController.changeIndex(0),
              icon: Icon(
                Icons.home_outlined,
                color: homeController.selectedIndex.value == 0
                    ? AppColores.custtombtnColor
                    : Colors.black54,
              ),
            ),
            IconButton(
              onPressed: () => homeController.changeIndex(1),
              icon: Icon(
                Icons.search_outlined,
                color: homeController.selectedIndex.value == 1
                    ? AppColores.custtombtnColor
                    : Colors.black54,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => MyStoryScreen()),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
            IconButton(
              onPressed: () => homeController.changeIndex(3),
              icon: Icon(
                Icons.person_outline,
                color: homeController.selectedIndex.value == 3
                    ? AppColores.custtombtnColor
                    : Colors.black54,
              ),
            ),
            IconButton(
              onPressed: () => homeController.changeIndex(4),
              icon: Icon(
                Icons.settings_outlined,
                color: homeController.selectedIndex.value == 4
                    ? AppColores.custtombtnColor
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}