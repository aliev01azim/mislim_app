import 'package:aidar_zakaz/controllers/tabs_controller.dart';
import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../audio_screen.dart';
import '../category_screen.dart';

class Favorites extends GetView<TabsController> {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Избранные'),
          centerTitle: true,
          toolbarHeight: 40,
          bottom: TabBar(
            labelPadding: const EdgeInsets.only(bottom: 10),
            tabs: const [
              Text(
                'Лекции',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Категории',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Шейхи',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
            onTap: (value) => controller.changePage2(value),
          ),
        ),
        body: const TabBarView(children: [
          Favs('lectures'),
          Favs('categories'),
          Favs('shahes'),
        ]),
        bottomSheet: const SafeArea(child: MiniPlayer()),
      ),
    );
  }
}

class Favs extends StatelessWidget {
  const Favs(this.type, {Key? key}) : super(key: key);
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (_, Box box, child) {
          List items;
          if (type == 'lectures') {
            items = box.get('likedLectures', defaultValue: []) as List;
          } else if (type == 'categories') {
            items = box.get('likedCategories', defaultValue: []) as List;
          } else {
            items = box.get('likedShahes', defaultValue: []) as List;
          }
          return items.isEmpty
              ? const Center(
                  child: Text('no audio yet'),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) => Dismissible(
                    key: Key(items[index]['id'].toString()),
                    background: Expanded(
                      child: Container(
                        color: currentTheme.currentColor(),
                      ),
                    ),
                    child: ListTile(
                      leading: Card(
                        elevation: items[index]['image'] != null ? 5 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: items[index]['image'] != null
                            ? CachedNetworkImage(
                                errorWidget: (context, _, __) => const Image(
                                  image: AssetImage(
                                      'assets/images/placeholder.jpg'),
                                ),
                                imageUrl: items[index]['image']
                                    .toString()
                                    .replaceAll('http:', 'https:'),
                                placeholder: (context, url) => const Image(
                                  image: AssetImage(
                                      'assets/images/placeholder.jpg'),
                                ),
                              )
                            : Container(
                                color: Theme.of(context).canvasColor,
                                child:
                                    SvgPicture.asset('assets/images/man.svg'),
                                width: 50,
                              ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          items.remove(items[index]);
                          if (type == 'lectures') {
                            await box.put('likedLectures', items);
                          } else if (type == 'categories') {
                            box.put('likedCategories', items);
                          } else {
                            box.put('likedShahes', items);
                          }
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      title: items[index]["title"] != null
                          ? Text(
                              '${items[index]["title"]}',
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              '${items[index]["name"]}',
                              overflow: TextOverflow.ellipsis,
                            ),
                      subtitle: items[index]["artist"] != null
                          ? Text(
                              '${items[index]["artist"]}',
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      onTap: () {
                        if (type == 'lectures') {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => PlayScreen(
                                data: {
                                  'response': items,
                                  'index': index,
                                  'offline': false,
                                },
                                fromMiniplayer: false,
                              ),
                            ),
                          );
                        } else if (type == 'categories') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(items[index]),
                            ),
                          );
                        } else {
                          (items[index] as Map<String, dynamic>)
                              .addAll({'categoryImage': items[index]['image']});
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(items[index]),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
