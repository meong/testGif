package com.mcard.popup
{
	import flash.display.Sprite;
	
	public class LoadingPop extends Sprite
	{
		private var loadingClip:LoadingClip = new LoadingClip();
		public function LoadingPop()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			addChild( loadingClip );
		}
		private function setListener():void
		{
			
		}
		private function setDefault():void
		{
			
		}
		
		public function show():void
		{
			loadingClip.x = 0;
		}
		public function hide():void
		{
			loadingClip.x = -loadingClip.width;
		}
	}
}