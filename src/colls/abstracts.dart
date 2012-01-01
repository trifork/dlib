class AIterator<E> implements Iterator<E> {
  List<E> _lst;
  int _idx;
  AIterator(this._lst):
    _idx = 0;
  bool hasNext() => _idx < _lst.length;
  E next() {
    if (!hasNext()) throw new NoMoreElementsException();
    return _lst[_idx++];
  }
}

class AbstractImmutableMap<K,V> implements Map<K,V>, Seqable, Hashable, Counted, Iterable {
  const AbstractImmutableMap();

  bool operator ==(other) {
    if (other is! AbstractImmutableMap) {return false;}
    return equal(this,other);
  }
  void operator []=(K key, V value) => _un();
  V putIfAbsent(K key, V ifAbsent()) => _un();
  V remove(K key) => _un();
  void clear() => _un();
  int count() => length;
  abstract Collection<K> getKeys();

  abstract V operator [](K key);

  ISeq<Pair<K,V>> seq() {
    var s = null;
    for(K k in this.getKeys()) {
      s = new ConsSeq<Pair<K,V>>.cons(new Pair<K,V>.of(k,this[k]),s);
    }
    return s;
  }
  Iterator<Pair<K,V>> iterator() => new SeqIterator(seq());//not too efficient
  String toString() => str(this);
}

class AbstractImmutableListMap<E> extends AbstractImmutableMap
    implements List, Map, Seqable, Hashable, Counted {
  const AbstractImmutableListMap();
  bool operator ==(other) {
    if (other is! AbstractImmutableListMap) {return false;}
    return equal(this,other);
  }

  //List
  void set length(int newLength) => _un();
  void add(E value) => _un();
  void addLast(E value) => _un();
  void addAll(Collection<E> collection) => _un();
  void sort(int compare(E a, E b)) => _un();
  void clear() => _un();
  E removeLast() => _un();
  void setRange(int start, int length, List<E> from, [int startFrom]) => _un();
  void removeRange(int start, int length) => _un();
  void insertRange(int start, int length, [E initialValue]) => _un();
  abstract E operator [](int index);

  ISeq<E> seq() {
    ISeq<E> s = null;
    for (int i=0;i<length;i++) {
      s = new ConsSeq<E>.cons(this[i],s);
    }
    return s;
  }
  Iterator<E> iterator() => new AIterator<E>(this);
  String toString() => str(this);
}
