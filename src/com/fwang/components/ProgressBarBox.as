package com.fwang.components
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ProgressBarBox extends Sprite
	{
		private var sBarLineClip:SBarLineClip = new SBarLineClip();
		private var pBox:MovieClip = new MovieClip();
		private var progressBar:ProgressBar;
		private var pendingFiles:Array = new Array();
		private var pendingFileClips:Array = new Array();
		private var fileBrowser:FileReferenceList = new FileReferenceList();
		private var file:FileReference = new FileReference();
		private var uploadUrl:String;
		private var sBarController:ScrollBarController;
		private var sBarClip:ScrollBtnClip = new ScrollBtnClip();
		
		// delete items
		private var isCanDel:Number = -1;
		private var delLoader:URLLoader = new URLLoader();
		public var delCnt:Number = 0;
		
		private var board_table:String;
		private var write_id:String;
		private var bf_id:String;
		private var maxCnt:Number;
		/*
		// update init
		private var write_id:String;
		private var xmlLoader:XMLLoader = new XMLLoader();
		*/
		public var xml:XML;
		
		
		public function ProgressBarBox()
		{
			super();
			defaultSet();
			setListener(); 
			setView();
		}
		public function defaultSet():void
		{
			sBarClip.x = PreSet.SBAR_XY[0];
			sBarClip.y = PreSet.SBAR_XY[1];
			sBarController = new ScrollBarController( pBox , sBarClip , PreSet.SBODY_HEIGHT , PreSet.SBAR_HEIGHT );
		}
		private function setListener():void
		{
			sBarClip.addEventListener( MouseEvent.MOUSE_OVER , btnOver );
			sBarClip.addEventListener( MouseEvent.MOUSE_OUT , btnOut );
			//xmlLoader.addEventListener( XMLLoaderEvent.XML_COMPLETE , xmlComplete );
		}

		private function setView():void
		{
			addChild( sBarLineClip );
				sBarLineClip.x = PreSet.SBAR_LINE_XY[0];			sBarLineClip.y = PreSet.SBAR_LINE_XY[1];
			addChild( pBox );
			addChild( sBarClip );
			addChild( sBarController );
		}
			private function btnOver( e:MouseEvent ):void
			{
				e.currentTarget.addChild( e.currentTarget.btnOn );
			}
			private function btnOut( e:MouseEvent ):void
			{
				e.currentTarget.addChild( e.currentTarget.btnOff );
			}
			/*
			private function xmlComplete( e:XMLLoaderEvent ):void
			{
				this.xml = e.xml;
				trace( "xml.length() : " + xml.item.length() );
			}
			*/
		
		public function get __board_table():String
		{
			return board_table;
		}
		public function set __board_table( board_table:String ):void
		{
			this.board_table = board_table;
		}
		public function get __write_id():String
		{
			return write_id;
		}
		public function set __write_id( write_id:String ):void
		{
			this.write_id = write_id;
		}
		public function get __bf_id():String
		{
			return bf_id;
		}
		public function set __bf_id( bf_id:String ):void
		{
			this.bf_id = bf_id;
		}
		public function get __maxCnt():Number
		{
			return maxCnt;
		}
		public function set __maxCnt( maxCnt:Number ):void
		{
			this.maxCnt = maxCnt;
		}
		
		public function pAdd( num:Number , fileBrowser:FileReference = null ):void
		{
			trace('pAdd : ' + num );
			progressBar = new ProgressBar( num );
			progressBar.x = PreSet.PBOX_PADDING;
			progressBar.y = ( progressBar.height + PreSet.PBOX_PADDING ) * pBox.numChildren + PreSet.PBOX_PADDING ;
			pBox.addChild( progressBar );
			sBarController.maskWidth = pBox.width;
			pendingFileClips.push( progressBar );
			// upload workspace
			if( fileBrowser ) {
				file = FileReference( fileBrowser );
				pendingFiles.push( file );
				addPendingFile( file , progressBar );
			} else {
				//trace( xml );
				//trace( num );
				progressBar.sBarSet( xml.item[num].@during_txt , xml.item[num].@filename );
				progressBar.realFileName = xml.item[num].@realFileName;
				progressBar.__isImage = xml.item[num].@imgType;
				pendingFiles.push( null );
				pendingFileClips[num].realFileName = xml.item[num].@realFileName;
				progressBar.is_data_path = board_table;
			}
			progressBar.addEventListener( EventInData.onAction + "onDel" , pBarDelFront );
			progressBar.addEventListener( EventInData.onAction + "onEditorInit" , pBarInit );
			
			// progress bar reset
			sBarController.reset( true );
		}
		public function get __pendingFiles():Array
		{
			return pendingFiles;
		}
		private function addPendingFile( file:FileReference , barClip:ProgressBar ):void
		{
			trace( "addPendingFile init!" );
			file.addEventListener(Event.OPEN, openHandler);
	        file.addEventListener(Event.COMPLETE, completeHandler);
	        file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        file.addEventListener(ProgressEvent.PROGRESS, barClip.onProgressing );
	        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	        file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA , uploadCompleteDataHandler);
	        file.upload( new URLRequest( PreSet.UPLOAD_URL + "?board_table=" + board_table + "&bf_no=" + pendingFiles.length + "&bf_id=" + bf_id ) );
		}
			private function pBarDelFront( e:EventInData ):void
			{
				delCnt++;
				if( write_id ) 		pBarDelU( e );
				else				pBarDel( e );
			}
				private function pBarDelU( e:EventInData ):void
				{
					if( isCanDel == -1 ) {
						isCanDel = e.data as Number;
						delLoader.load( new URLRequest( PreSet.DELETE_URL + "?board_table=" + board_table + "&write_id=" + write_id + "&bf_no=" + isCanDel + "&w=u" + "&bf_id=" + bf_id ) );
						delLoader.addEventListener( Event.COMPLETE , delLoaderCompleteU );
					}
				}
					private function delLoaderCompleteU( e:Event ):void
					{
						//trace( e );
						//trace('delLoaderComplete init!');
						pendingFileClips[isCanDel].setDel();
						isCanDel = -1;
						//Tweener.addTween( pendingFileClips[isCanDel] , {time:0.5 , alpha:0 , transition:"linear" , onComplete:sBarDel } );
					}
				private function pBarDel( e:EventInData ):void
				{
					//trace('pBarDel click i : ' + e.data );
					if( isCanDel == -1 ) {
						isCanDel = e.data as Number;
						delLoader.load( new URLRequest( PreSet.DELETE_URL + "?board_table=" + board_table + "&bf_no=" + isCanDel + "&bf_id=" + bf_id ) );
						delLoader.addEventListener( Event.COMPLETE , delLoaderComplete );
					}
				}
					private function delLoaderComplete( e:Event ):void
					{
						//trace( e );
						//trace('delLoaderComplete init!');
						//var loader:URLLoader = e.target as URLLoader;
						Tweener.addTween( pendingFileClips[isCanDel] , {time:0.5 , alpha:0 , transition:"linear" , onComplete:sBarDel } );
					}
						private function sBarDel():void
						{
							trace("sbar del");
							var ii:Number = isCanDel + 1;
							var jj:Number;
							for( ii ; ii < pBox.numChildren ; ii++ ) {
								pendingFileClips[ii].__num = ii - 1;
								Tweener.addTween( pendingFileClips[ii] , {time:0.2 , y:pendingFileClips[ii].y - ( pendingFileClips[ii].height + PreSet.PBOX_PADDING ) , transition:"linear" , onComplete:sBarReset } );
							}
							pBox.removeChild( pendingFileClips[isCanDel] );
							//progressbar reset
							if( ii == isCanDel + 1 )				sBarController.reset( true );
							// pendingArray delete 
							pendingFileClips.splice( isCanDel , 1 );
							pendingFiles.splice( isCanDel , 1 );
							isCanDel = -1;
						}
							private function sBarReset():void
							{
								//progressbar reset
								trace('sbar reset!!!!!');
								sBarController.reset( true );	
							}

			private function pBarInit( e:EventInData ):void
			{
				trace('pBarInit click i : ' + e.data );
			}
			private function openHandler(event:Event):void {
				var file:FileReference = FileReference(event.target);
		        trace("openHandler: name=" + file.name);
		        var isImage:Number = ImageUtils.isImage( file.name );
		        trace( "isImage : " + isImage );
		        for( var i:uint ; i < pendingFiles.length ; i++ ) {
		    		if( pendingFiles[i] && ( pendingFiles[i].name == file.name ) ) {
		    			pendingFileClips[i].__isImage = isImage;
		    			trace( "initBtnShow() init!" );
		    		}
		    	}
				dispatchEvent( new Event( "file_selected" ) );		        
		    }
		 
		    private function completeHandler(event:Event):void {
		    	//var aFile:FileReference = event.currentTarget as FileReference;
		    	var file:FileReference = FileReference(event.target);
		    	for( var i:uint ; i < pendingFiles.length ; i++ ) {
		    		if( pendingFiles[i] && ( pendingFiles[i].name == file.name ) ) {
		    			pendingFileClips[i].progressComplete( file );
		    		}
		    	}
		        trace("completeHandler: name=" + file.name);
		    }
		    private function uploadCompleteDataHandler(event:DataEvent):void {
		    	var tmp:Array = event.data.split( "|" );
		    	var file:FileReference = FileReference(event.target);
		    	for( var i:uint ; i < pendingFiles.length ; i++ ) {
		    		if( pendingFiles[i] && ( pendingFiles[i].name == file.name ) ) {
		    			pendingFileClips[i].__isImage = ImageUtils.getCanHTMLImage( tmp[0] );
		    			pendingFileClips[i].realFileName = tmp[1];
		    		}
		    	}
		    	
    	        trace("uploadCompleteData: " + event);
    	        
	        }

		    private function ioErrorHandler(event:Event):void {
		        var file:FileReference = FileReference(event.target);
		        //trace("ioErrorHandler: name=" + file.name);
		    }
		 
		    private function securityErrorHandler(event:Event):void {
		        var file:FileReference = FileReference(event.target);
		        //trace("securityErrorHandler: name=" + file.name + " event=" + event.toString());
		    }
	}
}