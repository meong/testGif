package com.fwang.components
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollBarController extends Sprite
	{
		private var clipBody:Sprite;
		private var bodyHeight:Number;
		private var barClip:Sprite;
		private var barHeight:Number;
		
		private var bounds:Rectangle;
		private var barDefaultY:Number;
		private var clipDefaultY:Number; 
		private var square:Sprite = new Sprite();
		
		public function ScrollBarController( clipBody:Sprite , barClip:Sprite , bodyHeight:Number = 0 , barHeight:Number = 0 )  // ( bodyclip , barClip , viewBody height , barMoveHeight ); 
		{
			this.clipBody = clipBody;
			this.bodyHeight = bodyHeight;
			this.barClip = barClip;
			this.barHeight = barHeight;
			setView();
			setListener();
			defaultSet();
		}
		private function setView():void
		{
			addChild(square);
			//clipBody.mask = square;
		}
		private function setListener():void
		{
			barClip.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
		}
		private function defaultSet():void
		{
			clipBody.y = 0;
			barClip.buttonMode = true;
			bounds = new Rectangle( 0 , 0 , 0 , barHeight - barClip.height );
			bounds.x = barClip.x;
			bounds.y = barClip.y;
			barDefaultY = barClip.y;
			clipDefaultY = clipBody.y;
			
			square.graphics.beginFill(0xFF0000);
			square.graphics.drawRect( clipBody.x , clipBody.y , clipBody.width , bodyHeight );
		}
			private function onDown( e:MouseEvent ):void
			{
				barClip.startDrag( false , bounds );
				barClip.parent.stage.addEventListener( MouseEvent.MOUSE_MOVE , onMove );
				barClip.parent.stage.addEventListener( MouseEvent.MOUSE_UP , onUp );
			}
				private function onMove( e:MouseEvent ):void
				{
					onMoveAction();
				}
					public function onMoveAction():void
					{
						clipBody.y = getBodyY();						
					}
						private function getBodyY():Number
						{
							return clipDefaultY - ( ( barClip.y - barDefaultY ) / ( barHeight - barClip.height ) * 100 ) * ( clipBody.height - bodyHeight ) / 100;
						}
				private function onUp( e:MouseEvent ):void
				{
					barClip.parent.stage.removeEventListener( MouseEvent.MOUSE_MOVE , onMove );
					barClip.parent.stage.removeEventListener( MouseEvent.MOUSE_UP , onUp );
					barClip.stopDrag();
				}
		
		public function reset( isTween:Boolean = false ):void
		{
			var barY:Number = 0;
			
			if( clipBody.height > bodyHeight )
				barY = getBodyY();
			if( isTween ) {
				Tweener.addTween( clipBody , {time:0.2 , y:barY , transition:"linear" } );
			} else {
				clipBody.y = barY;
			}
			if( barY == 0 ) {
				Tweener.addTween( barClip , {time:0.2 , y:clipDefaultY , transition:"linear" } );
			}
		}
		public function set maskWidth( width:Number ):void
		{
			square.graphics.drawRect( square.x , square.y , width , square.height );
		}
		
	}
}