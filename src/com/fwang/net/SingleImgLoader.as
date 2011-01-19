package com.fwang.net
{
    /**
    * ...
    * @author 송영득
    * @설명 : 싱글 이미지 로더 클래스
    */
    import flash.display.Loader;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;

    public class  SingleImgLoader {
            /************************************************************************
            * 1.변수 설명
            * 2. @ _Fun : 로드 완료후 호출 하는 함수
            * @ _loader : Loader 클래스 인스턴스명
            * @ _request : URLRequest 클래스 인스턴스명
            * ***********************************************************************/
			private var _url:String;
            private var _Fun:Function;
			private var _Param:Object;
            private var _loader:Loader;
            private var _request:URLRequest;
			private var loaderContext:LoaderContext = new LoaderContext();
			
            /************************************************************************
            * 1. 메소드명 : loaderSetup
            * 2. 메소드기능 : 이미지 or swf 파일을 로드 하는 기능의 클래스
            * 3. 파라미터 :
            * @url :  해당 객체의 url 주소값
            * @Fun :  이미지 로딩 완료후 실행 되는 Function
            * 4. 리턴값 :  void
            * 5. 참고사항 :
            * ***********************************************************************/
            public  function loaderSetup(url:String, Fun:Function , param:Object = null ):void {
					_url = url
                    _Fun = Fun;
					_Param = param;
                    _loader = new Loader();
                    init(_loader.contentLoaderInfo);
                    _request = new URLRequest(url);
					loaderContext.checkPolicyFile = true;
                    _loader.load( _request , loaderContext );

            }
            private function init(dispatcher:IEventDispatcher):void {
                    dispatcher.addEventListener(Event.COMPLETE, completeHandler);
                    dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					dispatcher.addEventListener( ErrorEvent.ERROR , onError );
					dispatcher.addEventListener( IOErrorEvent.IO_ERROR , onIOError );
            }
            private  function completeHandler(evt:Event):void {
                    //trace(evt.target.content)
					_Fun(evt.target.content , _Param );
            }
            protected function progressHandler(event:ProgressEvent):void {
                    // trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
            }
			private function onError( e:ErrorEvent ):void
			{
				trace( "error:" + ( e as ErrorEvent ).toString() );
			}
			private function onIOError( e:IOErrorEvent ):void
			{
				trace( "io error:" + ( e as IOErrorEvent ).toString() + "url : " + _url );
			}
    }
}