package com.fwang.utils
{
	import com.fwang.events.EventInData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FrameController extends Sprite
	{
		private var mc:MovieClip;
		private var _rotation:Boolean;
		
		public function FrameController( mc:MovieClip )
		{
			this.mc = mc;
			
		}
		public function go():void
		{
			if( mc.totalFrames != mc.currentFrame )		mc.addEventListener( Event.ENTER_FRAME , onGo );
			else if( mc.currentFrame != 1 )				mc.addEventListener( Event.ENTER_FRAME , onGo );
			_rotation = !_rotation;
		}
		private function onGo( e:Event ):void
		{
			if( _rotation )			mc.nextFrame();
			else					mc.prevFrame();
			if( mc.totalFrames == mc.currentFrame || mc.currentFrame == 1 ) {
				mc.removeEventListener( Event.ENTER_FRAME , onGo );
				dispatchEvent( new EventInData( _rotation as Object , EventInData.onAction , true ) );
			}
		}
		
		public function get __rotation():Boolean 
		{
			return this._rotation;
		}
		public function set __rotation( _rotation:Boolean ):void
		{
			this._rotation = _rotation;
		} 
		
	}
}