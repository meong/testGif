package com.mcard.manager
{
	import com.fwang.utils.ImageUtils;
	import com.mcard.Setting.Preset;
	
	import flash.display.Bitmap;

	public class ImageManager
	{
		static public var origImgArr:Array = new Array();	// 원본 이미지 저장 배열
		static public var imgArr:Array = new Array();		// 이미지 저장 배열
		static public var thumbArr:Array = new Array();		// 썸네일 이미지 저장 배열
		static public var dummyArr:Array = new Array();		// 임시 저장 더미 이미지 저장 배열
		
		static public var positionX:Vector.<Number> = new Vector.<Number>;
		static public var positionY:Vector.<Number> = new Vector.<Number>;
		static public var rotateV:Vector.<Number> = new Vector.<Number>;
		static public var isVertical:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectSepia:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectGray:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectOld:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectLuxury:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectLomo:Vector.<Number> = new Vector.<Number>;
		static public var effectBrightness:Vector.<Number> = new Vector.<Number>;
		static public var effectContrast:Vector.<Number> = new Vector.<Number>;
		
		static public var positionXDummy:Vector.<Number> = new Vector.<Number>;
		static public var positionYDummy:Vector.<Number> = new Vector.<Number>;
		static public var rotateVDummy:Vector.<Number> = new Vector.<Number>;
		static public var isVerticalDummy:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectSepiaDummy:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectGrayDummy:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectOldDummy:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectLuxuryDummy:Vector.<Boolean> = new Vector.<Boolean>;
		static public var effectLomoDummy:Vector.<Number> = new Vector.<Number>;
		static public var effectBrightnessDummy:Vector.<Number> = new Vector.<Number>;
		static public var effectContrastDummy:Vector.<Number> = new Vector.<Number>;
		
		public function ImageManager()
		{
			effectSepia.length = 10;
			effectGray.length = 10;
			effectOld.length = 10;
			effectLuxury.length = 10;
			effectLomo.length = 10;
			effectBrightness.length = 10;
			effectContrast.length = 10;
			positionX.length = 10;
			positionY.length = 10;
			rotateV.length = 10;
			isVertical.length = 10;
			
			effectSepiaDummy.length = 10;
			effectGrayDummy.length = 10;
			effectOldDummy.length = 10;
			effectLuxuryDummy.length = 10;
			effectLomoDummy.length = 10;
			effectBrightnessDummy.length = 10;
			effectContrastDummy.length = 10;
			positionXDummy.length = 10;
			positionYDummy.length = 10;
			rotateVDummy.length = 10;
			isVerticalDummy.length = 10;
		}
		
		public function setOrigImg( i:Number , b:Bitmap ):void
		{
			origImgArr[i] = ImageUtils.duplicateImage( b );
		}
		public function setImg( i:Number , b:Bitmap , isEffectSet:Boolean = true , isGray:Boolean = false , isSepia:Boolean = false , isOld:Boolean = false , isLuxury:Boolean = false , lomo:Number = 0 , brightness:Number = 50 , contrast:Number = 50 , _positionX:Number = 0 , _positionY:Number = 0 , rotateValue:Number = 0 ):void
		{
			imgArr[i] = ImageUtils.duplicateImage( b );
			dummyArr[i] = ImageUtils.duplicateImage( b );
			if( isEffectSet )
			{
				effectSepia[i] = isSepia;
				effectGray[i] = isGray;
				effectOld[i] = isOld;
				effectLuxury[i] = isLuxury;
				effectLomo[i] = lomo;
				effectBrightness[i] = brightness;
				effectContrast[i] = contrast;
				positionX[i] = _positionX;
				positionY[i] = _positionY;
				rotateV[i] = rotateValue;
				isVertical[i] = getIsVertical( rotateValue );
				
				effectSepiaDummy[i] = isSepia;
				effectGrayDummy[i] = isGray;
				effectOldDummy[i] = isOld;
				effectLuxuryDummy[i] = isLuxury;
				effectLomoDummy[i] = lomo;
				effectBrightnessDummy[i] = brightness;
				effectContrastDummy[i] = contrast;
				positionXDummy[i] = _positionX;
				positionYDummy[i] = _positionY;
				rotateVDummy[i] = rotateValue;
				isVerticalDummy[i] = getIsVertical( rotateValue );
			}
		}
		public function delImg( i:Number ):void
		{
			var ii:Number = i;
			for( ; ii < imgArr.length ; ii++ )
			{
				imgArr[ii] = imgArr[ii+1];
			}
			imgArr[imgArr.length-1] = null;
			imgArr.length = imgArr.length - 1;
			origImgArr[origImgArr.length-1] = null;
			origImgArr.length = origImgArr.length - 1;
			dummyArr[dummyArr.length-1] = null;
			dummyArr.length = dummyArr.length - 1;
		}
		
		public function setThumb( i:Number , b:Bitmap ):void
		{
			var _b:Bitmap = ImageUtils.duplicateImage( b );
			_b.width = Preset.TOPNAVI_WH[0];
			_b.height = Preset.TOPNAVI_WH[1];
			thumbArr[i] = _b;
		}
		public function delThumb( i:Number ):void
		{
			var ii:Number = i;
			for( ; ii < imgArr.length ; ii++ )
			{
				thumbArr[ii] = thumbArr[ii+1];
			}
			thumbArr[thumbArr.length-1] = null;
			thumbArr.length = thumbArr.length - 1;
		}
		
		static public function length():Number
		{
			return imgArr.length;
		}
		
		public function print():void
		{
			//trace("print()");
			for( var ii:Number = 0 ; ii < imgArr.length ; ii++ )
			{
				trace( "toString : [" + ii + "]" + imgArr[ii].toString() );
			}
		}
		
		private function getIsVertical( rotation:Number ):Boolean
		{
			var boo:Boolean;
			if( ( rotation / 90 ) % 2 == 0 )
			{
				boo = true;
			} else {
				boo = false;
			}
			return boo;
		}
			
	}
}