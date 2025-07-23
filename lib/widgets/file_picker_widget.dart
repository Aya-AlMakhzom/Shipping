import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../controller/shipment-controller.dart';

class FilePickerWidget extends StatelessWidget {
  final ShipmentController controller;

  const FilePickerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final file = controller.selectedFile.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.attach_file),
            label: const Text("اختيار ملف"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null && result.files.single.path != null) {
                controller.selectedFile.value = File(result.files.single.path!);
              }
            },
          ),
          if (file != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "تم اختيار الملف: ${file.path.split('/').last}",
                style: const TextStyle(color: Colors.green),
              ),
            ),
        ],
      );
    });
  }
}
