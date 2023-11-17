import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloadOpenScreen extends StatefulWidget {
  const FileDownloadOpenScreen({super.key});

  @override
  State<FileDownloadOpenScreen> createState() => _FileDownloadOpenScreenState();
}

class _FileDownloadOpenScreenState extends State<FileDownloadOpenScreen> {
  final String fileUrl = 'https://ekspertiza.mc.uz/uploads/pay/Стр-во ДЮСШ Кегейли16105388681610783581.pdf'; // Replace with your file URL

  Future<void> _downloadAndOpenFile() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        final fileBytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();

        final file = File('${tempDir.path}/sample.pdf');

        await file.writeAsBytes(fileBytes);

        OpenFilex.open(file.path);
      } else {
        if (kDebugMode) {
          print('Error downloading file: ${response.statusCode}');
        }
      }
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Download and Open Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _downloadAndOpenFile,
          child: const Text('Download and Open File'),
        ),
      ),
    );
  }
}

