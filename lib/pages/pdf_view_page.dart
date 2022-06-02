import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfViewPage extends StatefulWidget {
  final Uint8List? saved;
  const PdfViewPage({Key? key, this.saved}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pdf View')),
      body: PdfPreview(
        build: (format) => widget.saved!,
      ),
    );
  }
}
