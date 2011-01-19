package com.mcard.popup
{
	import com.fwang.events.EventInData;
	import com.fwang.net.ImageUploader;
	import com.fwang.utils.JPEGEncoder;
	import com.mcard.Setting.Preset;
	import com.mcard.ViewerItemEdit;
	import com.mcard.manager.ImageManager;
	import com.mcard.viewerItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class SavePop extends Sprite
	{
		private const SAVE_START_DISPATCH_STR:String = "saveAction";
		private var saveClip:SaveClip = new SaveClip();
		private var uploadClip:UploadClip = new UploadClip();
		private var imgUploader:ImageUploader = new ImageUploader();
		private var timer:Timer = new Timer( 100 , 1 );
		private var mainMc:viewerItem;
		private var skinIdx:Number;
		private var saveTy:Number;
		private var viewerItemSave:ViewerItemEdit = new ViewerItemEdit( false );
		private var saveStatus:Number = 0;
		private var saveMainStatus:Boolean = false;
		private var saveCompleteStatus:Number = 0;
		private var baVector:Vector.<ByteArray> = new Vector.<ByteArray>;
		private var parameters:Object = new Object();
		
		public function SavePop()
		{
			super();
			addChild( saveClip );
			saveClip.addEventListener( MouseEvent.MOUSE_UP , saveClipMouseUp );
			imgUploader.addEventListener( ImageUploader.DISPATCHER_STR , saveComplete );
			imgUploader.addEventListener( EventInData.onAction , uploadComplete );
		}
		
		public function hide():void
		{
			saveHide();
			uploadHide();
		}
		public function saveShow( skinIdx:Number , ty:Number ):void
		{
			this.skinIdx = skinIdx;
			this.saveTy = ty;
			saveClip.x = 0;
		}
		public function saveShowTest( mc:MovieClip ):void
		{
			mainMc = mc as viewerItem;
			saveClip.x = 0;
		}
		private function saveHide():void
		{
			saveClip.x = -saveClip.width;
		}
		public function uploadShow():void
		{
			uploadClip.x = 0;
		}
		public function uploadHide():void
		{
			uploadClip.x = -uploadClip.width;
		}
		/*
		public function save():void
		{
			//this.skinIdx = skinIdx;
			saveAction();	// jpg 캡쳐 인코더
		}*/
		
		private function saveClipMouseUp( e:MouseEvent ):void
		{
			//saveActionDummy( saveStatus );
			baVector.length = 0;
			saveStatus = 0;
			saveMainStatus = false;
			saveCompleteStatus = 0;
			//saveAction( saveStatus );
			saveActionMain();
			saveActionDummy( saveStatus );
		}
		private function imageMake( _b:Bitmap ):ByteArray
		{
			var _scale:Number = Preset.SKIN_WH[0] / _b.width;
			var _width:Number = Preset.SKIN_WH[0];
			var _height:Number= _b.height * _width / _b.width;
			
			var bmd:BitmapData = new BitmapData( _width , _height );
			bmd.draw( _b , new Matrix( _scale , 0 , 0 , _scale ) );
			var ba:ByteArray = new JPEGEncoder( Preset.JPEG_QUALITY ).encode( bmd );
			return ba;
		}
		private function imageMakeMain():ByteArray
		{
			var bmd:BitmapData = new BitmapData( Preset.SKIN_WH[0] , Preset.SKIN_WH[1] );
			bmd.draw( mainMc );
			
			parameters.TitleX1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).x;
			parameters.TitleY1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).y;
			parameters.TitleIndex = mainMc._titleItemNumb;
			parameters.TitleAlpha = mainMc._titleItemAlpha;
			parameters.TitleColor = mainMc._titleItemColor;
			
			parameters.ManX1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x;
			parameters.ManY1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y;
			parameters.ManX2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).width;
			parameters.ManY2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).height;
			parameters.ManIndex = mainMc._manItemNumb;
			
			parameters.GirlX1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x;
			parameters.GirlY1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y;
			parameters.GirlX2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).width;
			parameters.GirlY2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).height;
			parameters.GirlIndex = mainMc._girlItemNumb;
			
			parameters.TextfieldX = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).x;
			parameters.TextfieldY = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).y;
			parameters.TextfieldW = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).width;
			parameters.TextfieldH = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).height;
			parameters.TextfieldText = ( mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText;
			
			parameters.TextfieldBgColor = mainMc._textfieldBgColor;
			parameters.TextfieldBgAlpha = mainMc._textfieldBgAlpha;
			
			var ba:ByteArray = new JPEGEncoder( Preset.JPEG_QUALITY ).encode( bmd );
			return ba;
		}
		
		/*
		private function saveAction():void
		{
			saveTy = 1;
			if( saveTy == 1 )	// body01 save case 
			{
				baVector[0] = imageMakeMain();
			} else if( saveTy == 2 ){
				baVector[0] = imageMakeMain();
			}
			if( ImageManager.imgArr[5] )
			{
				baVector[1] = imageMake( ImageManager.imgArr[5] );
			}
			if( ImageManager.imgArr[6] )
			{
				baVector[2] = imageMake( ImageManager.imgArr[6] );
			}
			if( ImageManager.imgArr[7] )
			{
				baVector[3] = imageMake( ImageManager.imgArr[7] );
			}
			if( ImageManager.imgArr[8] )
			{
				baVector[4] = imageMake( ImageManager.imgArr[8] );
			}
			if( ImageManager.imgArr[9] )
			{
				baVector[5] = imageMake( ImageManager.imgArr[9] );
			}
			parameters.member = MCard.xml.member[0].@member_id;
			imgUploader.sendImage( "http://project.fwangmeong.com/upload.php" , parameters.member + ".jpg" , baVector , parameters );
		}
		*/
		private function saveActionMain():void
		{
			var byArray:ByteArray;
			saveMainStatus = true;
			parameters.member_key = MCard.xml.member[0].@member_key;
			parameters.image_id = "main";
			byArray = imageMakeMain();
			imgUploader.sendImage( MCard.xml.url[1].@src , "main.jpg" , byArray , parameters );
		}
		private function saveActionDummy( ty:Number ):void
		{
			saveStatus++;
			parameters = new Object();
			parameters.member_key = MCard.xml.member[0].@member_key;
			parameters.image_id = ty;
			
			if( ImageManager.imgArr[ty] )
			{
				baVector[ty] = imageMake( ImageManager.imgArr[ty] );
				imgUploader.sendImage( MCard.xml.url[1].@src , ty + ".jpg" , baVector[ty] , parameters );
			}
			
			if( saveStatus < ImageManager.imgArr.length )
			{
				saveActionDummy( saveStatus );
			}
			//imgUploader.sendImage( "http://project.fwangmeong.com/upload.php" , "file" + ty + ".jpg" , baVector , parameters );
		}
		private function uploadComplete( e:EventInData ):void
		{
			saveCompleteStatus++;
			trace( e.data );
			
			if( saveCompleteStatus == saveStatus && saveMainStatus )
			{
				saveHide();
			}
		}
		/*
		private function uploadComplete( e:EventInData ):void
		{
			saveStatus++;
			MonsterDebugger.trace( this , "fileUpload" + saveStatus + " : " );
			MonsterDebugger.trace( this , e.data );
			trace( "uploadComplete : " , e.data );
			if( baVector.length == saveStatus )
			{
				saveHide();
			}
			
		}
		*/
		private function saveComplete( e:Event ):void
		{
			trace(" saveComplete " );
		}
			
	}
}