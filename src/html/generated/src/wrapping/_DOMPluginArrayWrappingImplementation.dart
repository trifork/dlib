// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

class DOMPluginArrayWrappingImplementation extends DOMWrapperBase implements DOMPluginArray {
  DOMPluginArrayWrappingImplementation._wrap(ptr) : super._wrap(ptr) {}

  int get length() { return _ptr.length; }

  DOMPlugin item(int index) {
    return LevelDom.wrapDOMPlugin(_ptr.item(index));
  }

  DOMPlugin namedItem(String name) {
    return LevelDom.wrapDOMPlugin(_ptr.namedItem(name));
  }

  void refresh(bool reload) {
    _ptr.refresh(reload);
    return;
  }
}
