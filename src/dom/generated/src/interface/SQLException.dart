// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// WARNING: Do not edit - generated code.

interface SQLException {

  static final int CONSTRAINT_ERR = 6;

  static final int DATABASE_ERR = 1;

  static final int QUOTA_ERR = 4;

  static final int SYNTAX_ERR = 5;

  static final int TIMEOUT_ERR = 7;

  static final int TOO_LARGE_ERR = 3;

  static final int UNKNOWN_ERR = 0;

  static final int VERSION_ERR = 2;

  int get code();

  String get message();
}
