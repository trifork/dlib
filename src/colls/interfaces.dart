//Can turn itself into an ISeq
interface Seqable<T> extends Iterable<T> {
  ISeq<T> seq();
}
//constant time count
interface Counted {
  int count();
}
//fast indexed access
interface Indexed<T> extends Counted {
  T nth(int i);
  nthOr(int i, notFound);
}
interface ISeq<T> extends Seqable<T> {
  T first();
  ISeq<T> rest();
  ISeq<T> with(T o);
}

typedef fun1(arg1);
typedef fun2(arg1,arg2);
typedef fun3(arg1,arg2,arg3);
