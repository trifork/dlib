pstr(obj, [increment="  ", prefix="", content="  ", suffix="", newline=true]) {
  StringBuffer res = new StringBuffer();
  _line(str, indent, [newline=true]) {
    res.add(indent);
    res.add(str);
    if (newline) {
      res.add("\n");
    }
  }
  if (obj is Map) {
    _line("{",prefix,newline:newline);
    _entries(res, obj, increment, content, newline);
    _line("}", suffix, newline:false);
  } else if (obj is List) {
    _line("[",prefix,newline:newline);
    _entries(res, obj, increment, content, newline);
    _line("]", suffix,newline:false);
  } else if (obj is Set) {
    _line("#{",prefix,newline:newline);
    _entries(res, obj, increment, content, newline);
    _line("}", suffix, newline:false);
  } else if (obj is Queue) {
    _line("Queue[", prefix, newline:newline);
    _entries(res, obj, increment, content, newline);
    _line("]", suffix, newline:false);
  } else if (obj is String) {
    _line("\"$obj\"", prefix, newline:false);
     //TODO(kkr@trifork.com) should handle escaping
  }
  else {
    //TODO(kkr@trifork.com) handle other types?
    _line(obj, prefix, newline:false);
  }
  return res.toString();

}


pp(obj, [indent="  ", increment="  ", newline=true]) {
  print(pstr(obj,
             increment: increment,
             content: indent,
             newline: newline));
}


str(obj) {
  return pstr(obj, increment: "", content: "", newline: false);
}

p(obj) {
  print(str(obj));
}


final _NONE = const Object();

_entries(res, obj, inc, indent, newline, [separator=":"]) {
  var cnt = obj.length;
  obj.forEach((k, [v = _NONE]) {
      cnt -= 1;
      res.add(pstr(k,
                   increment:inc,
                   prefix: indent,
                   content: inc+indent,
                   suffix: indent,
                   newline:newline));
      if (v !== _NONE) {
        res.add(separator);
        res.add(pstr(v,
                     increment:inc,
                     prefix: " ",
                     content: inc+indent,
                     suffix: indent,
                     newline:newline));
      }
      if (cnt > 0) res.add(", ");
      if (newline) res.add("\n");
    });
}
