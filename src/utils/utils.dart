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

// Missing math operations

int floor(num) => num ~/ 1;

num abs(num n) => n<0 ? -n : n;

int randomInt(int max) => floor(Math.random()*max);


// timing actions

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



//missing collection operations

nth(n, s) {
  for (var e in s) {
    if (n-- == 0) return e;
  }
  throw new IndexOutOfRangeException(n);
}

first(coll) => nth(0, coll);
second(coll) => nth(1, coll);



final _NOTHING = const Object();

//Maps arent collections :(

filter(m, p) {
  if (m is Map) {
    return filter_map(m,p);
  } else if (m is Collection) {
    return m.filter(p);
  }
}

filter_map(m, p) {
  Map r = {};
  m.forEach((k,v) {
      if (p(k,v)) {
        r[k] = v;
      }
    });
  return r;
}

key_for_value(Map m, val) {
  for(var k in m.getKeys()) {
    if (m[k] == val) return k;
  }
}

//collections don't have map, reduce/fold...
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


List toList(Collection coll) {
    if (coll is List) return coll;
    var result = [];
    coll.forEach((e)=> result.add(e));
    return result;
}

bool contains(Collection coll, element) {
    if (coll is Set) {
	return coll.contains(element);
    } else {
	return coll.some((e) => element == e);
    }
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

_list_equal(list1,list2) {
    if (list1 is !List || list2 is !List)
	return false;

    if (list1.length != list2.length)
	return false;

    for (int i = 0; i < list1.length; i++) {
	if (!equal(list1[i], list2[i]))
	    return false;
    }

    return true;
}

_set_equal(set1,set2) {
  if (set1 is !Set || set2 is !Set)
    return false;

  if (set1.length != set2.length)
    return false;

  for(var k in set1) {
    if (!set2.contains(k))
      return false;
  }

  return true;
}

_map_equal(map1,map2) {
    if (map1 is !Map || map2 is !Map)
	return false;

    if (map1.length != map2.length)
	return false;

    for(var k in map1.getKeys()) {
      if (!(map2.containsKey(k) && equal(map1[k], map2[k])))
	    return false;
    }

    return true;
}
