import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/src/common/error_codes.dart';

void main() {
  MethodChannel channel =
      const MethodChannel('plugins.builttoroam.com/device_calendar');
  DeviceCalendarPlugin deviceCalendarPlugin = new DeviceCalendarPlugin();

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      print("Calling channel method ${methodCall.method}");
      log.add(methodCall);

      return null;
    });

    log.clear();
  });

  test('HasPermissions_Returns_Successfully', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });

    final result = await deviceCalendarPlugin.hasPermissions();
    expect(result.isSuccess, true);
    expect(result.errorMessages, isEmpty);
    expect(result.data, true);
  });

  test('RequestPermissions_Returns_Successfully', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });

    final result = await deviceCalendarPlugin.requestPermissions();
    expect(result.isSuccess, true);
    expect(result.errorMessages, isEmpty);
    expect(result.data, true);
  });

  test('RetrieveCalendars_Returns_Successfully', () async {
    final fakeCalendarName = "fakeCalendarName";
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return "[{\"id\":\"1\",\"isReadOnly\":false,\"name\":\"$fakeCalendarName\"}]";
    });

    final result = await deviceCalendarPlugin.retrieveCalendars();
    expect(result.isSuccess, true);
    expect(result.errorMessages, isEmpty);
    expect(result.data, isNotNull);
    expect(result.data, isNotEmpty);
    expect(result.data[0].name, fakeCalendarName);
  });

  test('RetrieveEvents_CalendarId_IsRequired', () async {
    final String calendarId = null;
    final RetrieveEventsParams params = new RetrieveEventsParams();

    final result =
        await deviceCalendarPlugin.retrieveEvents(calendarId, params);
    expect(result.isSuccess, false);
    expect(result.errorMessages.length, greaterThan(0));
    expect(result.errorMessages[0],
        contains(ErrorCodes.invalidArguments.toString()));
  });

  test('DeleteEvent_CalendarId_IsRequired', () async {
    final String calendarId = null;
    final String eventId = "fakeEventId";

    final result = await deviceCalendarPlugin.deleteEvent(calendarId, eventId);
    expect(result.isSuccess, false);
    expect(result.errorMessages.length, greaterThan(0));
    expect(result.errorMessages[0],
        contains(ErrorCodes.invalidArguments.toString()));
  });

  test('DeleteEvent_EventId_IsRequired', () async {
    final String calendarId = "fakeCalendarId";
    final String eventId = null;

    final result = await deviceCalendarPlugin.deleteEvent(calendarId, eventId);
    expect(result.isSuccess, false);
    expect(result.errorMessages.length, greaterThan(0));
    expect(result.errorMessages[0],
        contains(ErrorCodes.invalidArguments.toString()));
  });

  test('DeleteEvent_PassesArguments_Correctly', () async {
    final String calendarId = "fakeCalendarId";
    final String eventId = "fakeEventId";

    await deviceCalendarPlugin.deleteEvent(calendarId, eventId);
    expect(log, <Matcher>[
      isMethodCall('deleteEvent', arguments: <String, dynamic>{
        'calendarId': calendarId,
        'eventId': eventId
      })
    ]);
  });

  test('CreateEvent_Arguments_Invalid', () async {
    final String fakeCalendarId = null;
    final Event event = new Event(fakeCalendarId);

    final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
    expect(result.isSuccess, false);
    expect(result.errorMessages, isNotEmpty);
    expect(result.errorMessages[0],
        contains(ErrorCodes.invalidArguments.toString()));
  });

  test('CreateEvent_Returns_Successfully', () async {
    final fakeNewEventId = "fakeNewEventId";
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return fakeNewEventId;
    });

    final String fakeCalendarId = "fakeCalendarId";
    final Event event = new Event(fakeCalendarId);
    event.title = "fakeEventTitle";
    event.start = new DateTime.now();
    event.end = event.start.add(new Duration(hours: 1));

    final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
    expect(result.isSuccess, true);
    expect(result.errorMessages, isEmpty);
    expect(result.data, isNotEmpty);
    expect(result.data, fakeNewEventId);
  });

  test('UpdateEvent_Returns_Successfully', () async {
    final fakeNewEventId = "fakeNewEventId";
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      final arguments = methodCall.arguments as Map<dynamic, dynamic>;
      if (!arguments.containsKey('eventId') || arguments['eventId'] == null) {
        return null;
      }

      return fakeNewEventId;
    });

    final String fakeCalendarId = "fakeCalendarId";
    final Event event = new Event(fakeCalendarId);
    event.eventId = "fakeEventId";
    event.title = "fakeEventTitle";
    event.start = new DateTime.now();
    event.end = event.start.add(new Duration(hours: 1));

    final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
    expect(result.isSuccess, true);
    expect(result.errorMessages, isEmpty);
    expect(result.data, isNotEmpty);
    expect(result.data, fakeNewEventId);
  });
}
