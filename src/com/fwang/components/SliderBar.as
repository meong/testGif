package com.fwang.components
{
	import com.fwang.events.EventInData;
	import com.fwang.utils.MathUtils;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SliderBar extends EventDispatcher
	{
		/**
		 * slider Component
		 * @author 황명규
		 * @param clip : slider clip
		 * 		clip.btnMinus : - 버튼
		 * 		clip.btnPlus : + 버튼
		 * 		clip.pointer : pointer clip
		 * @return void
		 *
		 */
		public static var CHANGE:String = "change";
		public var rate:Number;
		private var clip:MovieClip;
		private var isDown:Boolean = false;
		
		
		public function SliderBar( clip:MovieClip , defaultValue:Number = 100 )
		{
			super();
			this.clip = clip;
			setPoint( defaultValue );
			clip.btnMinus.addEventListener( MouseEvent.CLICK , minusClick );
			clip.btnPlus.addEventListener( MouseEvent.CLICK , plusClick );
			clip.pointer.addEventListener( MouseEvent.MOUSE_DOWN , pointerDown );
			clip.pointer.addEventListener( MouseEvent.MOUSE_MOVE , pointerMove );
			clip.pointer.addEventListener( MouseEvent.MOUSE_UP , pointerUp );
		}
		public function reset():void
		{
			clip.pointer.x = 0;
			setRate();
			dispatchEvent( new EventInData( rate , CHANGE ) );
		}
		public function stopDrag():void
		{
			clip.pointer.stopDrag();
			setRate();
			dispatchEvent( new EventInData( rate , CHANGE ) );
		}
		
		// 1 ~ 100 값을 받아 포인터 위치 강제 조절 
		public function setPoint( rate:Number ):void
		{
			// 시작 x 좌표 +  rate * 움직이는 width / 100
			var pointerX:Number = ( clip.btnMinus.x + clip.btnMinus.width / 2 + clip.pointer.width / 2 ) + ( rate * ( clip.btnPlus.x - clip.btnMinus.x - clip.btnMinus.width - clip.pointer.width ) / 100 );
			clip.pointer.x = pointerX;				
		}
		private function minusClick( e:MouseEvent ):void
		{
			//trace( "minus Click" );
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x - _parent.pointer.width;
			if( mvX < _mc.x + _mc.width / 2 + _parent.pointer.width / 2 )
				mvX = _mc.x + _mc.width / 2 + _parent.pointer.width / 2;
			_parent.pointer.x = mvX;
			
			setRate();
			dispatchEvent( new EventInData( rate , CHANGE ) );
		}
		private function plusClick( e:MouseEvent ):void
		{
			//trace( "plus Click" );
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x + _parent.pointer.width;
			if( mvX > _mc.x - _mc.width / 2 - _parent.pointer.width / 2 )
				mvX = _mc.x - _mc.width / 2 - _parent.pointer.width / 2;				
			_parent.pointer.x = mvX;
			
			setRate();
			dispatchEvent( new EventInData( rate , CHANGE ) );
		}
		private function pointerDown( e:MouseEvent ):void
		{
			//trace( "pointer Down" );
			isDown = true;
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			
			var rect:Rectangle = new Rectangle( _parent.btnMinus.x + _parent.btnMinus.width / 2 + _mc.width / 2 , _mc.y , _parent.btnPlus.x - _parent.btnMinus.x - _parent.btnMinus.width - _mc.width , 0 );
			_mc.startDrag( false , rect );
		}
		private function pointerMove( e:MouseEvent ):void
		{
			if( isDown )
			{
				//trace(" pointer move! " );
				setRate();
				
			}
		}
		private function pointerUp( e:MouseEvent ):void
		{
			//trace("pointer Up");
			isDown = false;
			clip.pointer.stopDrag();
			setRate();
			dispatchEvent( new EventInData( rate , CHANGE ) );
		}
		private function stageMouseUp( e:MouseEvent ):void
		{
			//trace("stage mouse Up");
			isDown = false;
			setRate();
		}
		
		private function setRate():void
		{
			// Math.round( ( pointer x - minimum x ) / pointer move area width ) * 100 ::  0 ~ 100  백분율로 반환
			rate = MathUtils.round( ( clip.pointer.x - Math.round( clip.btnMinus.x + clip.btnMinus.width / 2 + clip.pointer.width / 2 ) ) / ( clip.btnPlus.x - clip.btnMinus.x - clip.btnMinus.width - clip.pointer.width ) , 2 ) * 100;
			//trace(" set rate :  " , rate );
		}
	}
}