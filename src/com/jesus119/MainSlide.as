package com.jesus119
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class MainSlide extends Sprite
	{
		private var clip : SermonClip = new SermonClip();
		private var pastor : SlideLoad;
		private var pastorX : Number = 20;
		private var pastorY : Number = 68;
		public function MainSlide( xml:XML )
		{
			super();
			pastor = new SlideLoad( xml );
			addEvent();
			setLayout();
			defaultSetting();
		}
		private function addEvent():void
		{
			clip.arrows_leftmc.addEventListener( MouseEvent.MOUSE_OVER , onLeftOver );
			clip.arrows_leftmc.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
			clip.arrows_leftmc.addEventListener( MouseEvent.MOUSE_UP , onUp );
			clip.arrows_rightmc.addEventListener( MouseEvent.MOUSE_OVER , onRightOver );
			clip.arrows_rightmc.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
			clip.arrows_rightmc.addEventListener( MouseEvent.MOUSE_UP , onUp );
		}
		private function setLayout():void
		{
			addChild( pastor );
			addChild( clip );
		}
		private function defaultSetting():void
		{
			clip.y = 86;
		}
		private function onLeftOver( e:MouseEvent ):void
		{
			this.buttonMode = true;
			pastor.goDirection = false;
			pastor.moveSpeed = 1;
		}
		private function onDown( e:MouseEvent ):void
		{
			pastor.moveSpeed += 2;
		}
		private function onUp( e:MouseEvent ):void
		{
			pastor.moveSpeed = pastor.defaultSpeed;
		}
		private function onRightOver( e:MouseEvent ):void
		{
			this.buttonMode = true;
			pastor.goDirection = true;
			pastor.moveSpeed = 1;
		}
	}
}