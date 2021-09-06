import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Titlee extends StatelessWidget {
  const Titlee(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontStyle: FontStyle.italic,
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
