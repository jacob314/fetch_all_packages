import 'package:flutter_paystack/src/common/exceptions.dart';
import 'package:flutter_paystack/src/model/card.dart';
import 'package:flutter_paystack/src/widgets/checkout/bank_checkout.dart';
import 'package:flutter_paystack/src/common/string_utils.dart';

class Charge {
  PaymentCard card;
  String _email;
  String _accessCode;
  BankAccount _account;

  /// Amount in kobo
  int _amount = 0;
  Map<String, dynamic> _metadata;
  List<Map<String, dynamic>> _customFields;
  bool _hasMeta = false;
  Map<String, String> _additionalParameters;
  int _transactionCharge = 0;
  String _subAccount;
  String _reference;
  Bearer _bearer;
  String _currency;
  String _plan;
  bool _localStarted = false;
  bool _remoteStarted = false;

  _beforeLocalSet(String fieldName) {
    assert(() {
      if (_remoteStarted) {
        throw new ChargeException(
            'You cannot set $fieldName after specifying an '
            'access code');
      }
      return true;
    }());
    _localStarted = true;
  }

  _beforeRemoteSet() {
    assert(() {
      if (_localStarted) {
        throw new ChargeException('You can not set access code when providing '
            'transaction parameters in app');
      }
      return true;
    }());
    _remoteStarted = true;
  }

  Charge() {
    this._metadata = {};
    this._amount = -1;
    this._additionalParameters = {};
    this._customFields = [];
    this._metadata['custom_fields'] = this._customFields;
  }

  addParameter(String key, String value) {
    _beforeLocalSet(key);
    this._additionalParameters[key] = value;
  }

  Map<String, String> get additionalParameters => _additionalParameters;

  String get accessCode => _accessCode;

  set accessCode(String value) {
    _beforeRemoteSet();
    _accessCode = value;
  }

  String get plan => _plan;

  set plan(String value) {
    _beforeLocalSet('plan');
    _plan = value;
  }

  String get currency => _currency;

  set currency(String value) {
    _beforeLocalSet('currency');
    _currency = value;
  }

  String get reference => _reference;

  set reference(String value) {
    _beforeLocalSet('reference');
    _reference = value;
  }

  int get transactionCharge => _transactionCharge;

  set transactionCharge(int value) {
    _beforeLocalSet('transaction charge');
    _transactionCharge = value;
  }

  Bearer get bearer => _bearer;

  set bearer(Bearer value) {
    _beforeLocalSet('bearer');
    _bearer = value;
  }

  String get subAccount => _subAccount;

  set subAccount(String value) {
    _beforeLocalSet('subaccount');
    _subAccount = value;
  }

  BankAccount get account => _account;

  set account(BankAccount value) {
    if (value == null) {
      // Precaution to avoid setting of this field outside the library
      throw new PaystackException('account cannot be null');
    }
    _account = value;
  }

  putMetaData(String name, dynamic value) {
    _beforeLocalSet('metadata');
    this._metadata[name] = value;
    this._hasMeta = true;
  }

  putCustomField(String displayName, String value) {
    _beforeLocalSet('custom field');
    var customMap = {
      'value': value,
      'display_name': displayName,
      'variable_name':
          displayName.toLowerCase().replaceAll(new RegExp(r'[^a-z0-9 ]'), "_")
    };
    this._customFields.add(customMap);
    this._hasMeta = true;
  }

  String get metadata {
    if (!_hasMeta) {
      return null;
    }

    return _metadata.toString();
  }

  String get email => _email;

  set email(String value) {
    // _beforeLocalSet('email');  Not needed because of PaystackPlugin.checkout. Email
    // is needed for the checkout ui even after setting access code.
    if (!StringUtils.isValidEmail(value)) {
      throw InvalidEmailException(value);
    }
    _email = value;
  }

  int get amount => _amount;

  /// Set amount
  /// [value] amount in kobo
  set amount(int value) {
    // _beforeLocalSet('amount'); Not needed because of PaystackPlugin.checkout. Amount
    // is needed for the checkout ui even after setting access code.
    if (value <= 0) {
      throw InvalidAmountException(value);
    }
    _amount = value;
  }
}

enum Bearer {
  Account,
  SubAccount,
}
