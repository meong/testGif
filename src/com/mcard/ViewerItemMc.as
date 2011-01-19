package com.mcard
{
	import com.fwang.utils.DisplayObjectUtils;
	import com.fwang.utils.ImageUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageManager;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	public class ViewerItemMc extends MovieClip
	{
		private var numb:Number;
		private var mcDummy:MovieClip = new MovieClip();
		private var mc:MovieClip = new MovieClip();
		private var b:Bitmap = new Bitmap();
		private var maskMc:MovieClip = new MovieClip();
		private var _rotation:Number;
		private var _width:Number;
		private var _height:Number;
		private var cutWidth:Number;
		private var cutHeight:Number;
		
		public function ViewerItemMc( mc:MovieClip , b:Bitmap = null )
		{
			super();
			this.mc = mc;
			switch( mc.name )
			{
				case Preset.SKIN_MAIN_BOX :
					numb = 0;
					break;
				case Preset.SKIN_SUB1_BOX :
					numb = 1;
					break;
				case Preset.SKIN_SUB2_BOX :
					numb = 2;
					break;
				case Preset.SKIN_SUB3_BOX : 
					numb = 3;
					break;
				case Preset.SKIN_SUB4_BOX :
					numb = 4;
					break;
			}
			
			_rotation = mc.rotation;
			mc.rotation = 0;
			
			_width = mc.width;
			_height = mc.height;
			mc.rotation = _rotation;
			if( b )			setBitmap( b );
		}
		public function setBitmap( b:Bitmap ):void
		{
			if( mcDummy.numChildren )
				mcDummy.removeChildAt( 0 );
			this.b = ImageUtils.duplicateImage( b );
			if( b )
			{
				setDefault();
				setView();
				setListener();
			}
		}
		private function setDefault():void
		{
			mc.rotation = 0;
			
			b = bitmapResize();
			
			mcDummy.x = mc.x;
			mcDummy.y = mc.y;
			mcDummy.rotation = _rotation;
			
			// mask setting
			maskMc.graphics.beginFill( 0x000000 );
			maskMc.graphics.drawRect( 0 , 0 , _width , _height );
			maskMc.graphics.endFill();
			maskMc.rotation = _rotation;
			maskMc.x = mc.x;
			maskMc.y = mc.y;
			mcDummy.mask = maskMc;
		}
		private function setView():void
		{
			addChild( mcDummy );
			mcDummy.addChild( b );
			
			switch( ImageManager.rotateV[numb] )
			{
				case 0 : 
					
					break;
				case 90 :
					b.x = b.width;
					break;
				case 180 :
					b.x = b.width;
					b.y = b.height;
					break;
				case 270 :
					b.y = b.height;
					break;
			}
			
			addChild( maskMc );
		} 
		private function setListener():void
		{
		}
		
		private function bitmapResize():Bitmap
		{
			var tmpRate:Number = _width / _height;
			var imgRate:Number
			var imgRate1:Number = b.width / b.height;
			var imgRate2:Number = b.height / b.width;
			var tmpX:Number = 0;
			var tmpY:Number = 0;
			if( ImageManager.isVertical[numb] )
			{
				imgRate = imgRate1;
			} else {
				imgRate = imgRate2;
			}
			
			if( b.width <= _width && b.height <= _height )
			{
				// 무비 클립 자리보다 이미지가 작으면 그대로 리턴
			} else 
			{
				// resize width height 를 구한다.
				if( tmpRate > imgRate )	// 세로로 더 길다.
				{
					switch( ImageManager.rotateV[numb] )
					{
						case 0 :
							cutWidth =  b.width;
							cutHeight = b.width *( 1 / tmpRate );
							tmpX = 0;
							// ( 비트맵 원본 height - cut height) / 2 * ( ( positionRate + 0.5 ) * 2 )  Rate 범위가  -0.5 ~ 0.5
							tmpY = ( b.height - cutHeight ) * ( ImageManager.positionY[numb] + 0.5 );
							break;
						case 90 :
							cutWidth =  b.height *( 1 / tmpRate );
							cutHeight = b.height;
							tmpX = ( b.width - cutWidth ) * ( ImageManager.positionY[numb] + 0.5 );
							tmpY = 0;
							break;
						case 180 : 
							cutWidth =  b.width;
							cutHeight = b.width *( 1 / tmpRate );
							tmpX = 0;
							tmpY = b.height - ( ( b.height - cutHeight ) * ( ImageManager.positionY[numb] + 0.5 ) ) - cutHeight;
							break;
						case 270 :
							cutWidth =  b.height *( 1 / tmpRate );
							cutHeight = b.height;
							tmpX = b.width - ( ( b.width - cutWidth ) * ( ImageManager.positionY[numb] + 0.5 ) ) - cutWidth;
							tmpY = 0;
							break;
					}
				}
				else 					// 가로로 더 길다.
				{
					
					switch( ImageManager.rotateV[numb] )
					{
						case 0 :
							cutWidth =  b.height * tmpRate ;
							cutHeight = b.height;
							// ( 비트맵 원본  width - cut width ) / 2 * ( ( positionRate + 0.5 ) * 2 )  Rate 범위가  -0.5 ~ 0.5
							tmpX = ( b.width - cutWidth ) * ( ImageManager.positionX[numb] + 0.5 ) ;
							tmpY = 0;
							break;
						case 90 :
							cutWidth =  b.width;
							cutHeight = b.width * tmpRate;
							tmpX = 0;
							tmpY = b.height - ( b.height - cutHeight ) * ( ImageManager.positionX[numb] + 0.5 ) - cutHeight ;
							break;
						case 180 :
							cutWidth =  b.height * tmpRate ;
							cutHeight = b.height;
							tmpX = b.width - ( ( b.width - cutWidth ) * ( ImageManager.positionX[numb] + 0.5 ) ) - cutWidth;
							tmpY = 0;
							break;
						case 270 :
							cutWidth =  b.width;
							cutHeight = b.width * tmpRate;
							tmpX = 0;
							tmpY = ( b.height - cutHeight ) * ( ImageManager.positionX[numb] + 0.5 );
							break;
					}
					
				}
			}
			
			var bMap:Bitmap = new Bitmap();
			
			if( b.width >= cutWidth && b.height >= cutHeight )
			{
				bMap = DisplayObjectUtils.crop( tmpX , tmpY , cutWidth , cutHeight , b );
			} else {
				bMap = ImageUtils.duplicateImage( b );
			}
			
			if( ImageManager.isVertical[numb] )
			{
				bMap.width = _width;
				bMap.height = _height;
			} else {
				bMap.width = _height;
				bMap.height = _width;
			}
			bMap.rotation = ImageManager.rotateV[numb];
			//var bMapTemp:Bitmap = ImageUtils.duplicateImage( bMap );
			//this.addChild( bMapTemp ); 
			return bMap;
		}
	}
}