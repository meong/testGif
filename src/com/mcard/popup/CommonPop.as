package com.mcard.popup
{
	import com.mcard.Setting.Preset;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CommonPop extends Sprite
	{
		private var popupClip:PopupClip = new PopupClip();
		
		public function CommonPop()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		
		private function setView():void
		{
			addChild( popupClip );
		}
		private function setListener():void
		{
			
		}
		private function setDefault():void
		{
			/*popupClip.mcBg.x = popupClip.mcBg.y = 0 ;
			popupClip.mcBg.width = Preset.DOCUMENT_WH[0];
			popupClip.mcBg.height = Preset.DOCUMENT_WH[1];
			*/
		}
		/* 
		11프레임 : 업로드는 10장 까지만 가능합니다.
		*/
		public function show( frame:Number ):void
		{
			showClip( frame );
			popupClip.x = 0;
		}
		public function hide():void
		{
			popupClip.x = -popupClip.width;
		}
		private function showClip( frame:Number ):void
		{
			popupClip.gotoAndStop(frame);
			/*if( ( popupClip.getChildByName( "alert0" + frame ) as MovieClip ).btnClose != null )
			{
				( popupClip.getChildByName( "alert0" + frame ) as MovieClip ).btnClose.addEventListener( MouseEvent.CLICK , closeClick );
			}*/
			if( popupClip.btnClose != null )
			{
				popupClip.btnClose.addEventListener( MouseEvent.CLICK , closeClick );
			}
			if( popupClip.btnCancel != null )
			{
				popupClip.btnCancel.addEventListener( MouseEvent.CLICK , cancelClick );
			}
			
		}
		private function closeClick( e:MouseEvent ):void
		{
			hide();
			dispatchEvent( new Event( Preset.COMMONPOP_CLOSE_CLICK_DISPATCH_STR ) );
		}
		private function cancelClick( e:MouseEvent ):void
		{
			hide();
			dispatchEvent( new Event( Preset.COMMONPOP_CANCEL_CLICK_DISPATCH_STR ) );
		}
	}
}