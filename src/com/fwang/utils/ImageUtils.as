package com.fwang.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;

	public class ImageUtils extends Sprite
	{
		private static const IMAGE_EXTENTION:Array = [ "" , "jpg" , "gif" , "png" , "jpeg" , "JPG" , "GIF" , "PNG" , "JPEG" ];
		private static const PHP_IMAGETYPE:Array = [ "" , "GIF" , "JPEG" , "PNG" , "SWF" , "PSD" , "BMP" , "TIFF_II" , "TIFF_MM" , "JPC" , "JP2" , "JPX" , "JB2" , "SWC" , "IFF" , "WBMP" , "XBM" ];
		private static const THUMB_MIN:String = "min";
		private static const THUMB_MAX:String = "max";
		private static const THUMB_FULL:String = "full";
		
		public function ImageUtils()
		{
			super();
		}
		public static function applyGray( b:Bitmap ):void
		{
			var matrix:Array = new Array();
            matrix = matrix.concat( [0.299 , 0.587 , 0.114 , 0 , 0 ] );
			matrix = matrix.concat( [0.299 , 0.587 , 0.114 , 0 , 0 ] );
			matrix = matrix.concat( [0.299 , 0.587 , 0.114 , 0 , 0 ] );
			matrix = matrix.concat( [0 , 0 , 0 , 1 , 0 ] );
			applyFilter(b, matrix);
		}
		
		public static function applyErase(rect:Rectangle , oriBMD:BitmapData , cloneBMD:BitmapData , resizeWidth:Number , resizeHeight:Number): void
		{
			// 지우개.
			var rectX:int = (rect.x * oriBMD.width) / resizeWidth;
			var rectY:int = (rect.y * oriBMD.height) / resizeHeight;
			var rectWidth:int = (rect.width * oriBMD.width) / resizeWidth;
			var rectHeight:int = (rect.height * oriBMD.height) / resizeHeight;
			var newRect:Rectangle = new Rectangle(rectX, rectY, rectWidth, rectHeight);
			oriBMD.fillRect(newRect, 0xFFFFFF);
			cloneBMD.fillRect(newRect, 0xFFFFFF);
		}
		
		private static function applyFilter(child:DisplayObject, matrix:Array):void {
            var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
            var filters:Array = new Array();
            filters.push(filter);
            child.filters = filters;
        }
    
		public static function duplicateImage(original:Bitmap = null ):Bitmap {
			if ( original == null )
				return null;
            var image:Bitmap = new Bitmap(original.bitmapData.clone());
			image.filters = original.filters;
            return image;
        }
		
		public static function isImage( file:String ):Number
		{
			var ii:Number = 0;
			for( ii ; ii < IMAGE_EXTENTION.length ; ii++ ){
				//trace( "StringUtils.get_extention( file ) : " + StringUtils.get_extention( file ) );
				if( StringUtils.get_extention( file ).toLocaleUpperCase().replace( 'JPG' , 'JPEG' ) == IMAGE_EXTENTION[ii] ) {
					return ii;
				}
			}
			return 0;
		}
		
		public static function getCanHTMLImage( num:Number ):Number		
		{
			var ii:Number = 0;
			for( ii ; ii < IMAGE_EXTENTION.length ; ii++ ){
				//trace( "StringUtils.get_extention( file ) : " + StringUtils.get_extention( file ) );
				if( PHP_IMAGETYPE[num] == IMAGE_EXTENTION[ii] ) {
					return ii;
				}
			}
			return 0;
		}
		
		/**
		 * bitmap 이미지를 리사이징하여 썸네일 생성. 
		 * ty : min 은 리사이징 사이즈 안에 다 들어오게 작게 리사이징하고 , 
		 * ty : max 는 리사이징 사이즈의 작은 선에 기준으로 넘치게 리사이징 한다.
		 * ty : full 은 width height 스케일 유지 안하고 full 로 채운다. 
		 * @param origBm : 리사이징 될 DisplayObject , 
		 * @param bm : 리사이징 사이즈를 가진 DisplayObject , 
		 * @param ty : 리사이징 타입 ty : max , min , full 
		 * @param isFill : 커질 경우 채울지 여부
		 * @return Vector.<Number> : width height 를 Vector 클래스로 반환. 
		 **/
		public static function getThumbWH( origBm:DisplayObject , bm:DisplayObject , ty:String = "min" , isFill:Boolean = false ):Vector.<Number>
		{
			//trace( "origBm.width , origBm.height , bm.width , bm.height )" , origBm.width , origBm.height , bm.width , bm.height );
			var vc:Vector.<Number> = new Vector.<Number>;
			vc[0] = origBm.width;
			vc[1] = origBm.height;
			
			var rate:Number = bm.width / bm.height;
			var rateOrig:Number = origBm.width / origBm.height;
			
			if( origBm.width <= bm.width && origBm.height < bm.height && !isFill )
			{
				// 리사이징 될 사이즈가 더 크고 isFill 이 false 이면 , 오리지날 비트맵 원본 크기 그대로 리턴.
				vc[0] = origBm.width;
				vc[1] = origBm.height;
				return vc;
			} else if( ty == "full" ) {
				// type 이 full 이면 리사이징 크기로 강제로 리사이징 한다. ( 스케일 왜곡됨. )
				vc[0] = bm.width;
				vc[1] = bm.height;
			} else {
				if( ty == "max" )	// case max
				{
					//trace("max");
					if( rate > rateOrig ) 
					{
						//trace("rate > rateOrig ");
						if( origBm.width > bm.width || ( origBm.width <= bm.width && isFill ) )
						{
							//trace( "origBm.width > bm.width || ( origBm.width <= bm.width && isFill )" );
							vc[0] = bm.width;
							vc[1] = bm.width * origBm.height / origBm.width;
						}
					} else {
						//trace( "rate <= rateOrig " );
						if( origBm.height > bm.height || ( origBm.height <= bm.height && isFill ) ) {
							//trace( "origBm.height > bm.height || ( origBm.height <= bm.height && isFill )" );
							vc[0] = bm.height * origBm.width / origBm.height;
							vc[1] = bm.height;
						}
					}
				}
				else if ( ty == "min" )	// case min
				{
					//trace("min");
					if( rate > rateOrig ) 
					{
						//trace("rate > rateOrig ");
						vc[0] = bm.height * origBm.width / origBm.height;
						vc[1] = bm.height;
					} else {
						//trace( "rate <= rateOrig " );
						vc[0] = bm.width;
						vc[1] = bm.width * origBm.height / origBm.width;
					}
				}
			}
			return vc;			
		}
		
	}
}