// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

class _HTMLOutputElementWrappingImplementation extends _HTMLElementWrappingImplementation implements HTMLOutputElement {
  _HTMLOutputElementWrappingImplementation() : super() {}

  static create__HTMLOutputElementWrappingImplementation() native {
    return new _HTMLOutputElementWrappingImplementation();
  }

  String get defaultValue() { return _get__HTMLOutputElement_defaultValue(this); }
  static String _get__HTMLOutputElement_defaultValue(var _this) native;

  void set defaultValue(String value) { _set__HTMLOutputElement_defaultValue(this, value); }
  static void _set__HTMLOutputElement_defaultValue(var _this, String value) native;

  HTMLFormElement get form() { return _get__HTMLOutputElement_form(this); }
  static HTMLFormElement _get__HTMLOutputElement_form(var _this) native;

  DOMSettableTokenList get htmlFor() { return _get__HTMLOutputElement_htmlFor(this); }
  static DOMSettableTokenList _get__HTMLOutputElement_htmlFor(var _this) native;

  void set htmlFor(DOMSettableTokenList value) { _set__HTMLOutputElement_htmlFor(this, value); }
  static void _set__HTMLOutputElement_htmlFor(var _this, DOMSettableTokenList value) native;

  NodeList get labels() { return _get__HTMLOutputElement_labels(this); }
  static NodeList _get__HTMLOutputElement_labels(var _this) native;

  String get name() { return _get__HTMLOutputElement_name(this); }
  static String _get__HTMLOutputElement_name(var _this) native;

  void set name(String value) { _set__HTMLOutputElement_name(this, value); }
  static void _set__HTMLOutputElement_name(var _this, String value) native;

  String get type() { return _get__HTMLOutputElement_type(this); }
  static String _get__HTMLOutputElement_type(var _this) native;

  String get validationMessage() { return _get__HTMLOutputElement_validationMessage(this); }
  static String _get__HTMLOutputElement_validationMessage(var _this) native;

  ValidityState get validity() { return _get__HTMLOutputElement_validity(this); }
  static ValidityState _get__HTMLOutputElement_validity(var _this) native;

  String get value() { return _get__HTMLOutputElement_value(this); }
  static String _get__HTMLOutputElement_value(var _this) native;

  void set value(String value) { _set__HTMLOutputElement_value(this, value); }
  static void _set__HTMLOutputElement_value(var _this, String value) native;

  bool get willValidate() { return _get__HTMLOutputElement_willValidate(this); }
  static bool _get__HTMLOutputElement_willValidate(var _this) native;

  bool checkValidity() {
    return _checkValidity(this);
  }
  static bool _checkValidity(receiver) native;

  void setCustomValidity(String error) {
    _setCustomValidity(this, error);
    return;
  }
  static void _setCustomValidity(receiver, error) native;

  String get typeName() { return "HTMLOutputElement"; }
}
