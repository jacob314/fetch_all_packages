import 'package:flutter/material.dart';
import 'package:rapido/rapido.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

/// Support for presenting a DocumentList on a GoogleMap.
/// The DocumentListMapView assumes that documents container certain fields.
/// latlong is a map in the form of {"latitude": double, "longitude: double"}.
/// The DocumentListMapView will automatically create points on the map for each.
/// It further assumes there is a "title" and "subtitle" field that will be used
/// for the info window on the GoogleMap.
/// Clicking on the info window will display a DocumentPage for the selected
/// Document.
class DocumentListMapView extends StatefulWidget {
  /// The DocumentList that is the source of data to display on the map
  final DocumentList documentList;

  /// The starting zoom level for the map
  final double startingZoom;

  /// The starting latitude for the map
  final double startingLatitude;

  /// The starting longitude for the map
  final double startingLongitude;

  /// A call back function to call when the default ListTile in the
  /// DocumentListView is tapped by the user. Receives a Document
  /// as an argument.
  /// Ignored when customItemBuilder is used.
  final Function onItemTap;

  /// Show default document page view when marker is tapped.
  /// Ignored if onItemTap callback is set.
  final bool showDocumentPageOnTap;

  DocumentListMapView(this.documentList,
      {this.startingZoom,
      this.startingLatitude,
      this.startingLongitude,
      this.onItemTap,
      this.showDocumentPageOnTap: true});

  _DocumentListMapViewState createState() => _DocumentListMapViewState();
}

class _DocumentListMapViewState extends State<DocumentListMapView> {
  DocumentList data;
  GoogleMapController mapController;
  double _startingZoom;
  double _startingLatitude;
  double _startingLongitude;
  LatLngBounds _cameraBounds;

  Map<Marker, Document> markerHash = {};

  @override
  initState() {
    // if the DocumentList is not ready, wait until
    // the documents are loaded before initializing the map
    if (widget.documentList.documentsLoaded) {
      _initializeMapPosition();
      data = widget.documentList;
    } else {
      widget.documentList.onLoadComplete = ((DocumentList completeData) {
        _initializeMapPosition();
        data = widget.documentList;
      });
    }
    super.initState();
  }

  void _initializeMapPosition() {
    // set the starting location of the map as best as possible
    // In priority order:
    // 1. if the starting coordinates were explicitly set, use that
    // 2. otherwise, if there are no documents to display, use the current location
    // 3. otherwise, if there is one document to display, center on that document
    // 4. otherwise if there are multiple documents to display, fit the map to them

    if (widget.startingLatitude == null || widget.startingLongitude == null) {
      // starting coordinates were not specifically set

      // find documents that have location
      List<Document> docsWithLocation = _getDocumentsWithMapPoints();

      if (docsWithLocation.length == 0)
        _setCurrentLocation(); // no docs to display, use current location
      else if (docsWithLocation.length == 1) {
        // one doc to display, center on it
        setState(() {
          _startingLatitude = docsWithLocation[0]["latlong"]["latitude"];
          _startingLongitude = docsWithLocation[0]["latlong"]["longitude"];
        });
      } else if (docsWithLocation.length > 1) {
        //   // CameraTargetBounds is not working according to:
        //   // https://github.com/flutter/flutter/issues/25298
        // multiple documents to display, fit the map to them
        // _cameraBounds = _docsBounds(docsWithLocation);
        List<double> center = _centerOfDocs(docsWithLocation);
        _startingLatitude = center[0];
        _startingLongitude = center[1];
      }
    }

    widget.startingZoom != null
        ? _startingZoom = widget.startingZoom
        : _startingZoom = 15.0;
  }

  Map<String, double> _locationMaxes(List<Document> docs) {
    double north = -180.0, south = 180.0, east = -180.0, west = 180.0;
    docs.forEach((Document doc) {
      double lat = doc["latlong"]["latitude"];
      double lng = doc["latlong"]["longitude"];
      if (lat > north) north = lat;
      if (lat < south) south = lat;
      if (lng > east) east = lng;
      if (lng < west) west = lng;
    });
    return {"north": north, "south": south, "east": east, "west": west};
  }

  //   // CameraTargetBounds is not working according to:
  //   // https://github.com/flutter/flutter/issues/25298
  // LatLngBounds _docsBounds(List<Document> docs) {
  //   Map<String, double> maxes = _locationMaxes(docs);
  //   return LatLngBounds(
  //       southwest: LatLng(maxes["south"], maxes["west"]),
  //       northeast: LatLng(maxes["north"], maxes["east"]));
  // }

  List<double> _centerOfDocs(List<Document> docs) {
    Map<String, double> maxes = _locationMaxes(docs);

    double centerLat = ((maxes["north"] - maxes["south"]) / 2) + maxes["south"];
    double centerLong = ((maxes["west"] - maxes["east"]) / 2) + maxes["east"];
    return [centerLat, centerLong];
  }

  List<Document> _getDocumentsWithMapPoints() {
    List<Document> matchedDocs = [];
    widget.documentList.forEach((Document doc) {
      if (doc["latlong"] != null) matchedDocs.add(doc);
    });
    return matchedDocs;
  }

  void _setCurrentLocation() async {
    Location().getLocation().then((Map<String, double> location) {
      setState(() {
        _startingLatitude = location["latitude"];
        _startingLongitude = location["longitude"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.documentList.addListener(() {
      setState(() {});
      if (mapController != null) {
        mapController.clearMarkers();
        _addMarkers();
      }
    });

    // the data is not done loading
    if ((_startingLatitude == null || _startingLongitude == null) &&
        (_cameraBounds == null)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    GoogleMapOptions options;
    // if (_cameraBounds != null) {
    //   // CameraTargetBounds is not working according to:
    //   // https://github.com/flutter/flutter/issues/25298
    //   // resurrect this code when it is working again
    //   options = GoogleMapOptions(
    //     myLocationEnabled: true,
    //     cameraTargetBounds: CameraTargetBounds(_cameraBounds),
    //   );
    // } else {
    options = GoogleMapOptions(
      myLocationEnabled: true,
      cameraPosition: CameraPosition(
          target: LatLng(_startingLatitude, _startingLongitude),
          zoom: _startingZoom),
    );
    // }

    return GoogleMap(
      options: options,
      onMapCreated: _onMapCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
    );
  }

  _onMarkerTapped(Marker marker) {
    Document doc = markerHash[marker];

    // If the user has passed in an onTap callback then use that.
    // Otherwise, if the user has not disabled shwoing the DocumentPage
    // then push a DocumentPage.
    if (widget.onItemTap != null) {
      widget.onItemTap(doc);
    } else if (widget.showDocumentPageOnTap) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return DocumentPage(labels: widget.documentList.labels, document: doc);
      }));
    }
  }

  // called each time the map is rebuilt
  // the main job is to add the mapp markers from the DocumentList
  _onMapCreated(GoogleMapController controller) {
    markerHash.clear();

    mapController = controller;
    controller.onInfoWindowTapped.add(_onMarkerTapped);

    // see if there is any data to display on the map
    _addMarkers();
  }

  void _addMarkers() {
    data.forEach((Document doc) {
      // don't try add a marker if the location is going to fail
      if (doc["latlong"] != null &&
          doc["latlong"]["latitude"] != null &&
          doc["latlong"]["longitude"] != null) {
        MarkerOptions mo = MarkerOptions(
          position:
              LatLng(doc["latlong"]["latitude"], doc["latlong"]["longitude"]),
          infoWindowText: InfoWindowText(doc["title"], doc["subtitle"]),
          icon: BitmapDescriptor.defaultMarker,
        );

        mapController.addMarker(mo).then((Marker m) {
          markerHash[m] = doc;
        });
      }
    });
  }
}
