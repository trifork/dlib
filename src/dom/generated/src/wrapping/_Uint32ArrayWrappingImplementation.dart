// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

class _Uint32ArrayWrappingImplementation extends _ArrayBufferViewWrappingImplementation implements Uint32Array {
  _Uint32ArrayWrappingImplementation() : super() {}

  static create__Uint32ArrayWrappingImplementation() native {
    return new _Uint32ArrayWrappingImplementation();
  }

  int get length() { return _get__Uint32Array_length(this); }
  static int _get__Uint32Array_length(var _this) native;

  Uint32Array subarray(int start, [int end = null]) {
    if (end === null) {
      return _subarray(this, start);
    } else {
      return _subarray_2(this, start, end);
    }
  }
  static Uint32Array _subarray(receiver, start) native;
  static Uint32Array _subarray_2(receiver, start, end) native;

  String get typeName() { return "Uint32Array"; }
}
