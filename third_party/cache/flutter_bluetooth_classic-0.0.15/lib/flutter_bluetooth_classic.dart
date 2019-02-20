
library flutter_bluetooth_classic;

import 'dart:async';

import 'package:flutter/services.dart';
import 'gen/flutterblue_pb.dart' as protos;
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';

part 'src/flutter_bluetooth_classic.dart';
part 'src/constants.dart';
part 'src/bluetooth_device.dart';
part 'src/bluetooth_service.dart';
part 'src/bluetooth_characteristic.dart';
part 'src/bluetooth_descriptor.dart';
part 'src/guid.dart';