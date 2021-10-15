import 'package:aidar_zakaz/all_about_audio/services/download.dart';
import 'package:flutter/material.dart';

class DownloadButton extends StatefulWidget {
  final Map data;
  final String? icon;
  const DownloadButton({Key? key, required this.data, this.icon})
      : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  Download down = Download();

  @override
  void initState() {
    super.initState();
    down.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
          child: (down.lastDownloadId == widget.data['id'])
              ? IconButton(
                  icon: Icon(widget.icon == 'download'
                      ? Icons.download_done_rounded
                      : Icons.save_alt),
                  tooltip: 'Скачано',
                  color: Theme.of(context).colorScheme.secondary,
                  iconSize: 25.0,
                  onPressed: () {},
                )
              : down.progress == 0
                  ? Center(
                      child: IconButton(
                          icon: Icon(widget.icon == 'download'
                              ? Icons.download_rounded
                              : Icons.save_alt),
                          iconSize: 25.0,
                          color: Theme.of(context).iconTheme.color,
                          tooltip: 'Скачать',
                          onPressed: () {
                            down.prepareDownload(context, widget.data);
                          }))
                  : Stack(
                      children: [
                        Center(
                          child: Text(down.progress == null
                              ? '0%'
                              : '${(100 * down.progress!).round()}%'),
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary),
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                      ],
                    )),
    );
  }
}
