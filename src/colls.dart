#library("dlib.colls");
#import("pprint.dart");

final _a32 =  const //new Object[32]
  [null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null,
   null,null,null,null,null,null,null,null];

_arrayCopy(List src, int sidx, List dst, int didx, int length) {
  final int N=sidx+length;
  while(sidx<N) dst[didx++]=src[sidx++];
}

class _Node {
  final List array;
  const _Node(this.array);

  static clone(_Node other) {
    List arr = new List(other.array.length);
    _arrayCopy(other.array,0,arr,0,arr.length);
    return new _Node(arr);
  }
  toString() => str(array);
}

class PersistentVector {
  static final _EMPTY_NODE = const _Node(_a32);

  final int _cnt;
  final int _shift;
  final _Node _root;
  final List _tail;

  static final PersistentVector EMPTY =
    const PersistentVector(0, 5, _EMPTY_NODE, const []);

  const PersistentVector(this._cnt, this._shift, this._root, this._tail);

  int tailoff() {
    if(_cnt < 32) {
      return 0;
    }
    return ((_cnt - 1) >> 5) << 5;
  }

  List arrayFor(int i) {
    if(i >= 0 && i < _cnt) {
      if(i >= tailoff()) {
        return _tail;
      }
      _Node node = _root;
      for(int level = _shift; level > 0; level -= 5)
        node = node.array[(i >> level) & 0x01f];
      return node.array;
    }
    throw new IndexOutOfRangeException(i);
  }

  nth(int i) => arrayFor(i)[i & 0x01f];
  operator [](int idx) => nth(idx);
  operator []=(int idx, val) {
    throw new UnsupportedOperationException("PersistentVector Supports only mutable part of list interface.");
  }

  nthOr(int i, notFound) {
    if(i >= 0 && i < _cnt)
      return nth(i);
    return notFound;
  }

  assocN(int i, val) {
    if (i >= 0 && i < _cnt) {
      if (i >= tailoff()) {
        List newTail = new List(_tail.length);
        _arrayCopy(_tail,0,newTail,0,newTail.length);
        newTail[i & 0x01f] = val;
        return new PersistentVector(_cnt, _shift, _root, newTail);
      }
      return new PersistentVector(_cnt, _shift, _doAssoc(_shift, _root, i, val), _tail);
    }
    if(i == _cnt)
      return cons(val);
    throw new IndexOutOfRangeException(i);
  }

  _Node _doAssoc(int level, _Node node, int i, val) {
    _Node ret = _Node.clone(node);
    if (level == 0) {
      ret.array[i & 0x01f] = val;
    }
    else {
      int subidx = (i >> level) & 0x01f;
      ret.array[subidx] = _doAssoc(level - 5, node.array[subidx], i, val);
    }
    return ret;
  }


  PersistentVector cons(val){
    int i = _cnt;
    if(_cnt - tailoff() < 32) {
      var newTail = new List(_tail.length + 1);
      for (int i=0;i<_tail.length;i++) newTail[i] = _tail[i];//System.arraycopy?
      newTail[_tail.length] = val;
      return new PersistentVector(_cnt + 1, _shift, _root, newTail);
    }
    //full tail, push into tree
    _Node newroot;
    _Node tailnode = new _Node(_tail);
    int newshift = _shift;
    //overflow root?
    if((_cnt >> 5) > (1 << _shift)) {
      List arr = new List(32);
      arr[0] = _root;
      arr[1] = _newPath(_shift, tailnode);
      newroot = new _Node(arr);
      newshift += 5;
    }
    else {
      newroot = _pushTail(_shift, _root, tailnode);
    }
    List arr = new List(1);
    arr[0] = val;
    return new PersistentVector(_cnt + 1, newshift, newroot, arr);
  }


  _Node _pushTail(int level, _Node parent, _Node tailnode) {
    int subidx = ((_cnt - 1) >> level) & 0x01f;
    _Node ret = _Node.clone(parent);
    _Node nodeToInsert;
    if(level == 5) {
      nodeToInsert = tailnode;
    }
    else {
      _Node child = parent.array[subidx];
      nodeToInsert = (child != null)?
        _pushTail(level-5,child, tailnode)
        :_newPath(level-5, tailnode);
    }
    ret.array[subidx] = nodeToInsert;
    return ret;
  }

  _Node _newPath(int level, _Node node){
    if(level == 0)
      return node;
    List arr = new List(32);
    arr[0] = _newPath(level - 5, node);
    return new _Node(arr);
  }

  toString() => "${pstr(_root)} \ntail\n${pstr(_tail)}";

}





main() {
  var p = PersistentVector.EMPTY;
  for (int i=0;i<32*32+1;i++) {
    p = p.cons(i);
  }

  p = p.assocN(0,"42");
  print(p[0]);
  p[0] = 42;
}
