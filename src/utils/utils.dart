/**
 * Copyright (c) 2011 by Trifork
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

int floor(double num) {
  String str = num.toString();
  int idx = str.indexOf(".");
  return Math.parseInt(str.substring(0,idx));
}

time(action, [watches]) {
  var actionTimer = new StopWatch();
  if (watches == null) {
    watches = [];
  } else if (watches is StopWatch) {
    watches = [watches];
  }
  assert(watches is Collection);
  try {
    watches.forEach((w) => w.start());
    actionTimer.start();
    action();
  } finally {
    actionTimer.stop();
    watches.forEach((w) => w.stop());
  }
  return actionTimer.elapsedInUs();
}



final _NOTHING = const Object();

//Maps arent collections, collections dont have map
map_with_index(coll, f, [context]) {
  var res = [];
  int idx=0;
  coll.forEach((k, [v=_NOTHING]) {
      if (v === _NOTHING) {
        res.add(f(k, idx, context));
      } else {
        res.add(f([k, v], idx, context));
      }
      idx += 1;
    });
  return res;
}

list2map(coll, [Map m = null]) {
  if (m == null) m = {};
  coll.forEach((v) => m[v[0]] = v[1]);
  return m;
}

zipmap(keys,vals) {
  Map m = {};
  map_with_index(keys,(k,i,_) {
      m[k] = vals[i];
    });
  return m;
}

map(coll, f) {
  return map_with_index(coll, (x,_,__)=>f(x));
}

reduce(coll, init, f) {
  if (coll.length == 0) return init;
  var cur = init;
  coll.forEach((v) {
      cur = f(cur,v);
    });
  return cur;
}


//
// Implements equals for collections (defaults to == for others)
//

equal(o1,o2) {

    if (o1==o2)
	return true;

    switch(true) {
    case o1 is Map:
	return _map_equal(o1,o2);

    case o1 is List:
	return _list_equal(o1,o2);

    case o1 is Set:
	return _set_equal(o1, o2);

    default:
	return o1==o2;
    }
}

_map_equal(map1,map2) {
    if (map1==map2)
	return true;

    if (map1 is !Map || map2 is !Map)
	return false;

    if (map1.length != map2.length)
	return false;

    for(var k in map1.getKeys()) {
	if (!equal(map1[k], map2[k]))
	    return false;
    }

    return true;
}


