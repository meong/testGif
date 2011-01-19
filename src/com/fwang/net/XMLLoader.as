package com.fwang.net
{
	import com.fwang.events.XMLLoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoader extends EventDispatcher
	{
		private var urlLoader : URLLoader
		public function XMLLoader()
		{
			super();
		}
		public function load( url : String ) :void
		{
			this.urlLoader = new URLLoader();
			this.urlLoader.addEventListener(Event.COMPLETE , onComplete );
			this.urlLoader.load( new URLRequest( url ) );
		}
		private function onComplete ( e:Event ) : void
		{
			var xml:XML = new XML( this.urlLoader.data );
			this.dispatchEvent( new XMLLoaderEvent( xml , XMLLoaderEvent.XML_COMPLETE ) );
		}

	}
}