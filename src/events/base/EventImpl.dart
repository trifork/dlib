class EventImpl implements Event {
  final String type;
  final payload;

  EventTarget target;
  EventTarget currentTarget;

  bool _propagationStopped;
  bool _preventDefault;
  EventImpl(this.type, this.payload):
    this._propagationStopped = false,
    this._preventDefault = false;

  factory Event(String type, payload) {
    return new EventImpl(type,payload);
  }

  bool get propagationStopped() => this._propagationStopped;
  bool get defaultPrevented() => this._preventDefault;

  void stopPropagation() { this._propagationStopped = true;}
  void preventDefault() {this._preventDefault = true;}

  String toString() => "Event[type:$type,target:$target,payload:${str(payload)},prop:$_propagationStopped,default:$_preventDefault]";
}
