package com.mcard
{
	import com.fwang.events.EventInData;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Stage01 extends Sprite
	{
		private var body01Clip:Body01 = new Body01();
		private var viewer:Stage01Viewer = new Stage01Viewer( body01Clip.NaviItem );
		
		public function Stage01()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			this.addChild( body01Clip );
			this.addChild( viewer );
		}
		private function setListener():void
		{
			body01Clip.btnLeft.addEventListener( MouseEvent.CLICK , leftClick );
			body01Clip.btnRight.addEventListener( MouseEvent.CLICK , rightClick );
			body01Clip.btnNext.addEventListener( MouseEvent.CLICK , nextClick );
			body01Clip.btnPreview.addEventListener( MouseEvent.CLICK , previewClick );
			body01Clip.btnSave.addEventListener( MouseEvent.MOUSE_DOWN , saveDown );
			viewer.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
		}
		private function setDefault():void
		{
			viewer.x = Preset.IMGVIEWER_XY[0];				viewer.y = Preset.IMGVIEWER_XY[1];
		}
		
		public function get _status():Number
		{
			return viewer._status;
		}
		public function show():void
		{
			body01Clip.x = 0;
			viewer.x = Preset.IMGVIEWER_XY[0];				viewer.y = Preset.IMGVIEWER_XY[1];
		}
		public function hide():void
		{
			body01Clip.x = -body01Clip.width;
			viewer.x = -2000;
		}
		public function stageInit( isFirst:Number = NaN , imgSetFirst:Boolean = true ):void
		{
			if( isNaN( isFirst ) ) {
				viewer.stageInit();
			} else if( isFirst >= 0 && isFirst < 5 )
			{
				viewer.bitmapReset( isFirst );
			}
			 
		}
		public function bitmapSet():void
		{
			for( var ii:Number = 0 ; ii < ImageManager.length() ; ii++ )
			{
				if( ii >= 0 && ii < 5 )
				{
					viewer.bitmapReset( ii );
				}
			}
		}
		public function getSkinItem( skinIdx:Number ):MovieClip
		{
			return viewer.getSkinItem( skinIdx );
		}
		
		private function stageInitComplete( e:Event ):void
		{
			dispatchEvent( new EventInData( Preset.BODY01_CLASS_STRING , Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		}
		private function leftClick( e:MouseEvent ):void
		{
			viewer.move( false );
		}
		private function rightClick( e:MouseEvent ):void
		{
			viewer.move( true );
		}
		private function nextClick( e:MouseEvent ):void
		{
			dispatchEvent( new Event( "next" ) );
		}
		private function previewClick( e:MouseEvent ):void
		{
			dispatchEvent( new Event( "preview" ) );
		}
		private function saveDown( e:MouseEvent ):void
		{
			dispatchEvent( new Event( Preset.EVENT_STR_SAVE_DOWN ) );
		}
	}
}