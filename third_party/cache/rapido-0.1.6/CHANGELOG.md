## [0.1.6] - 2019-02-05
 * Cleaned up empty statement
 * Added missing API documentation

## [0.1.5] - 2019-01-31
 * Added "amount" TypedInput field. Any field name ending in amount will be assumed to be a double.
 * Add a character white list to the defuault integer input field, which restricts characters other than digits being entered.
 
## [0.1.4] - 2019-01-30
 * Changed fieldOptions to a dart class. This is a breaking change.
 * Added ListInput field options for optionally rendering an input field as a spinning picker list.
 
## [0.1.3] - 2019-01-26
 * Add fieldOptions with support for customizing IntegerFields and Date and DateTime fields. 
 * Removed dateFormat and dateTimeFormat properties from TypedInputFields because that is not supported by fieldOptions. This is a breaking change. If you were using those properties, you need to migrate your code to use fieldOptions instead.
 
## [0.1.2] - 2019-01-21
 * Removed @required from DocumentListScaffold.titleKeys. 
 
## [0.1.1] - 2019-01-21
 * Added API documentation to TypedDisplayField

## [0.1.0] - 2019-01-21
 * Added ChangeNotifier to Document and DocumentList classes. This is a breaking change. The onChanged property is no longer supported. Use addListener instead.
 * Added formDecoration, formFieldDecoration, documentPageDecoration, and documentFieldDecoration properties to DocumentListScaffold, DocumentList and related widgets to provide more easy of use use and depth in customizing the look and feel of an app.
 
## [0.0.14] - 2019-01-06
 * Added an image formfield that will automatically provide an image picker that can allow choosing directly from the camera, from the gallery, or entering a link. 
 * Added TypedDisplay fields, so that you can pass any field from a DocumentList and rapido will do its best to display it. Currently provides supprt for images (either form the device of a url), maps, and otherwise strings.
 * Enhanced DocumentForm so that the map picker and the image picker are embedded in the form rather than popping up separate dialogs.
 * Added 'text' to inferred types. Field names ending in 'text' will be rendered with a multi-line input field.
 * Added DocumentListPageView class for paging through DocumentViews.
 * Added scroll direction option to DocumentListView. If you set ScrollDirection = Axis.horizontal, you must pass in a customItemBuilder as well, or this property will be ignored.
 * Breaking change: remaned "map point" to "latlong." In order to add map functionality to your application, you need to change field names to end in "latlong."
 * Breaking change: renamed the library from "documents" to "rapido. So, you must change your imports to: import 'package:rapido/rapido.dart';
 
## [0.0.13] - 2018-12-09
 * Changed DocumentListMapView to set it's starting camera based on the Documents in the list, unless the developer supplied explicit coordinates.
 * Use numbered keyboard with map points.
 * Fixed a bug with location form.

## [0.0.12] - 2018-12-08
 * Changed DocumentListView so that a field named "subtitle" is automatically used as a subtitle.
 * Small updates to API documentation.
 * Wrote and posted [tutorial documentation](https://rapido-mobile.github.io/).

## [0.0.11] - 2018-12-02
 * Added DocumentListMapView which displays a DocumentList on a map.
 * Added a DocumentPage which renders a readonly pageview of a Document.

## [0.0.10] - 2018-11-24
 * Add a specific Document class that inherits from MapBase<String, dynamic>. Most code should not be effected by this, but this is a breaking change for many of the functions on DocumentList. For example, DocumentList.add and DocumentList.addAll must be updated to create a Docuent: documentList.add(Document(initialValues: {"field1":"value1})). This change is in preparation to improve the usability of working with Documents and DocumentLists.
 * Changed "document_list.dart" to just "documents.dart". this is a breaking change. You must now import 'package:rapido/documents.dart' instead of 'package:rapido/document_list.dart'.
 * Changed the interface for DocumentListView.customItemBuilder to include the document itself, and the build context. 
 * Some small bug fixes

## [0.0.9] - 2018-11-24
 * Added datetime field support in TypedInputField. Requires that the string be in a specific format ("EEE, MMM d, y H:mm:s"). This can be overridden by passing in a custom dateTimeFormat string when creating the TypedInputField. Date field now supports custom date formats as well. More work is required to enhance the usability of this part of the API, but the current API is 

## [0.0.8] - 2018-11-23
 * Updated README with a more clear explanation of the project
 * Add the ability to include a label with the add document fab

## [0.0.7] - 2018-11-20
 * Removed required title parameter from DocumentListScaffold

## [0.0.6] - 2018-11-19 
 * Adding a sorting button widget

## [0.0.5] - 2018-11-19 
 * Added more examples to example/
 * added DocumentList.sortByField() to simplify sorting

## [0.0.4] - 2018-11-17
* Updated pubspec.yaml to explicitly reference test.dart after flutter update
* Fixed https://github.com/rapido-mobile/rapido-flutter/issues/5 which made DocumentList.sort() work

## [0.0.1] - 2018-11-14
* Initial relese with DocumentList and related classes
* Document persistence handled by writing json files as first implementation







 