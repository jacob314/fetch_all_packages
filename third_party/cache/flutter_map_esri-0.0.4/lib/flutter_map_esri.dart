library flutter_map_esri;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

enum EsriBasemapType {
  streets,
  topographic,
  oceans,
  oceanLabels,
  nationalGeographic,
  darkGray,
  darkGrayLabels,
  gray,
  grayLabels,
  imagery,
  imageryLabels,
  imageryTransportation,
  shadedRelief,
  shadedReliefLabels,
  terrain,
  terrainLabels,
  usaTopo,
  imageClarity,
}

String _urlTemplateForEsriType(EsriBasemapType type) {
  switch (type) {
    case EsriBasemapType.topographic:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.oceans:
      return "https://{s}.arcgisonline.com/arcgis/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.oceanLabels:
      return "https://{s}.arcgisonline.com/arcgis/rest/services/Ocean/World_Ocean_Reference/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.nationalGeographic:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.darkGray:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.darkGrayLabels:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.gray:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.grayLabels:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Reference/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.imagery:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.imageryLabels:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.imageryTransportation:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Reference/World_Transportation/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.shadedRelief:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/World_Shaded_Relief/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.shadedReliefLabels:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places_Alternate/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.terrain:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/World_Terrain_Base/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.terrainLabels:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/Reference/World_Reference_Overlay/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.usaTopo:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/USA_Topo_Maps/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.imageClarity:
      return "https://clarity.maptiles.arcgis.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
    case EsriBasemapType.streets:
    default:
      return "https://{s}.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}";
  }
}

double _maxZoomForType(EsriBasemapType type) {
  switch (type) {
    case EsriBasemapType.topographic:
      return 19.0;
    case EsriBasemapType.oceans:
    case EsriBasemapType.oceanLabels:
    case EsriBasemapType.nationalGeographic:
    case EsriBasemapType.darkGray:
    case EsriBasemapType.darkGrayLabels:
    case EsriBasemapType.gray:
      return 16.0;
    case EsriBasemapType.grayLabels:
    case EsriBasemapType.imagery:
    case EsriBasemapType.imageryLabels:
    case EsriBasemapType.imageryTransportation:
      return 19.0;
    case EsriBasemapType.shadedRelief:
      return 13.0;
    case EsriBasemapType.shadedReliefLabels:
      return 12.0;
    case EsriBasemapType.terrain:
      return 13.0;
    case EsriBasemapType.terrainLabels:
      return 13.0;
    case EsriBasemapType.usaTopo:
      return 15.0;
    case EsriBasemapType.imageClarity:
      return 19.0;
    case EsriBasemapType.streets:
    default:
      return 19.0;
  }
}

class EsriBasemapOptions extends TileLayerOptions {
  EsriBasemapOptions({
    EsriBasemapType esriBasemapType,
    double tileSize,
    double maxZoom,
    bool zoomReverse,
    double zoomOffset,
    Map<String, String> additionalOptions,
    List<String> subdomains,
    Color backgroundColor, // grey[300]
    ImageProvider placeholderImage,
  }) : super(
          urlTemplate: _urlTemplateForEsriType(esriBasemapType),
          maxZoom: _maxZoomForType(esriBasemapType),
          subdomains: [
            "server",
            "services",
          ],
        );
}
