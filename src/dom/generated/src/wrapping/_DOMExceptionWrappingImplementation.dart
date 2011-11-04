// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

class _DOMExceptionWrappingImplementation extends DOMWrapperBase implements DOMException {
  _DOMExceptionWrappingImplementation() : super() {}

  static create__DOMExceptionWrappingImplementation() native {
    return new _DOMExceptionWrappingImplementation();
  }

  int get code() { return _get__DOMException_code(this); }
  static int _get__DOMException_code(var _this) native;

  String get message() { return _get__DOMException_message(this); }
  static String _get__DOMException_message(var _this) native;

  String get name() { return _get__DOMException_name(this); }
  static String _get__DOMException_name(var _this) native;

  String get typeName() { return "DOMException"; }
}
