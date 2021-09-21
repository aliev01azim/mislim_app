import 'package:aidar_zakaz/bindings/poisk_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:aidar_zakaz/screens/poisk_screen.dart';
import 'package:aidar_zakaz/widgets/look_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<PoiskController> {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: TextField(
                onTap: () {
                  Get.to(() => const PoiskScreen(),
                      binding: PoiskScreenBinding(),
                      transition: Transition.fadeIn);
                },
                decoration: InputDecoration(
                  hintText: 'Лекции, шейхи и категории',
                  hintStyle: const TextStyle(color: Colors.black, height: 1.3),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white.withAlpha(235),
                  border: null,
                  enabledBorder: InputBorder.none,
                  disabledBorder: null,
                  errorBorder: null,
                  focusedBorder: InputBorder.none,
                ),
                readOnly: true,
                showCursor: false,
              ),
            ),
            GetBuilder<HomeScreenController>(
              builder: (homeController) {
                return Padding(
                  padding: const EdgeInsets.only(top: 90, left: 15, right: 15),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15),
                    itemBuilder: (context, index) =>
                        LookGridItem(homeController.items[index]),
                    itemCount: homeController.items.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
