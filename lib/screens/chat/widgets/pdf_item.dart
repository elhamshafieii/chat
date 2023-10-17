import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:tinycolor2/tinycolor2.dart';

class PdfItem extends StatefulWidget {
  final String pdfUrl;
  const PdfItem({
    Key? key,
    required this.pdfUrl,
  }) : super(key: key);

  @override
  State<PdfItem> createState() => _PdfItemState();
}

class _PdfItemState extends State<PdfItem> {
  final controller = PdfViewerController();

  Future<String> getFirstPageDocument() async {
    PDFDocument document = await PDFDocument.fromURL(widget.pdfUrl);
    PDFPage pageOne = await document.get(page: 1);
    final pageImage = await pageOne.imgPath;
    return pageImage!;
  }

  Future<PDFDocument> getPageDocument() async {
    PDFDocument document = await PDFDocument.fromURL(widget.pdfUrl);
    return document;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 45,
        child: FittedBox(
          alignment: Alignment.topCenter, //Positioned in start
          fit: BoxFit.cover,
          child: FutureBuilder<String>(
            future: getFirstPageDocument(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: 60, width: 60, child: CupertinoActivityIndicator());
              }
              return Image.file(File(snapshot.data!));
            },
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 60,
          padding: EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: Theme.of(context).cardTheme.color!.shade(7)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.file_present_outlined,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              FutureBuilder<PDFDocument>(
                future: getPageDocument(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PDF Document Name',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        snapshot.data.count.toString() + ' pages . PDF',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
