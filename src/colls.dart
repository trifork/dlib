#library("dlib.colls");
#import("pprint.dart");
#import("utils.dart");

#source("colls/interfaces.dart");
#source("colls/seqs.dart");
#source("colls/abstracts.dart");
#source("colls/wrapping.dart");
#source("colls/values.dart");
#source("colls/pair.dart");


#source("colls/vector.dart");

int simpleHash(Iterable<Hashable> fields) {
  int h = 17;
  for (Hashable f in fields) {
    h += 31*h + ((f === null) ? 0 : f.hashCode());
  }
  return (h !== -1) ? h : 7;
}

makeHashCodeFun(Iterable<Hashable> fields) {
  var h = -1;
  return () => (h === -1)? (h=simpleHash(fields)) : h;
}

_un() {throw new UnsupportedOperationException("supports only the immutable interfaces.");}
