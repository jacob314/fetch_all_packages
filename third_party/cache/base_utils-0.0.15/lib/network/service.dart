import 'package:base_utils/network/http_utils.dart';
import 'package:base_utils/utils/string_utils.dart';
import 'package:core_plugin/tracking/tracking_manager.dart';

abstract class Service {
  String trackingGroupName,
      trackingActionName = 'Request',
      trackingResponseSuccess = 'ResponseSuccess',
      trackingResponseFail = 'ResponseFail';

  Service(this.trackingGroupName);

  void dispose();

  Future<dynamic> makeRequest({
    Function onSuccess,
    Function onFailure,
    Method method,
    String host,
    String path,
    Map<String, dynamic> params,
    Map<String, dynamic> header,
  }) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    final _trackingPath = convertToFirebaseText(path);

    TrackingManager.shared
        .trackingEvent(trackingGroupName, _trackingPath, trackingActionName);

    final _request = Request(
      method: method,
      host: host,
      path: path,
      headers: header,
      params: params,
    );

    _request.onSuccess = (data) {
      try {
        TrackingManager.shared.trackingEvent(
            trackingGroupName,
            "${_trackingPath}_${(DateTime.now().millisecondsSinceEpoch - startTime).toString()}",
            trackingResponseSuccess);

        if (onSuccess != null) onSuccess(data);
      } on Exception catch (e) {
        TrackingManager.shared.trackingEvent(
            trackingGroupName,
            "${_trackingPath}_${(DateTime.now().millisecondsSinceEpoch - startTime).toString()}_2",
            trackingResponseFail);

        if (onFailure != null) onFailure(e);
      }
    };

    _request.onFailure = (e) {
      TrackingManager.shared.trackingEvent(
          trackingGroupName,
          "${_trackingPath}_${(DateTime.now().millisecondsSinceEpoch - startTime).toString()}_1",
          trackingResponseFail);

      if (onFailure != null) onFailure(e);
    };

    return await request(_request);
  }
}
