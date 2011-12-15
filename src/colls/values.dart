class Record extends WrappingMap {
  final _name;

  const Record(name, fields):
    super.from(fields),
    this._name = name;
  String toString() => "$_name[${_str(seq())}]";
  String _str(ISeq<Pair> s) {
    if (s !== null) {
      var f = s.first();
      var res = "${f.fst}:${f.snd}";
      var rest = s.rest();
      if (rest !== null) return res + ", " + _str(rest);
      return res;
    }
    return "";
  }
}
