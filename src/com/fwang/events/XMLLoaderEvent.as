package com.fwang.events
{
	import flash.events.Event;

	public class XMLLoaderEvent extends Event
	{
		// 타입 설정
		public static const XML_COMPLETE: String = "xmlComplete";
		
		public var xml : XML;
		public function XMLLoaderEvent( xml:XML , type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.xml = xml;
		}
		
	}
}