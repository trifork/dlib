int simpleHash(fields) {
  int h = 17;
  for (var f in fields) {
    h += 31*h + (f === null) ? 0 : f.hashCode();
  }
  return h;
}

makeHashCodeFun(fields) {
  var h = -1;
  return () => (h === -1)? (h=simpleHash(fields)) : h;
}

makeEqualsFun(fields) {
  return (thz, other, other_fields) {
    if (thz === other) return true;
    return equals(fields, other_fields);
  };
}


class Record {

  final _hashfn;
  final _eqfn;
  final _fields
  const Value(fields):
    this._fields = fields,
    this._hashfn = makeHashCodeFun(fields),
    this._eqfn = makeEqualsFun(fields);

  int hashCode() => _hashfn();
  bool operator ==(other) => _eqfn(this,other,other._fields);
}
