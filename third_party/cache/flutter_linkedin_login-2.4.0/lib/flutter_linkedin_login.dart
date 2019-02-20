import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

export 'package:flutter_linkedin_login/linkedin_signin_button.dart';

///Helper class to call platform channels for LinkedIn APIs
class FlutterLinkedinLogin {
  static const MethodChannel _channel =
      const MethodChannel('io.tuantvu.flutterlinkedinlogin/flutter_linkedin_login');

  static Future<String> loginBasic() async {
    return await _channel.invokeMethod('loginBasic');
  }

  static Future<LinkedInProfile> loginBasicWithProfile() async {
    await loginBasic();
    return await getProfile();
  }

  static Future<String> logout() async {
    return await _channel.invokeMethod("logout");
  }

  static Future<LinkedInAccessToken> accessToken() async {
    String response = await _channel.invokeMethod("accessToken");
    Map accessToken = json.decode(response);
    return new LinkedInAccessToken.fromJson(accessToken);
  }

  static Future<LinkedInProfile> getProfile() async {
    String response = await _channel.invokeMethod("getProfile");
    Map profile = json.decode(response);
    return new LinkedInProfile.fromJson(profile);
  }
}

class LinkedInProfile {
  String firstName;
  String lastName;
  String headline;
  String id;
  String pictureUrl;
  String summary;
  String industry;
  String emailAddress;
  String formattedName;
  LinkedInLocation location;
  List<LinkedInPosition> positions;
  String publicProfileUrl;

  LinkedInProfile.fromJson(Map json) {
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.headline = json['headline'];
    this.id = json['id'];
    this.pictureUrl = json['pictureUrl'];
    this.summary = json['summary'];
    this.industry = json['industry'];
    this.emailAddress = json['emailAddress'];
    this.formattedName = json['formattedName'];
    this.location = LinkedInLocation.fromJson(json['location']);
    if (json['positions'] != null && json['positions']['values'] != null) {
      this.positions = parsePosition(json['positions']['values']);
    }
    this.publicProfileUrl = json['publicProfileUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'headline': headline,
      'id': id,
      'pictureUrl': pictureUrl,
      'summary': summary,
      'industry': industry,
      'emailAddress': emailAddress,
      'formattedName': formattedName,
      'location': location.toJson(),
    };
  }

  static List<LinkedInPosition> parsePosition(List<dynamic> json) {
    var positions = <LinkedInPosition>[];
    if (json != null) {
      positions = json.map((positionJson) => LinkedInPosition.fromJson(positionJson)).toList();
    }
    return positions;
  }

  @override
  String toString() {
    return 'firstName: $firstName, \n\n'
        'lastName: $lastName, \n\n'
        'headline: $headline, \n\n'
        'emailAddress: $emailAddress, \n\n'
        'formattedName: $formattedName, \n\n'
        'id: $id, \n\n'
        'publicProfileUrl: $publicProfileUrl, \n\n'
        'pictureUrl: $pictureUrl, \n\n'
        'industry: $industry, \n\n'
        'location: $location, \n\n'
        'summary: $summary, \n\n'
        'positions: $positions,';
  }


}

class LinkedInLocation {
  String countryCode;
  String name;

  LinkedInLocation.fromJson(Map json) {
    if (json != null) {
      this.countryCode = json['country'] != null ? json['country']['code'] : null;
      this.name = json['name'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'LinkedInLocation{countryCode: $countryCode, name: $name}';
  }
}

class LinkedInDate {
  int month;
  int year;

  LinkedInDate.fromJson(Map json) {
    if (json != null) {
      this.month = json['month'];
      this.year = json['year'];
    }
  }

  @override
  String toString() {
    return 'LinkedInDate{month: $month, year: $year}';
  }
}

class LinkedInCompany {
  int id;
  String name;
  String type;
  String industry;
  String ticker;

  LinkedInCompany.fromJson(Map json) {
    if (json != null) {
      this.id = json['id'];
      this.name = json['name'];
      this.type = json['type'];
      this.industry = json['industry'];
      this.ticker = json['ticker'];
    }
  }

  @override
  String toString() {
    return 'LinkedInCompany{id: $id, name: $name, type: $type, industry: $industry, ticker: $ticker}';
  }
}

class LinkedInPosition {
  int id;
  String title;
  String summary;
  LinkedInDate startDate;
  LinkedInDate endDate;
  bool isCurrent;
  LinkedInCompany company;
  LinkedInLocation location;

  LinkedInPosition.fromJson(Map json) {
    if (json != null) {
      this.id = json['id'];
      this.title = json['title'];
      this.summary = json['summary'];
      this.startDate = LinkedInDate.fromJson(json['startDate']);
      this.endDate = LinkedInDate.fromJson(json['endDate']);
      this.isCurrent = json['isCurrent'];
      this.company = LinkedInCompany.fromJson(json['company']);
      this.location = LinkedInLocation.fromJson(json['location']);
    }
  }

  @override
  String toString() {
    return 'LinkedInPosition{id: $id, title: $title, summary: $summary, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, company: $company, location: $location}';
  }
}

class LinkedInAccessToken {
  String accessTokenValue;
  int expiresOn;

  LinkedInAccessToken.fromJson(Map json) {
    if (json != null) {
      this.accessTokenValue = json['accessTokenValue'];
      this.expiresOn = json['expiresOn'];
    }
  }

  @override
  String toString() {
    return 'LinkedInAccessToken{accessTokenValue: $accessTokenValue, expiresOn: $expiresOn}';
  }


}