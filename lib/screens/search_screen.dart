import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemBuilder: (i, a) => Text(
            'dasdasdasdasdasdddddddddd',
            style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
          ),
          itemCount: 10,
        ));
  }
}
