import 'dart:async';

import 'package:fillable_pdf_form/fillable_pdf_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui_utils.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fill PDF fields Plugin example'),
        ),
        body: PageBody(),
      ),
    );
  }
}

class PageBody extends StatefulWidget {
  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  DocumentSource source;

  @override
  void initState() {
    super.initState();

    source = DocumentSource.flutter;
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DocumentSourceData(source,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<DocumentSource>(
                items: <DropdownMenuItem<DocumentSource>>[
                  DropdownMenuItem<DocumentSource>(
                      child: Text('Flutter'), value: DocumentSource.flutter),
                  DropdownMenuItem<DocumentSource>(
                      child: Text('Platform assets'),
                      value: DocumentSource.platform),
                  DropdownMenuItem<DocumentSource>(
                      child: Text('Device storage'),
                      value: DocumentSource.storage)
                ],
                value: source,
                onChanged: (DocumentSource value) {
                  setState(() {
                    source = value;
                  });
                },
              ),
              SizedBox(height: 75.0),
              PDFExtractorButtonWidget(
                  text: 'Open empty PDF', fileName: 'pdf_example_empty.pdf'),
              SizedBox(height: 10.0),
              PDFExtractorButtonWidget(
                  text: 'Open filled PDF', fileName: 'pdf_example_filled.pdf'),
              SizedBox(height: 10.0),
              PDFGeneratorButtonWidget(
                  text: 'Fill PDF', fileName: 'pdf_example_empty.pdf'),
            ],
          ),
        ));
  }
}

class DocumentSourceData extends InheritedWidget {
  final DocumentSource source;

  DocumentSourceData(this.source, {Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(DocumentSourceData oldWidget) {
    return oldWidget.source != source;
  }

  static DocumentSourceData of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DocumentSourceData);
  }
}

enum DocumentSource { flutter, platform, storage }

class PDFExtractorButtonWidget extends StatefulWidget {
  final String text;
  final String fileName;

  PDFExtractorButtonWidget({@required this.text, @required this.fileName});

  @override
  State<StatefulWidget> createState() => _PDFExtractorButtonWidgetState();
}

class _PDFExtractorButtonWidgetState extends State<PDFExtractorButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(widget.text),
        onPressed: () {
          _openPDF(widget.fileName);
        });
  }

  void _openPDF(String filePath) async {
    Future<Map<String, String>> future;

    switch (DocumentSourceData.of(context).source) {
      case DocumentSource.flutter:
        future = FillablePdfForm.extractPDFFieldsFromFlutterFile(
            file: 'res/$filePath');
        break;
      case DocumentSource.platform:
        future =
            FillablePdfForm.extractPDFFieldsFromApplicationFile(file: filePath);
        break;
      case DocumentSource.storage:
        future = FillablePdfForm.extractPDFFieldsFromFile(
            androidFilePath: '/sdcard/$filePath',
            iOSFilePath: filePath,
            requestReadStoragePermission: false);
        break;
    }

    future.then((map) => extractMapValues(map)).then((fields) {
      showDialogWith(context, 'Content of the PDF', fields);
    }).catchError((err) {
      if (err is PlatformException) {
        showDialogWith(context, 'Error!', err.message);
      } else {
        showDialogWith(context, 'Error!', err?.toString());
      }
    });
  }

  String extractMapValues(Map map) {
    StringBuffer buffer = StringBuffer();
    for (String key in map.keys) {
      buffer
        ..write(key)
        ..write(' : "')
        ..write(map[key])
        ..writeln('"');
    }
    return buffer.toString();
  }
}

class PDFGeneratorButtonWidget extends StatefulWidget {
  final String text;
  final String fileName;

  PDFGeneratorButtonWidget({@required this.text, @required this.fileName});

  @override
  State<StatefulWidget> createState() => _PDFGeneratorButtonWidgetState();
}

class _PDFGeneratorButtonWidgetState extends State<PDFGeneratorButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(widget.text),
        onPressed: () {
          _fillPDF(widget.fileName);
        });
  }

  void _fillPDF(String fileName) async {
    Future<int> future;

    String androidDestination = '/sdcard/output.pdf';
    String iOSDestination = 'output.pdf';
    Map<String, String> content = {};

    content['Given Name Text Box'] = 'Last name';
    content['Family Name Text Box'] = 'First name';

    switch (DocumentSourceData.of(context).source) {
      case DocumentSource.flutter:
        future = FillablePdfForm.fillPDFFieldsFromFlutterFile(
            pdfFileToFill: 'res/$fileName',
            androidDestination: androidDestination,
            iOSDestination: iOSDestination,
            fieldsContent: content);
        break;
      case DocumentSource.platform:
        future = FillablePdfForm.fillPDFFieldsFromApplicationFile(
            pdfFileToFill: fileName,
            androidDestination: androidDestination,
            iOSDestination: iOSDestination,
            fieldsContent: content);
        break;
      case DocumentSource.storage:
        future = FillablePdfForm.fillPDFFieldsFromFile(
            pdfFileToFill: '/sdcard/$fileName',
            requestWriteStoragePermission: true,
            androidDestination: androidDestination,
            iOSDestination: iOSDestination,
            fieldsContent: content);
        break;
    }

    future.then((fieldsFilled) {
      showDialogWith(context, 'PDF Filled!', '$fieldsFilled fields filled');
    }).catchError((err) {
      if (err is PlatformException) {
        showDialogWith(context, 'Error!', err.message);
      } else {
        showDialogWith(context, 'Error!', err?.toString());
      }
    });
  }
}
