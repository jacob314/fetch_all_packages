import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:simple_permissions/simple_permissions.dart';

class FillablePdfForm {
  static const MethodChannel _channel =
      const MethodChannel('alehos/fillable_pdf_form');

  /// Extract the PDF Fields from a [file] stored in the Flutter project
  ///
  /// The result will be stored in a map
  static Future<Map<String, String>> extractPDFFieldsFromFlutterFile(
      {@required String file}) async {
    final Map fields = await _channel
        .invokeMethod('extract_pdf_fields', {'pdf_flutter_file_path': file});
    return Map.from(fields);
  }

  /// Extract the PDF Fields from a [file] stored in the platform assets
  /// (Android / iOS) folder
  ///
  /// The result will be stored in a map
  static Future<Map<String, String>> extractPDFFieldsFromApplicationFile(
      {@required String file}) async {
    final Map fields = await _channel
        .invokeMethod('extract_pdf_fields', {'pdf_app_file_path': file});
    return Map.from(fields);
  }

  /// Extract the PDF Fields from a [file] stored in the storage
  /// On Android, you can specify if you want to request the user permission
  /// with the [requestReadStoragePermission] boolean
  /// On iOS, the [requestReadStoragePermission] parameter is ignored
  ///
  /// The result will be stored in a map
  static Future<Map<String, String>> extractPDFFieldsFromFile(
      {String androidFilePath,
      String iOSFilePath,
      bool requestReadStoragePermission: true}) async {
    Future<bool> perm;

    if (Platform.isAndroid) {
      assert(androidFilePath != null);
    } else if (Platform.isIOS) {
      assert(iOSFilePath != null);
    } else {
      throw UnimplementedError();
    }

    if (requestReadStoragePermission) {
      perm =
          SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    } else {
      perm = Future.value(true);
    }

    return perm.then((hasPermission) {
      if (!hasPermission) {
        throw new Exception("Read external storage permission not granted!");
      }

      return _channel.invokeMethod('extract_pdf_fields', {
        'pdf_file_path': Platform.isAndroid ? androidFilePath : iOSFilePath,
      }).then((res) => Map.from(res));
    });
  }

  /// Use a template stored in the Flutter project given by the [pdfFileToFill]
  /// parameter and fill the fields with[fieldsContent]. The output will be
  /// saved to a [destination] on the device storage.
  ///
  /// The result is the number of fields that have been successfully filled
  static Future<int> fillPDFFieldsFromFlutterFile(
      {@required String pdfFileToFill,
      String androidDestination,
      String iOSDestination,
      @required Map<String, String> fieldsContent}) async {
    if (Platform.isAndroid) {
      assert(androidDestination != null);
    } else if (Platform.isIOS) {
      assert(iOSDestination != null);
    } else {
      throw UnimplementedError();
    }

    final int filledFields = await _channel.invokeMethod('fill_pdf_fields', {
      'pdf_flutter_file_path': pdfFileToFill,
      'pdf_destination':
          Platform.isAndroid ? androidDestination : iOSDestination,
      'pdf_fields_content': fieldsContent
    });
    return filledFields;
  }

  /// Use a template stored in the platform assets (Android / iOS) folder given
  /// by the [pdfFileToFill] parameter and fill the fields with [fieldsContent].
  /// The output will be saved to a [destination] on the device storage.
  ///
  /// The result is the number of fields that have been successfully filled
  static Future<int> fillPDFFieldsFromApplicationFile(
      {@required String pdfFileToFill,
      String androidDestination,
      String iOSDestination,
      @required Map<String, String> fieldsContent}) async {
    if (Platform.isAndroid) {
      assert(androidDestination != null);
    } else if (Platform.isIOS) {
      assert(iOSDestination != null);
    } else {
      throw UnimplementedError();
    }

    final int filledFields = await _channel.invokeMethod('fill_pdf_fields', {
      'pdf_app_file_path': pdfFileToFill,
      'pdf_destination':
          Platform.isAndroid ? androidDestination : iOSDestination,
      'pdf_fields_content': fieldsContent
    });
    return filledFields;
  }

  /// Use a template stored in the device storage given by the [pdfFileToFill]
  /// parameter and fill the fields with [fieldsContent]. The output will be
  /// saved to a [destination] on the device storage.
  ///
  /// The result is the number of fields that have been successfully filled
  static Future<int> fillPDFFieldsFromFile(
      {@required String pdfFileToFill,
      String androidDestination,
      String iOSDestination,
      @required Map<String, String> fieldsContent,
      bool requestWriteStoragePermission: true}) async {
    if (Platform.isAndroid) {
      assert(androidDestination != null);
    } else if (Platform.isIOS) {
      assert(iOSDestination != null);
    } else {
      throw UnimplementedError();
    }

    Future<bool> perm;

    if (requestWriteStoragePermission && !Platform.isIOS) {
      perm =
          SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    } else {
      perm = Future.value(true);
    }

    return perm.then((hasPermission) {
      if (!hasPermission) {
        throw new Exception("Read external storage permission not granted!");
      }

      return _channel.invokeMethod('fill_pdf_fields', {
        'pdf_file_path': pdfFileToFill,
        'pdf_destination':
            Platform.isAndroid ? androidDestination : iOSDestination,
        'pdf_fields_content': fieldsContent
      }).then((res) => res);
    });
  }
}
