class Validation {

  //https://regex101.com/
  //https://developer.mozilla.org/vi/docs/Web/JavaScript/Guide/Regular_Expressions
  static const String EMAIL_VALIDATION = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  //Has 1 special character
//  static const String HAS_SPECIAL_CHARACTER_VALIDATION = r'\W{1,}';
  static const String HAS_SPECIAL_CHARACTER_VALIDATION = r'[^A-Za-z0-9_]{1,}';

  //Has 1 uppercase character
  static const String HAS_UPPERCASE_CHARACTER_VALIDATION = r'[A-Z]{1,}';

  //Validation username
  static const String USER_NAME_VALIDATION = r'[A-Za-z0-9_]{1,60}';


}