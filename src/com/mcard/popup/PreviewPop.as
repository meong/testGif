package com.mcard.popup
{
	import caurina.transitions.Tweener;
	
	import com.fwang.events.EventInData;
	import com.fwang.net.SingleImgLoader;
	import com.mcard.Setting.Preset;
	import com.mcard.ViewerItemEdit;
	import com.mcard.viewerItem;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class PreviewPop extends Sprite
	{
		private var previewClip:PreviewClip = new PreviewClip();
		private var previewPopBox:Sprite = new Sprite();
		private var maskBody:Sprite = new Sprite();
		private var mainMc:viewerItem;
		private var skinIdx:Number;
		private var chk1:Boolean = false;
		private var chk2:Boolean = false;
		private var imgLoader:SingleImgLoader = new SingleImgLoader();
		private var viewerItemEdit:ViewerItemEdit = new ViewerItemEdit( false );
		
		public function PreviewPop()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			addChild( previewPopBox );
			previewPopBox.addChild( previewClip );
			previewPopBox.addChild( viewerItemEdit );
			previewPopBox.addChild( maskBody );
		}
		private function setListener():void 
		{
			previewClip.btnClose.addEventListener( MouseEvent.CLICK , closeClick );
			previewClip.btnSend.addEventListener( MouseEvent.CLICK , sendClick );
			previewClip.chkMan.addEventListener( MouseEvent.CLICK , chkManClick );
			previewClip.chkWoman.addEventListener( MouseEvent.CLICK , chkWomanClick );
			this.addEventListener( MouseEvent.MOUSE_UP , skinBodyUp );
		}
		private function setDefault():void
		{
			viewerItemEdit.x = maskBody.x = previewClip.skinBox.x;
			viewerItemEdit.y = maskBody.y = previewClip.skinBox.y;
			maskBody.graphics.beginFill( 0xff0000 );
			maskBody.graphics.drawRect( 0 , 0 , previewClip.skinBox.width , previewClip.skinBox.height );
			maskBody.graphics.endFill();
			viewerItemEdit.mask = maskBody;
			( previewClip.txtUrl as TextField ).selectable = false;
		}
		
		public function show( skinIdx:Number ):void
		{
			this.skinIdx = skinIdx;
			swfLoad();
			previewPopBox.x = 0;
			viewerItemEdit.y = previewClip.skinBox.y + previewClip.skinBox.height;
			Tweener.addTween( viewerItemEdit , { time:1 , y:previewClip.skinBox.y } );
		}
		public function showTest( skinIdx:Number , mc:viewerItem ):void
		{
			this.skinIdx = skinIdx;
			mainMc = mc;
			swfLoad();
			previewPopBox.x = 0;
			viewerItemEdit.y = previewClip.skinBox.y + previewClip.skinBox.height;
			Tweener.addTween( viewerItemEdit , { time:1 , y:previewClip.skinBox.y } );
		}
		public function hide():void
		{
			previewPopBox.x = -previewPopBox.width;
			viewerItemEdit.stageRemove();
		}
		public function previewLoad():void
		{
			previewClip.txtUrl.text = MCard.xml.member[0].@url;
			//imgLoader.loaderSetup( Preset.SITE_URL + MCard.xml.url[1].@url + "?url=" + escape( Preset.QR_API_URL + escape( MCard.xml.member[0].@qr_url ) ) , imgLoadComplete );
			imgLoader.loaderSetup( Preset.SITE_URL + MCard.xml.member[0].@qr_url , imgLoadComplete );
		}
		
		private function closeClick( e:MouseEvent ):void
		{
			hide();
		}
		private function sendClick( e:MouseEvent ):void
		{
			dispatchEvent( new Event( Preset.DISPATCH_GET_TEL ) );
		}
		public function smsSend( _vector:Vector.<String> ):void
		{
			var urlLoader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest( MCard.xml.url[0].@src );
			var variables:URLVariables = new URLVariables();
			variables.url = previewClip.txtUrl.text;
			variables.chk1 = chk1;
			variables.chk2 = chk2;
			variables.tel1 = _vector[0];
			variables.tel2 = _vector[1];
			variables.member_key = MCard.xml.member[0].@member_key;
			
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			MonsterDebugger.trace( this , request );
			urlLoader.addEventListener( Event.COMPLETE , loadComplete );
			urlLoader.load( request );
			
		}
		private function chkManClick( e:MouseEvent ):void
		{
			if( previewClip.chkMan.currentFrame == 1 )
			{
				chk1 = true;
				previewClip.chkMan.gotoAndStop(2);
			} else if ( previewClip.chkMan.currentFrame == 2 ) {
				chk1 = false;
				previewClip.chkMan.gotoAndStop(1);
			}
		}
		private function chkWomanClick( e:MouseEvent ):void
		{
			if( previewClip.chkWoman.currentFrame == 1 ) {
				chk2 = true;
				previewClip.chkWoman.gotoAndStop(2);
			} else if ( previewClip.chkWoman.currentFrame == 2 ) {
				chk2 = false;
				previewClip.chkWoman.gotoAndStop(1);
			}
		}
		
		private function swfLoad():void
		{
			var lor:Loader = new Loader();
			lor.load( new URLRequest( Preset.SITE_URL + MCard.xml.skin[skinIdx].@body ) );
			lor.contentLoaderInfo.addEventListener( Event.COMPLETE , editSwfLoadComplete );
		}
		private function editSwfLoadComplete( e:Event ):void
		{
			viewerItemEdit.stageInit( skinIdx );
			viewerItemEdit.viewerItemInit( e.currentTarget.content , skinIdx );
			viewerItemEdit.viewerItemEditSet( mainMc );
			viewerItemEdit.addEventListener( MouseEvent.MOUSE_DOWN , skinBodyDown );
			viewerItemEdit.addEventListener( MouseEvent.MOUSE_UP , skinBodyUp );
		}
		private function skinBodyDown( e:MouseEvent ):void
		{
			var rect:Rectangle = new Rectangle( previewClip.skinBox.x , previewClip.skinBox.y - ( viewerItemEdit.height - previewClip.skinBox.height ) , 0 , viewerItemEdit.height - previewClip.skinBox.height );
			viewerItemEdit.startDrag( false , rect );
		}
		private function skinBodyUp( e:MouseEvent ):void
		{
			viewerItemEdit.stopDrag();
		}
		private function loadComplete( e:Event ):void
		{
			dispatchEvent( new EventInData( Preset.COMMONPOP_SMS_SEND_OK , Preset.COMMONPOP_SHOW_DISPATCH_STR ) );
			//MonsterDebugger.trace( this , e.currentTarget.data );
			//trace( e.currentTarget.data );
		}
		private function imgLoadComplete( e:Bitmap , dummy:Object ):void
		{
			previewClip.addChild( e );
			e.x = Preset.QR_XY[0];
			e.y = Preset.QR_XY[1];
		}
	}
}