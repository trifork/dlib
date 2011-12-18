#library("dlib.events.base");

#import("utils.dart");
#import("pprint.dart");

#source("events/base/Event.dart");
#source("events/base/EventImpl.dart");
#source("events/base/EventTarget.dart");

event(id,[data=null]) => new Event(id,data);
