package com.controller
{
	import com.fwang.events.EventInData;
	import com.fwang.net.ImageUploader;
	import com.fwang.utils.JPEGEncoder;
	import com.mcard.Setting.Preset;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class ImageSaveController extends Sprite
	{
		private var skinIdx:Number;
		private var imgUploader:ImageUploader = new ImageUploader();
		
		public function ImageSaveController()
		{
			super();
		}
		public function save( skinIdx:Number ):void
		{
			this.skinIdx = skinIdx;
			var ba:ByteArray = imageMake();
			var parameters:Object = new Object();
			//parameters.imageIndex = ii;
			parameters.member = MCard.xml.member[0].@member_key;
			imgUploader.addEventListener( EventInData.onAction , uploadComplete );
			imgUploader.sendImage( "http://project.fwangmeong.com/upload.php" , "file.jpg" , ba , parameters , true );
			
		}
		
		private function imageMake():ByteArray
		{
			var bmd:BitmapData = new BitmapData( Preset.SKIN_WH[0] , Preset.SKIN_WH[1] );
			//bmd.draw( viewerItemEdit );
			var ba:ByteArray = new JPEGEncoder( Preset.JPEG_QUALITY ).encode( bmd );
			return ba;
		}
		private function uploadComplete( e:EventInData ):void
		{
			
			trace( "uploadComplete : " , e.target.data );
		}
			
	}
}