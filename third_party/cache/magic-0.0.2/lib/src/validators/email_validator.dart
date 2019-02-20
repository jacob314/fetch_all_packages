import 'package:flutter/widgets.dart';
import 'package:validator/validator.dart';

import 'base_validator.dart';

class EmailValidator extends BaseValidator {
  @override
  String key() {
    return 'email';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    if (value is String && isEmail(value)) {
      return null;
    }

    return this.message(context, attribute);
  }
}
