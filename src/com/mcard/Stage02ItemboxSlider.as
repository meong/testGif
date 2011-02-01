package com.mcard
{
	import caurina.transitions.Tweener;
	
	import com.fwang.events.EventInData;
	import com.fwang.net.SingleImgLoader;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageGirlManager;
	import com.mcard.manager.ImageManManager;
	import com.mcard.manager.ImageTitleManager;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Stage02ItemboxSlider extends Sprite
	{
		protected var bgClip:MovieClip;
		protected var gap:Number;
		private var id:String;
		protected var itemBox:MovieClip = new MovieClip();
		protected var itemBoxStartX:Number;
		
		protected var xmlList:XMLList = new XMLList();
		private var ty:String;
		private var sLoader:SingleImgLoader = new SingleImgLoader();
		protected var loadStatus:Number = 0;
		protected var itemStatus:Number = 0;
		
		
		public function Stage02ItemboxSlider( arrowClip:MovieClip , gap:Number , id:String )
		{
			super();
			this.bgClip = arrowClip;
			this.gap = gap;
			this.id = id;
			setDefault();
			setView();
			setListener();
		}
		private function setDefault():void
		{
			bgClip.x = bgClip.y = 0;
			itemBox.x = itemBoxStartX = bgClip.maskBody.x - bgClip.maskBody.width / 2 + gap; //bgClip.btnLeft.width + gap;
			itemBox.mask = bgClip.maskBody;
			( bgClip.btnLeft as MovieClip ).buttonMode = true;
			( bgClip.btnRight as MovieClip ).buttonMode = true;
		}
		private function setView():void
		{
			addChild( bgClip );
			addChild( itemBox );
		}
		private function setListener():void
		{
			arrowSetListener();
		}
		protected function arrowSetListener():void
		{
			bgClip.btnLeft.addEventListener( MouseEvent.CLICK , leftClick );
			bgClip.btnRight.addEventListener( MouseEvent.CLICK , rightClick );
		}
		protected function arrowRemoveListener():void
		{
			bgClip.btnLeft.removeEventListener( MouseEvent.CLICK , leftClick );
			bgClip.btnRight.removeEventListener( MouseEvent.CLICK , rightClick );
		}
		public function stageInit( xmlList:XMLList , ty:String ):void
		{
			this.ty = ty;
			this.xmlList = xmlList;
			imgLoadInit();
		}
		
		protected function leftClick( e:MouseEvent ):void
		{
			itemStatusChange( false );
			if( itemBox.x >= itemBoxStartX && itemBox.x <= itemBox.getChildAt( 0 ).width + itemBoxStartX )
			{
				itemBox.x = ( -itemBox.getChildAt( itemBox.numChildren / 2 ).x + gap ) / Preset.ITEM_SLIDE_RESIZE_RATE + itemBoxStartX;
			}
			Tweener.addTween( itemBox , { x: ( -itemBox.getChildAt( itemStatus ).x + gap ) / Preset.ITEM_SLIDE_RESIZE_RATE + itemBoxStartX , time:0.5 , onComplete:arrowClickComplete } );
			arrowRemoveListener();
		}
		
		protected function rightClick( e:MouseEvent ):void
		{
			itemStatusChange( true );
			Tweener.addTween( itemBox , { x: ( -itemBox.getChildAt( itemStatus ).x + gap ) / Preset.ITEM_SLIDE_RESIZE_RATE + itemBoxStartX , time:0.5 , onComplete:arrowClickComplete } );
			arrowRemoveListener();
		}
		protected function arrowClickComplete():void
		{
			if( itemStatus == xmlList.length() )
			{
				itemBox.x = itemBoxStartX;
			}
			arrowSetListener();
		}
		protected function itemStatusChange( boo:Boolean ):void
		{
			if( boo )
			{
				itemStatus++;
				if( itemStatus > xmlList.length() )
				{
					itemStatus -= xmlList.length();
				}
			} else {
				itemStatus--;
				if( itemStatus < 0 )
				{
					itemStatus = xmlList.length() - 1;
				}
			}
		}
		
		protected function imgLoadInit( numb:Number = 0 ):void
		{
			if( numb >= xmlList.length() ) 
			{
				numb -= xmlList.length();
				switch( ty )
				{
					case Preset.TITLE_ITEM_STRING :
						imgLoadOn( ImageTitleManager.titleImgArr[numb][MCard.xml.skin.length()+1] );
						break;
					case Preset.MAN_ITEM_STRING :
						imgLoadOn( ImageManManager.manImgArr[numb][MCard.xml.skin.length()+1] );
						break;
					case Preset.GIRL_ITEM_STRING :
						imgLoadOn( ImageGirlManager.girlImgArr[numb][MCard.xml.skin.length()+1] );
						break;
				}
			} else {
				switch( ty )
				{
					case Preset.TITLE_ITEM_STRING :
						imgLoadOn( ImageTitleManager.titleImgArr[numb][MCard.xml.skin.length()] );
						break;
					case Preset.MAN_ITEM_STRING :
						imgLoadOn( ImageManManager.manImgArr[numb][MCard.xml.skin.length()] );
						break;
					case Preset.GIRL_ITEM_STRING :
						imgLoadOn( ImageGirlManager.girlImgArr[numb][MCard.xml.skin.length()] );
						break;
				}
			}
		} 
		protected function imgLoadOn( $mc:MovieClip ):void
		{
			loadStatus++;
			var _mc:MovieClip = new MovieClip();
			_mc = $mc;
			_mc.buttonMode = true;
			if( itemBox.numChildren > 0 )
			{
				_mc.x = itemBox.getChildAt( itemBox.numChildren - 1 ).x + itemBox.getChildAt( itemBox.numChildren - 1 ).width + gap; //itemBox.x + itemBox.width + 20;
			} else {
				_mc.x = 0;
			}
			_mc.y = ( bgClip.height * Preset.ITEM_SLIDE_RESIZE_RATE - $mc.height ) / Preset.ITEM_SLIDE_RESIZE_RATE;
			itemBox.addChild( _mc );
			_mc.addEventListener( MouseEvent.CLICK , itemClick );
			
			if( loadStatus < xmlList.length() * 2 )
			{
				imgLoadInit( loadStatus );
			}
			else 
			{
				// load 완료  사이즈  줄이자.
				itemBox.width = itemBox.width / Preset.ITEM_SLIDE_RESIZE_RATE;
				itemBox.height = itemBox.height / Preset.ITEM_SLIDE_RESIZE_RATE;
				dispatchEvent( new EventInData( ( xmlList as XMLList )[0].name().toString() , Preset.DISPATCH_STAGEINIT_COMPLETE ) ); 
			}
		}
		protected function itemClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var arr:Array = new Array();
			arr[0] = id;
			arr[1] = _parent.getChildIndex( _mc );
			dispatchEvent( new EventInData( arr , EventInData.onAction ) );
		}
	}
}