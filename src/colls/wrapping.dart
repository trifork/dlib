class WrappingMap<K,V> extends AbstractImmutableMap<K,V> {
  final _inner;
  final _hashFn;
  const WrappingMap():
    _inner = const {},
    _hashFn = makeHashCodeFun(const []);

  WrappingMap.from(Map<K,V> other):
    _inner = new Map.from(other),
    _hashFn = makeHashCodeFun(other === null?const []:other.getValues());

  //bool operator equals correctly implemented in super
  int hashCode() => _hashFn();
  String toString() => "WrappingMap[${str(_inner)}]";

  bool containsValue(V value) => _inner.containsValue(value);
  bool containsKey(K key) => _inner.containsKey(key);
  V operator [](K key) => _inner[key];
  void forEach(void f(K key, V value)) => _inner.forEach(f);
  Collection<K> getKeys() => _inner.getKeys();
  Collection<V> getValues() => _inner.getValues();
  int get length() => _inner.length;
  bool isEmpty() => _inner.isEmpty();

}

class WrappingList<E> extends AbstractImmutableListMap<E> {
  final _inner;
  final _hashFn;

  WrappingList([int length]):
    _inner = null,
    _hashFn = null {
    _un();
  }

  WrappingList.withInner(List<E> list):
    _inner = list,
    _hashFn = makeHashCodeFun(list);

  WrappingList.from(Iterable<E> other):
    _inner = new List<E>.from(other),
    _hashFn = makeHashCodeFun(other === null?const [] : other);

  int hashCode() => _hashFn();
  String toString() => "WrappingList[${str(_inner)}]";

  //Collection
  void forEach(void f(E element)) => _inner.forEach(f);
  Collection<E> filter(bool f(E element)) => _inner.filter(f);
  bool every(bool f(E element)) => _inner.every(f);
  bool some(bool f(E element))  => _inner.some(f);
  bool isEmpty() => _inner.isEmpty();
  int get length() => _inner.length;
  //List
  E operator [](int index) => _inner[index];
  int indexOf(E element, [int start]) => _inner.indexOf(element, start);
  int lastIndexOf(E element, [int start]) => _inner.lastIndexOf(element,start);
  E last() => _inner.last();
  List<E> getRange(int start, int length) => _inner.getRange(start,length);

}
