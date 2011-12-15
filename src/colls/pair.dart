class _PairIterator implements Iterator {
  final _fst,_snd;
  int _idx;
  _PairIterator(this._fst,this._snd):_idx=0;
  bool hasNext() => _idx < 2;
  next() {
    if (_idx === 0) {_idx++; return _fst;}
    if (_idx === 1) {_idx++; return _snd;}
    throw new NoMoreElementsException();
  }
}

class Pair<P,Q> extends AbstractImmutableListMap {
  final P fst;
  final Q snd;
  final _hashFn;
  const Pair.of(P fst, Q snd):
    this.fst = fst,
    this.snd = snd,
    this._hashFn = makeHashCodeFun([fst, snd]);


  int hashCode() => _hashFn();
  bool operator ==(other) {
    if (other === this) return true;
    if (other is! Pair<P,Q>) return false;
    Pair p = other;
    return fst == p.fst && snd == p.snd;
  }
  String toString() => "<$fst,$snd>";

  Iterator iterator() => new _PairIterator(fst,snd);

  //Collections
  Collection filter(bool f(element)) {
    var res = [];
    if (f(fst)) res.add(fst);
    if (f(snd)) res.add(snd);
    return res;
  }

  bool every(bool f(element)) => f(fst) && f(snd);
  bool some(bool f(element)) => f(fst) || f(snd);

  forEach(f) {
    if (f is fun1) {
      f(fst);
      f(snd);
    } else {
      f(0,fst);
      f(1,snd);
    }
  }
  int get length() => 2;
  bool isEmpty() => false;

  bool containsValue(value) => value == fst || value == snd;
  bool containsKey(key) => key == 0 || key == 1;

  Collection getKeys() => const [0,1];
  Collection getValues() => [fst,snd];

  //List
  Pair([int length]):fst=null,snd=null,
    _hashFn = (()=>7) {
    if (length !== 2) throw new IndexOutOfRangeException(length);
  }
  Pair.from(Iterable other):
    fst = (other is List || other is Map)?(other[0]):new List.from(other)[0],
    snd = (other is List || other is Map)?(other[1]):new List.from(other)[1],
    _hashFn = makeHashCodeFun(other);

  operator [](int index) {
    if (index === 0) return fst;
    if (index === 1) return snd;
    throw new IndexOutOfRangeException(index);
  }

  int indexOf(element, [int start]) {
    if (start == 1) {
      if (element == snd) return 1;
      return -1;
    }
    if (element == fst) return 0;
    if (element == snd) return 1;
    return -1;
  }

  int lastIndexOf(element, [int start]) {
    if (start == 0) {
      if (element == fst) return 0;
      return -1;
    }
    if (element == snd) return 1;
    if (element == fst) return 0;
    return -1;
  }

  last() => snd;

  List getRange(int start, int length)  {
    if (start < 0 || start > 1) throw new IndexOutOfRangeException(start);
    if (length === 0) return [];
    if (length < 0 || (start+length)>2) throw new IndexOutOfRangeException(length);
    if (start === 0) {
      if (length == 1) return [fst];
      else return [fst,snd];
    } else {
      return [snd];
    }
  }

}
