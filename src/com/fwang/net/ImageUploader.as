package com.fwang.net
{
	import com.fwang.events.EventInData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class ImageUploader extends EventDispatcher
	{
		public static const DISPATCHER_STR:String = "IMAGE_UPLOADER_DISPATCH";
		
		public function ImageUploader()
		{
			super();
		}
		
		/**
		 * isTest 가 true 이면 테스트 모드로 , 원격으로 REQUEST 안하고 로컬로 다운 받는다.
		 * */
		public function sendImage( url:String , fileName:String , byteArray:ByteArray , parameters:Object = null , isTest:Boolean = false ):void {
			if( !isTest ) {
				//for( var ii:Number = 0 ; ii < byteArray.length ; ii++ )
				//{
					//parameters.image_id = ii;
					var ur:URLRequest = new URLRequest();
					var ul:URLLoader = new URLLoader();
					ur.url = url;
					ur.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
					ur.method = URLRequestMethod.POST; 
					
					ur.data = UploadPostHelper.getPostData( fileName , byteArray , parameters );
					ur.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
					
					ul.dataFormat = URLLoaderDataFormat.BINARY;
					ul.addEventListener( Event.COMPLETE , uploadJPGEventListener );
					ul.load(ur);
					MonsterDebugger.trace( this , parameters );
				//}	
			} else {
				new FileReference().save( byteArray , fileName );
				dispatchEvent( new Event( DISPATCHER_STR ) );
			}
				
		}
		 
		private function uploadJPGEventListener( e:Event ):void
		{
			//trace( "uploadJPGEventListener : " , e.target.data );
			dispatchEvent( new EventInData( e.target.data , EventInData.onAction ) );
		}
	}
}