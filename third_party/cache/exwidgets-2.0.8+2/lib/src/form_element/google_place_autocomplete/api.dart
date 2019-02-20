import 'dart:convert';
import 'package:exwidgets/src/form_element/google_place_autocomplete/mapview.dart';
import 'package:exwidgets/src/form_element/google_place_autocomplete/model.dart';
import 'package:exwidgets/src/helper/input.dart';
import 'package:http/http.dart' as http;

class GooglePlaceApi {
  static String apiKey = "AIzaSyDkYqD0Y2H63XZsfyAXX8ui13nP4X6cjiY";
  static Future<List<GooglePlaceModel>> fetchResult(String query) async {
    http.Client client = http.Client();

    print("fetching..");

    // var url =
    //     'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyDkYqD0Y2H63XZsfyAXX8ui13nP4X6cjiY&sessiontoken=1234567890';
    var url =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=$apiKey&input=$query';

    final response = await client.get(url);
    print("Done...");

    Map userMap = json.decode(response.body);

    final parsed = userMap["predictions"].cast<Map<String, dynamic>>();

    return parsed
        .map<GooglePlaceModel>((json) => GooglePlaceModel.fromJson(json))
        .toList();
  }

  static Future getPlaceDetail(String placeId, String address) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=name,rating,geometry,formatted_phone_number&key=$apiKey";
    http.Client client = http.Client();
    final response = await client.get(url);
    Map resultMap = json.decode(response.body);
    try {
      print(resultMap["result"]["geometry"]["location"]["lat"]);
      print(resultMap["result"]["geometry"]["location"]["lng"]);

      double lat = resultMap["result"]["geometry"]["location"]["lat"];
      double lng = resultMap["result"]["geometry"]["location"]["lng"];

      Input.setValue("placeId", placeId);
      Input.setValue("lat", lat);
      Input.setValue("lng", lng);

      GoogleMapViewState.updateSelectedMarker(lat, lng, address);

      print("-----------------");
    } catch (e) {
      print(e);
    }
    return null;
  }
}
