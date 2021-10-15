import 'package:aidar_zakaz/bindings/poisk_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:aidar_zakaz/screens/poisk_screen.dart';
import 'package:aidar_zakaz/widgets/look_grid_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<PoiskController> {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 65,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Поиск',
                  style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              stretch: true,
              toolbarHeight: 65,
              title: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    height: 52.0,
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).cardColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(1.5, 1.5),
                        )
                      ],
                    ),
                    child: Row(children: [
                      const SizedBox(width: 10.0),
                      Icon(
                        CupertinoIcons.search,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'Лекции, шейхи и категории',
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: -0.7,
                          color: Theme.of(context).textTheme.caption!.color,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]),
                  ),
                  onTap: () => Get.to(() => const PoiskScreen(),
                      binding: PoiskScreenBinding(),
                      transition: Transition.fadeIn),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14, bottom: 20),
                child: Text(
                  'Все темы:',
                  style: TextStyle(fontSize: 20, fontFamily: 'IBM Plex Sans'),
                ),
              ),
              GetBuilder<HomeScreenController>(
                builder: (homeController) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15),
                      itemBuilder: (context, index) =>
                          LookGridItem(homeController.items[index], index),
                      itemCount: homeController.items.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
