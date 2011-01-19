package com.mcard.manager
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	public class ImageTitleManager
	{
		static public var titleImgArr:Array = new Array();	// 이미지 저장 배열
		//static public var titleImgArr:Vector.<MovieClip> = new Vector.<MovieClip>;	// 이미지 저장 배열
		static public var titleImgBitmapDataArr:Array = new Array();	// 원복 기능 위한 이미지 원본 칼라 비트맵 데이타
		
		public function ImageTitleManager()
		{
		
		}
		
		public function setImgCnt( cnt:Number ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < cnt ; ii ++ )
			{
				titleImgArr[ii] = new Array();
			}
		}
		public function setImg( i:Number , j:Number , mc:MovieClip ):void
		{
			//trace( 'setImg init ');
			titleImgArr[i][j] = mc;
		}
		
	}
}