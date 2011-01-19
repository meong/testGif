package com.mcard.manager
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	public class ImageGirlManager
	{
		static public var girlImgArr:Array = new Array();	// 이미지 저장 배열
		//static public var girlImgArr:Vector.<MovieClip> = new Vector.<MovieClip>;	// 이미지 저장 배열
		
		public function ImageGirlManager()
		{
		}
				
		public function setImgCnt( cnt:Number ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < cnt ; ii ++ )
			{
				girlImgArr[ii] = new Array();
			}
		}
		public function setImg( i:Number , j:Number , mc:MovieClip ):void
		{
			//trace( 'setImg init ');
			girlImgArr[i][j] = mc;
		}
	}
}