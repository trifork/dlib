final _a32 =  const //new Object[32]
  [null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null];


_arrayCopy(List src, int sidx, List dst, int didx, int length) {
  final int N=sidx+length;
  while(sidx<N) dst[didx++]=src[sidx++];
}

_clone(List arr) {
  List newList = new List(arr.length);
  _arrayCopy(arr,0,newList,0,arr.length);
  return newList;
}

class CopyOnWriteList<T>  extends WrappingList<T> implements Indexed<T>, Hashable {

  CopyOnWriteList.from(Iterable<T> list):
    super.from(list);

  CopyOnWriteList.withInner(List<T> list):
    super.withInner(list);
  //Seqable<T> <- use default implementation for now
  //ISeq<T> seq() => _ni();

  //Indexed<T>
  T nth(int i) => this[i];

  //Iterable<T>
  Iterator<T> iterator() => _inner.iterator();

  //Collection<T>

  //IPList<T>
  PList<T> assoc(i, val) {
    if (i >= 0 && i < _inner.length) {
      var l = _clone(_inner);
      l[i] = val;
      return new CopyOnWriteList<T>.withInner(l);
    }
    if(i == _cnt)
      return with(val);
    throw new IndexOutOfRangeException(i);
  }

  PList with(val){
    var l = new List<T>(_inner.length + 1);
    _arrayCopy(_inner,0,l,0,_inner.length);
    l[_inner.length] = val;
    return new CopyOnWriteList<T>.withInner(l);
  }

}

class PList<T> extends AbstractImmutableListMap<T> implements Indexed<T>, Hashable {
  static final _EMPTY_NODE = _a32;

  final int _cnt;
  final int _shift;
  final _root;
  final List _tail;

  static final PList EMPTY =
    const PList(0, 5, _EMPTY_NODE, const []);

  const PList(this._cnt, this._shift, this._root, this._tail);

  factory PList<T>.from(Iterable<T> other) {
    var v = PList.EMPTY;
    for (var o in other) v = v.with(o);
    return v;
  }

  int _tailoff() {
    if(_cnt < 32) {
      return 0;
    }
    return ((_cnt - 1) >> 5) << 5;
  }

  List _arrayFor(int i) {
    if(i >= 0 && i < _cnt) {
      if(i >= _tailoff()) {
        return _tail;
      }
      var node = _root;
      for(int level = _shift; level > 0; level -= 5)
        node = node[(i >> level) & 0x01f];
      return node;
    }
    throw new IndexOutOfRangeException(i);
  }

  _ni() { throw new NotImplementedException();}

  //Seqable<T> <- use default implementation for now
  //ISeq<T> seq() => _ni();

  //Indexed<T>
  T nth(int i) => _arrayFor(i)[i & 0x01f];
  nthOr(int i, notFound) {
    if(i >= 0 && i < _cnt)
      return nth(i);
    return notFound;
  }

  //Iterable<T>
  Iterator<T> iterator() => new _PListIterator(this);

  //Collection<T>
  void forEach(void f(T element)) {
    for (var e in iterator()) f(e);
  }
  Collection<T> filter(bool f(T element)) {
    PList<E> vec = EMPTY;
    for (var e in iterator()) {
      if (f(e)) {
        vec = vec.with(e);
      }
    }
    return vec;
  }
  bool every(bool f(T element)) {
    for (var e in iterator()) {
      if (!f(e)) return false;
    }
    return true;
  }
  bool some(bool f(T element)) {
    for (var e in iterator()) {
      if (f(e)) return true;
    }
    return false;
  }
  bool isEmpty() => _cnt === 0;
  int get length() => _cnt;

  //List<T>
  T operator [](int idx) => nth(idx);
  int indexOf(T element, [int start]) => _ni();
  int lastIndexOf(T element, [int start]) => _ni();
  T last() {
    if (isEmpty()) throw new IndexOutOfBoundsException(0);
    return nth(_cnt - 1);
  }
  //this is subvec
  List<T> getRange(int start, int length) => _ni();


  //Map<int,T>
  bool containsValue(T value) => some((x) => x == value);
  bool containsKey(int key) => 0 <= key && key < _cnt;
  Collection<int> getKeys() {
    var res = EMPTY;
    for (int i=0;i<_cnt;i++) {
      res = res.with(i);
    }
    return res;
  }
  Collection<T> getValues() => this;


  //IPList<T>

  PList<T> assoc(i, val) {
    if (i >= 0 && i < _cnt) {
      if (i >= _tailoff()) {
        List newTail = new List(_tail.length);
        _arrayCopy(_tail,0,newTail,0,newTail.length);
        newTail[i & 0x01f] = val;
        return new PList(_cnt, _shift, _root, newTail);
      }
      return new PList(_cnt, _shift, _doAssoc(_shift, _root, i, val), _tail);
    }
    if(i == _cnt)
      return with(val);
    throw new IndexOutOfRangeException(i);
  }

  _doAssoc(int level, node, int i, val) {
    var ret = _clone(node);
    if (level == 0) {
      ret[i & 0x01f] = val;
    }
    else {
      int subidx = (i >> level) & 0x01f;
      ret[subidx] = _doAssoc(level - 5, node[subidx], i, val);
    }
    return ret;
  }


  PList with(val){
    int i = _cnt;
    if(_cnt - _tailoff() < 32) {
      var newTail = new List(_tail.length + 1);
      for (int i=0;i<_tail.length;i++) newTail[i] = _tail[i];
      newTail[_tail.length] = val;
      return new PList(_cnt + 1, _shift, _root, newTail);
    }
    //full tail, push into tree
    var newroot;
    var tailnode = _tail;
    int newshift = _shift;
    //overflow root?
    if((_cnt >> 5) > (1 << _shift)) {
      List arr = new List(32);
      arr[0] = _root;
      arr[1] = _newPath(_shift, tailnode);
      newroot = arr;
      newshift += 5;
    }
    else {
      newroot = _pushTail(_shift, _root, tailnode);
    }
    List arr = new List(1);
    arr[0] = val;
    return new PList(_cnt + 1, newshift, newroot, arr);
  }


  _pushTail(int level, parent,  tailnode) {
    int subidx = ((_cnt - 1) >> level) & 0x01f;
    var ret = _clone(parent);
    var nodeToInsert;
    if(level == 5) {
      nodeToInsert = tailnode;
    }
    else {
      var child = parent[subidx];
      nodeToInsert = (child != null)?
        _pushTail(level-5,child, tailnode)
        :_newPath(level-5, tailnode);
    }
    ret[subidx] = nodeToInsert;
    return ret;
  }

  _newPath(int level, node){
    if(level == 0)
      return node;
    List arr = new List(32);
    arr[0] = _newPath(level - 5, node);
    return arr;
  }

  toString() => lstr(this);

}



class _PListIterator implements Iterator {
  PList vec;
  int sft;
  List path;
  List current;
  int currentIndex;

  _PListIterator(vec):
    this.vec = vec,
    this.currentIndex = 0,
    this.sft = vec._shift {
    path = initialPath();
    var el = path.peek();
    if (el.fst == -1) {
      current = el.snd;
    } else {
      current = (el.snd[el.fst]);
    }
  }

  bool hasNext() {
    ensureCurrentReady();
    return (current !== null && currentIndex < current.length);
  }

  ensureCurrentReady() {
    if (current !== null && currentIndex < current.length) {
      return;
    }//else current is null or exhausted. Find next
    List last = current;
    current = findNextArray();
    if (current !== last) {
      currentIndex = 0;
    }
  }
  List findNextArray() {
    if (path.isEmpty()) {return null;}
    while(path.peek().fst != -1) {
      Pair loc = path.pop();
      int idx = loc.fst;
      List arr = loc.snd;
      idx += 1;
      if (idx < arr.length) {
       var next = arr[idx];
        if (next === null) {
          continue;
        }
        path.push(new Pair.of(idx, arr));
        for(int level = sft - (path.length - 1) * 5; level > 0; level -= 5) {
          path.push(new Pair.of(0,next));
          next = next[0];
        }
        return next;

      }
    }
    return path.pop().snd;
  }

  _FastStack initialPath() {
    _FastStack res = new _FastStack();
    res.push(new Pair.of(-1, vec._tail));
   var node = vec._root;
    for(int level = sft; level > 0; level -= 5) {
      res.push(new Pair.of(0,node));
      node = node[0];
      if (node === null) {
        res.pop();
        break;
      }
    }
    return res;
  }

  next() => current[currentIndex++];

}

class _FastStack {
  final arr;
  int _size;
  _FastStack():
    this.arr = new List(7),
    this._size = 0;

  peek() => this.arr[_size-1];
  push(o) => this.arr[_size++] = o;
  pop() {
    _size -= 1;
    var res = this.arr[_size];
    this.arr[_size] = null;
    return res;
  }
  get length() => _size;
  isEmpty() => _size === 0;
}
