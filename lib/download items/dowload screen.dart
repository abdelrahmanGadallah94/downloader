import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter/material.dart';

class Download extends StatefulWidget {
const Download({Key? key}) : super(key: key);

@override
State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

  final TextEditingController urlController = TextEditingController();
  final TextEditingController _txt = TextEditingController();

  int progress = 0;
  late StreamSubscription progressStream;

  @override
  void initState() {
    FlDownloader.initialize();
    progressStream = FlDownloader.progressStream.listen((event) {
      if (event.status == DownloadStatus.successful) {
        setState(() {
          progress = event.progress;
        });
        FlDownloader.openFile(
          filePath: event.filePath,
        );
      } else if (event.status == DownloadStatus.running) {
        setState(() {
          progress = event.progress;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    progressStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Center(child: const Text('Downloader App')),
        ),
        body: Column(
          children: [
            if (progress > 0 && progress < 100)
              LinearProgressIndicator(
                value: progress / 100,
                color: Colors.orange,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: urlController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _txt,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FlDownloader.download(urlController.text,
                    fileName: _txt.text);
              },
              child: Icon(Icons.file_download),
            )
          ],
        ),
      ),
    );
  }
}
