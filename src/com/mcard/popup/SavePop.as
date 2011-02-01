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
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
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
		
		public var manTel:String;
		public var girlTel:String;
		
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
			var parameterText:URLVariables = new URLVariables();
			var ur:URLRequest = new URLRequest();
			var ul:URLLoader = new URLLoader();
			
			parameterText.TitleX1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).x;
			parameterText.TitleY1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).y;
			parameterText.TitleIndex = mainMc._titleItemNumb;
			parameterText.TitleAlpha = mainMc._titleItemAlpha;
			parameterText.TitleColor = mainMc._titleItemColor;
			
			parameterText.ManX1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x;
			parameterText.ManY1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y;
			parameterText.ManX2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).width;
			parameterText.ManY2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).height;
			parameterText.ManIndex = mainMc._manItemNumb;
			parameterText.ManTel = manTel;
			
			parameterText.GirlX1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x;
			parameterText.GirlY1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y;
			parameterText.GirlX2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).width;
			parameterText.GirlY2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).height;
			parameterText.GirlIndex = mainMc._girlItemNumb;
			parameterText.GirlTel = girlTel;
			
			parameterText.TextfieldX = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).x;
			parameterText.TextfieldY = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).y;
			parameterText.TextfieldW = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).width;
			parameterText.TextfieldH = mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ).height;
			parameterText.TextfieldText = ( mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText;
			
			parameterText.TextfieldBgColor = mainMc._textfieldBgColor;
			parameterText.TextfieldBgAlpha = mainMc._textfieldBgAlpha;
			
			ur.url = MCard.xml.url[2].@src;
			ur.data = parameterText;
			ur.method = URLRequestMethod.POST;
			
			ul.load( ur );
			
			var bmd:BitmapData = new BitmapData( Preset.SKIN_WH[0] , Preset.SKIN_WH[1] );
			bmd.draw( mainMc );
			
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
			parameters.image_id = "0";
			byArray = imageMakeMain();
			imgUploader.sendImage( MCard.xml.url[1].@src , "0.jpg" , byArray , parameters );
		}
		private function saveActionDummy( ty:Number ):void
		{
			var ty2:Number = ty + 1;
			saveStatus++;
			parameters = new Object();
			parameters.member_key = MCard.xml.member[0].@member_key;
			parameters.image_id = ty2;
			
			if( ImageManager.imgArr[ty] )
			{
				baVector[ty] = imageMake( ImageManager.imgArr[ty] );
				imgUploader.sendImage( MCard.xml.url[1].@src , ty2 + ".jpg" , baVector[ty] , parameters );
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
		private function textSendComplete( e:Event ):void
		{
			trace( e.currentTarget.toString() );
		}
		private function textSendError( e:IOErrorEvent ):void
		{
			trace( e.currentTarget.toString() );
		}
	}
}