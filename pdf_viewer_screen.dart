import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  PdfViewerScreen({required this.url});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    final filename = widget.url.split('/').last;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$filename');

    if (!await file.exists()) {
      var response = await http.get(Uri.parse(widget.url));
      await file.writeAsBytes(response.bodyBytes);
    }

    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('عرض PDF')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath),
    );
  }
}