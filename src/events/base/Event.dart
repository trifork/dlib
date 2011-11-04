interface Event factory EventImpl {
  String get type();
  get payload();
  Event(String type, payload);

  EventTarget get target();
  EventTarget get currentTarget();

  void stopPropagation();
  void preventDefault();
  bool get propagationStopped();
  bool get defaultPrevented();

}

typedef void EventListener(Event event);
