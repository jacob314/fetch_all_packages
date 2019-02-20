/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneLogMeasure extends Measure {
  static const int DEFAULT_NUMBER_OF_DAYS = 30;

  /// The number of days back in time to collect the phone log from.
  int days = DEFAULT_NUMBER_OF_DAYS;

  PhoneLogMeasure(MeasureType type, {name, enabled, this.days})
      : super(type, enabled: enabled, name: name);

  static Function get fromJsonFunction => _$PhoneLogMeasureFromJson;
  factory PhoneLogMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(
          json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PhoneLogMeasureToJson(this);
}
