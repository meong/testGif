package com.fwang.events
{
	import flash.events.Event;

	public class EventInData extends Event
	{
		public static const onAction:String = "onAction";
		public var data:Object;
		public function EventInData( obj:Object , type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = obj;
		}
		
	}
}