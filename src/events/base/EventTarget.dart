class EventTarget {
  EventTarget parent;
  final EventTargetEvents _events;

  EventTarget(this.parent, this._events);

  void dispatch(Event event) {
    event.target = this;
    this.on[event.type].dispatch(event);
    if (this.parent !== null && !event.propagationStopped) {
      this.parent.dispatch(event);
    }
    if (!event.defaultPrevented) {
      defaultBehavior(event);
    }
  }

  void defaultBehavior(Event event) {}

  get on() => this._events;
}

class EventTargetEvents {

  Map<String, EventListenerList> _listeners;

  EventTargetEvents(): this._listeners = <String,EventListener> {};

  EventListenerList operator [](String type) {
    return _get(type.toLowerCase());
  }

  EventListenerList _get(String type) {
    return _listeners.putIfAbsent(type,
      () => new EventListenerList(type));
  }

}

class EventListenerList {
  final String _type;
  final List _listeners;
  EventListenerList(this._type) : this._listeners = [];

  EventListenerList add(fn) {
    this._listeners.add(fn);
    return this;
  }

  EventListenerList remove(fn) {
    int idx = 0;
    while(idx < _listeners.length) {
      if(fn === _listeners[idx]) {
        this._listeners.removeRange(idx,1);
        return this;
      }
      idx++;
    }
    return this;
  }

  EventListenerList dispatch(Event e) {
    assert(e.type === _type);
    for (var l in _listeners) {
      l(e);
      if (e.propagationStopped) {
        return;
      }
    }
  }

}
