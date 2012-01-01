class IllegalStateException implements Exception {
  const IllegalStateException([this._args = ""]);
  String toString() => "Illegal state: $_args";
  final String _args;
}


class Flow<T> {

    Completer _completer = null;

    Flow();

    Future invoke()
    {
        if (_completer != null) {
            throw new IllegalStateException("already invoked");
        }

        _completer = new Completer();
        (protect(this.run))();
        return _completer.future;
    }

    abstract T run(_);

    /** exceptional flow termination */
    bool completeException(var exception) {
        if (_completer != null) {
            try {
              cleanup(false);
            } finally {
              _completer.completeException(exception);
              _completer = null;
            }
        }

        // See Future.handleException
        return true;
    }

    /** do flow-specific cleanup (this is like "finally" for the flow) */
    void cleanup([bool success]) {}

    /** normal flow termination */
    void complete([T value = null]) {
        if (_completer == null)
            return;

        try {
            cleanup(true);
        } finally {
            _completer.complete(value);
            _completer = null;
        }
    }

    protect(void callback(arg)) =>
        ([a]) {
          try {
              callback(a);
          } catch (var e) {
              completeException(e);
          }
        };

    void call(var nested, var then, [Function fail=true]) {

        if (nested is Flow) {
            nested = nested.invoke();
        }
        if (nested is !Future) {
            throw new Exception();
        }

        nested.handleException(fail == null
                               ? completeException
                               : () { fail(); return true; });
        nested.then(protect(then));
    }


}
