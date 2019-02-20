import 'package:core_plugin/tracking/channel_tracking_manager.dart';

class TrackingManager {
  static final TrackingManager shared = new TrackingManager._internal();

  factory TrackingManager() {
    return shared;
  }

  TrackingManager._internal();

  final channel = ChannelCheckingManager();

  trackingScreen(String screenName) {
    if (screenName != null && screenName.isNotEmpty)
      channel.actionTrackingScreen(screenName);
  }

  trackingEvent(String groupName, String sourceName,
      [String actionName = 'touch', String label = '']) {
    if (groupName != null &&
        groupName.isNotEmpty &&
        sourceName != null &&
        sourceName.isNotEmpty &&
        actionName != null &&
        actionName.isNotEmpty)
      channel.actionTrackingEvent(groupName, sourceName, actionName, label);
  }

  trackingEcommerceSuccess(String actionName) {
    if (actionName != null && actionName.isNotEmpty)
      channel.actionTrackingEcommerce(actionName, 'success');
  }

  trackingEcommerceFail(String actionName) {
    if (actionName != null && actionName.isNotEmpty)
      channel.actionTrackingEcommerce(actionName, 'fail');
  }
}
