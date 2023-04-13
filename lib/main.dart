import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final sampleUrl =
      'https://mini-iac.org/downloads/sequences/2023-knowns/download-file?path=2023+Unlimited.pdf';

  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('PDF Caching Test'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                    onPressed: loadPdf, child: const Text("Load pdf")),
                if (pdfFlePath != null)
                  Expanded(child: PdfView(path: pdfFlePath!))
                else
                  const Text("Pdf is not Loaded"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
