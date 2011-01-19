package com.fwang.components
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class ImageSlider extends Sprite
	{
		private var arrLeftClip:Sprite;
		private var arrRightClip:Sprite;
		private var sliderBody:Sprite;
		private var imgGap:Number = 0;
		private var imgDefaultX:Number = 0;
		private var imgGroup:Array = new Array();
		private var linkGroup:Array = new Array();
		private var txtGroup:Array = new Array();
		private var txtGap:Number;
		private var rect:Sprite;
		private var rectBox:Sprite;
		private var txtFormat:TextFormat = new TextFormat();
		private var timer:Timer = new Timer( PreSet.sliderTimer );
		private var isMove:Boolean = false;
		
		public function ImageSlider( arrLeftClip:Sprite , arrRightClip:Sprite , sliderBody:Sprite , imgGap:Number , imgGroup:Array , linkGroup:Array = null , txtGroup:Array = null , txtGap:Number = 0 )
		{
			super();
			this.arrLeftClip = arrLeftClip;
			this.arrRightClip = arrRightClip;
			this.sliderBody = sliderBody;
			this.imgGap = imgGap;
			this.imgGroup = imgGroup;
			this.linkGroup = linkGroup;
			this.txtGroup = txtGroup;
			this.txtGap = txtGap;
			this.imgDefaultX = sliderBody.x;
			defaultSet();
			addClip();
			addListener();
		}
		private function defaultSet():void
		{
			rectBox = new Sprite();
			rectBox.x =  imgDefaultX;
			timer.start();
		}
		private function addClip():void
		{
			makeBox();
		}
			private function makeBox():void
			{
				var ii:Number;
				var txtFdWH:Array = new Array();
				txtFdWH[0]= sliderBody.getChildByName( "txtFd" ).width;
				txtFdWH[1] = sliderBody.getChildByName( "txtFd" ).height;
				// txtFormat = ( ( sliderBody.getChildByName( "txtFd" ) as Sprite ).getChildByName( "txt" ) as TextField ).getTextFormat();
				
				for( ii = sliderBody.numChildren - 1 ; ii >= 0 ; ii-- ) {
					sliderBody.removeChildAt( ii );
				}
				for( ii = 0 ; ii < imgGroup.length ; ii++ )
				{
					var tmpGap:Number = 38;
					var listenerMc:MovieClip = new MovieClip();
					sliderBody.addChild( listenerMc );
					if( ii > 0 )	tmpGap = imgGap;
					
					listenerMc.addChild( imgGroup[ii] );
					listenerMc.addEventListener( MouseEvent.CLICK , imgClick );
					listenerMc.buttonMode = true;
										
					sliderBody.addChild( listenerMc );
					listenerMc.x = ( imgGroup[ii].width + tmpGap ) * ii ;
					
					//add Listener MovieClip Create
					if( txtGroup.length == imgGroup.length ) {
						var txtfd:sliderTxtFd = new sliderTxtFd();
						txtfd.txt.text = txtGroup[ii];
						listenerMc.addChild( txtfd );
						txtfd.y = imgGroup[ii].height + txtGap;
						txtfd.x = imgGroup[ii].x + ( imgGroup[ii].width - txtFdWH[0] ) / 2;
					}
					
					// mask area setting
					if( ii < 4 ) {
						this.rect = new Sprite();
						rect.graphics.beginFill(0xFF0000);
						rect.graphics.drawRect( listenerMc.x , listenerMc.y , listenerMc.width , listenerMc.height );
						rectBox.addChild( rect );
					}
				}
				 
				addChild( arrLeftClip );
				addChild( arrRightClip );
				addChild( sliderBody );
				addChild( rectBox ); 
				sliderBody.mask = rectBox;
			}
				private function imgClick( e:MouseEvent ):void
				{
					var iii:Number = ( e.currentTarget as MovieClip ).parent.getChildIndex( e.currentTarget as MovieClip );
					navigateToURL( new URLRequest( linkGroup[iii] ) , "_self" );
				}
		private function addListener():void
		{
			arrLeftClip.addEventListener( MouseEvent.CLICK , leftClick );
			arrRightClip.addEventListener(MouseEvent.CLICK , rightClick );
			arrLeftClip.buttonMode = true;
			arrRightClip.buttonMode = true;
			timer.addEventListener( TimerEvent.TIMER , onTimer );
		}
			private function leftClick( e:MouseEvent ):void
			{
				moveImg( true );
			}
				private function moveImg( du:Boolean ):void
				{
					if( !isMove ) { 
						isMove = true;
						
						arrLeftClip.removeEventListener( MouseEvent.CLICK , leftClick );
						arrRightClip.removeEventListener( MouseEvent.CLICK , rightClick );
											
						var moveX:Number = imgGroup[0].width + imgGap;
						var moveXAction:Number = 0;
						if( du ) {
							if( sliderBody.x > rectBox.width - sliderBody.width + moveX ) {
								moveXAction = sliderBody.x - moveX;
							} else {
								moveXAction = imgDefaultX;
							}
							Tweener.addTween( sliderBody , {x: moveXAction , time:0.3 , transition:"linear" , onComplete:ClickComple } );
						} else {
							if( sliderBody.x < imgDefaultX ) {
								moveXAction = sliderBody.x + moveX;
							} else {
								moveXAction = rectBox.width - sliderBody.width + imgDefaultX;
							}
							Tweener.addTween( sliderBody , {x: moveXAction , time:0.3 , transition:"linear" , onComplete:ClickComple } );
						}
					}
				}
					private function ClickComple():void
					{
						arrLeftClip.addEventListener( MouseEvent.CLICK , leftClick );
						arrRightClip.addEventListener(MouseEvent.CLICK , rightClick );
						isMove = false;
					}
			private function rightClick( e:MouseEvent ):void
			{
				moveImg( false );
			}
				
		private function onTimer( e:TimerEvent ):void
		{
			moveImg( true );
		}
		
	}
}