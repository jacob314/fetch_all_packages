# flutter_map_esri

ESRI basemaps for flutter_map.  This does NOT provide esri FeatureLayers or
other layers.

## Example

Use `EsriBasemapOptions` with `EsriBasemapType`

```dart
new FlutterMap(
  options: new MapOptions(
    center: new LatLng(34.0231688, -118.2874995),
    zoom: 17.0,
  ),
  layers: [
    new EsriBasemapOptions(
        esriBasemapType: EsriBasemapType.streets),
  ],
);
```
EsriBasemapOptions implements TileLayerOptions.
