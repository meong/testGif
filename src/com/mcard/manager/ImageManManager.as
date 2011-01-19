package com.mcard.manager
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	public class ImageManManager
	{
		static public var manImgArr:Array = new Array();	// 이미지 저장 배열
		//static public var manImgArr:Vector.<MovieClip> = new Vector.<MovieClip>;	// 이미지 저장 배열
		
		public function ImageManManager()
		{
		}
		
		public function setImgCnt( cnt:Number ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < cnt ; ii ++ )
			{
				manImgArr[ii] = new Array();
			}
		}
		public function setImg( i:Number , j:Number , mc:MovieClip ):void
		{
			//trace( 'setImg init ');
			manImgArr[i][j] = mc;
		}
	}
}