import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:aidar_zakaz/widgets/detail_listview_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDetailScreen extends GetView<HomeScreenController> {
  const CategoryDetailScreen(this.item, {Key? key}) : super(key: key);
  final ListviewItemModel item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (_, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              actions: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  ],
                )
              ],
              elevation: 0,
              backgroundColor: const Color.fromRGBO(29, 185, 84, 0.5),
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Color.fromRGBO(29, 185, 84, 0.5),
                      Color.fromRGBO(158, 196, 209, 0),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 27,
                    ),
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            item.url,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.play_circle),
                  label: Icon(Icons.shuffle)),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (_, index) =>
                    DetailListviewItem(controller.items[index]),
                itemCount: controller.items.length,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: GetBuilder<HomeScreenController>(
        builder: (_) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(18, 18, 18, 1),
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(0),
            ),
            height: !controller.isShowing ? 0 : 50,
            child: Text('asdadsadadad'),
          );
        },
      ),
    );
  }
}
