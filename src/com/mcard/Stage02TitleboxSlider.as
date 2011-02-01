package com.mcard
{
	import caurina.transitions.Tweener;
	
	import com.fwang.events.EventInData;
	import com.mcard.Setting.Preset;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Stage02TitleboxSlider extends Stage02ItemboxSlider
	{
		public function Stage02TitleboxSlider(arrowClip:MovieClip, gap:Number, id:String)
		{
			super(arrowClip, gap, id);
		}
		override protected function imgLoadOn( _mc:MovieClip ):void
		{
			loadStatus++;
			var _mcBox:MovieClip = new MovieClip();
			var _mcWrap:MovieClip = new MovieClip();
			
			_mcBox.x = ( bgClip.maskBody.width * Preset.ITEM_SLIDE_RESIZE_RATE - _mc.width ) / 2 - gap + ( bgClip.maskBody.width * Preset.ITEM_SLIDE_RESIZE_RATE * itemBox.numChildren );
			_mcBox.y = ( bgClip.height * Preset.ITEM_SLIDE_RESIZE_RATE - _mc.height ) / Preset.ITEM_SLIDE_RESIZE_RATE;
			_mcBox.addChild( _mc );
			// mouseclick mc
			_mcWrap.buttonMode = true;
			_mcWrap.graphics.beginFill( 0x000000 , 0 );
			_mcWrap.graphics.drawRect( 0 , 0 , _mcBox.width , _mcBox.height );
			_mcWrap.graphics.endFill();
			_mcBox.addChild( _mcWrap );
			//_mc.mask = _mcWrap;
			
			_mcBox.addEventListener( MouseEvent.CLICK , itemClick );
			itemBox.addChild( _mcBox );
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
		override protected function leftClick( e:MouseEvent ):void
		{
			itemStatusChange( false );
			if( itemBox.x >= itemBoxStartX - 1 && itemBox.x <= itemBox.getChildAt( 0 ).width + itemBoxStartX )
			{
				itemBox.x = -bgClip.maskBody.width * xmlList.length() + itemBoxStartX;
			}
			Tweener.addTween( itemBox , { x: itemBox.x + bgClip.maskBody.width , time:0.5 , onComplete:arrowClickComplete } );
			arrowRemoveListener();
			dispatchEvent( new Event( Preset.TITLESLIDER_ARROWCLICK_DISPATCH_STR ) );
		}
		override protected function rightClick( e:MouseEvent ):void
		{
			itemStatusChange( true );
			Tweener.addTween( itemBox , { x: itemBox.x - bgClip.maskBody.width , time:0.5 , onComplete:arrowClickComplete } );
			arrowRemoveListener();
			dispatchEvent( new Event( Preset.TITLESLIDER_ARROWCLICK_DISPATCH_STR ) );
		}
		override protected function arrowClickComplete():void
		{
			if( itemStatus == xmlList.length() )
			{
				itemBox.x = itemBoxStartX;
			}
			arrowSetListener();
		}
	}
}