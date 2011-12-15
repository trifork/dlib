class LazySeq<T> implements ISeq<T> {
    final val, f;
    LazySeq(this.val, this.f);//f without side effects
    Iterator<T> iterator() => new LazyIter(val,f);

    T first() => _val;
    ISeq<T> rest() {
      var next = f(val);
      if (next == null) return null;
      return new LazySeq(next, this.f);
    }
    ISeq<T> with(T o) {
      return new ConsSeq<T>.of(o,this);
    }
}

class LazyIter<T> implements Iterator<T> {
    var val;
    final f;
    LazyIter(this.val, this.f);
    bool hasNext() => val != null;
    T next() {
        var res = val;
        val = f(val);
        return res;
    }
}


class SeqIterator<T> implements Iterator<T> {
  T _head;
  ISeq<T> _seq;
  SeqIterator(ISeq<T> seq):
    _head = seq === null? null : seq.first(),
    _seq  = seq === null? null : seq.rest();

  bool hasNext() => (_head !== null) || (_seq !== null);

  T next() {
    if (!hasNext()) throw new NoMoreElementsException();
    T tmp = _head;
    if (_seq === null) {
      _head = null;
      return tmp;
    }
    _head = _seq.first();
    _seq = _seq.rest();
    return tmp;
  }

}
class ConsSeq<T> implements ISeq<T>, Seqable<T> {
  final T _first;
  final _rest;
  const ConsSeq(this._first):
    _rest=null;
  const ConsSeq.cons(this._first, ISeq<T> rest):
    _rest = rest;
  T first() => _first;
  T rest() => _rest;
  ISeq<T> with(T o) => new ConsSeq<T>.cons(o,this);
  ISeq<T> seq() => this;
  Iterator<T> iterator() => new SeqIterator<T>(this);
  String toString() => "$_first::$_rest";
}

class IteratorSeq<T> implements ISeq<T>, Seqable<T> {
  final _first;
  final _rest;
  IteratorSeq(Iterator<T> it):
    _first = it.hasNext()? it.next() : null,
    _rest = it.hasNext()?new IteratorSeq<T>(it):null;//NB this should be lazy
  T first() => _first;
  ISeq<T> rest() => _rest;
  ISeq<T> with(T o) => new ConsSeq<T>.cons(o, this);
  Iterator<T> iterator() => new SeqIterator<T>(this);
  String toString() => "$_first::$_rest";
}
