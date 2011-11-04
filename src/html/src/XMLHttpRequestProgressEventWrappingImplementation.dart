// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class XMLHttpRequestProgressEventWrappingImplementation extends ProgressEventWrappingImplementation implements XMLHttpRequestProgressEvent {
  XMLHttpRequestProgressEventWrappingImplementation._wrap(ptr) : super._wrap(ptr);

  factory XMLHttpRequestProgressEventWrappingImplementation(String type,
      int loaded, [bool canBubble = true, bool cancelable = true,
      bool lengthComputable = false, int total = 0]) {
    final e = dom.document.createEvent("XMLHttpRequestProgressEvent");
    e.initProgressEvent(type, canBubble, cancelable, lengthComputable, loaded,
        total);
    return LevelDom.wrapProgressEvent(e);
  }

  int get position() => _ptr.position;

  int get totalSize() => _ptr.totalSize;
}
