import 'package:aidar_zakaz/controllers/library_controller.dart';
import 'package:aidar_zakaz/screens/library/download_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'liked_section.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(
        init: LibraryController(),
        builder: (controller) {
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) => [
                    const SliverAppBar(
                      elevation: 4,
                      title: TabBar(
                          labelStyle: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                          labelColor: Colors.white,
                          indicatorColor: Colors.transparent,
                          isScrollable: true,
                          tabs: [
                            Text("Скачанные"),
                            Text("Избранные"),
                          ]),
                    ),
                  ],
                  body: const TabBarView(children: [
                    DownloadSection(),
                    MusicTabSection(),
                  ]),
                ),
              ));
        });
  }
}
