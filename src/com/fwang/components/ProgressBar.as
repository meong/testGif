package com.fwang.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;

	public class ProgressBar extends Sprite
	{
		private var progressAreaClip:ProgressAreaClip = new ProgressAreaClip();
		private var maskMaxWidth:Number;
		private var progressWidthValue : Number;
		private var num:Number;
		private var isImage:Number = 0;
		public var realFileName:String = "";
		public var is_data_path:String = "";
		
		public function ProgressBar( num:Number ) 
		{	
			this.num = num;
			defaultSetting();
			addEvent();
			setLayout();
		}
		private function defaultSetting():void
		{
			// Mask position Setting
			progressAreaClip.progressBarMask1.x = progressAreaClip.progressBarMask1.y = 0;
			progressAreaClip.progressBarMask2.x = progressAreaClip.progressBarMask2.y = 0;
			progressAreaClip.progressBar.x = progressAreaClip.progressBar.y = 0;
			progressAreaClip.progressBar.mask = progressAreaClip.progressBarMask1;
			progressAreaClip.rate_txt_mc2.mask = progressAreaClip.progressBarMask2;
			maskMaxWidth = progressAreaClip.progressBarMask1.width;
			progressAreaClip.progressBarMask1.width = 0;
			progressAreaClip.during_txt.text = progressAreaClip.name_txt.text = "";
			progressAreaClip.btnDel.alpha = 0;
		}
		private function addEvent():void
		{
			// this.addEventListener( ProgressEvent.PROGRESS , onProgressing );
		}
		private function setLayout():void
		{
			addChild( progressAreaClip );
		}
		
		public function get __num():Number
		{
			return this.num;
		}
		public function set __num( num:Number ):void
		{
			this.num = num;
		}
		public function get __isImage():Number
		{
			return this.isImage;
		}
		
		public function set __isImage( isImage:Number ):void
		{
			this.isImage = isImage;
			if( isImage > 0 ) {	//	 이미지 이면 ..
				trace( "__isImage" );
				progressAreaClip.btnEditorInit.addChild( progressAreaClip.btnEditorInit.btnEditorOn );
				progressAreaClip.progressBar.addChildAt( progressAreaClip.progressBar.color1 , 1 );
				progressAreaClip.btnEditorInit.addEventListener( MouseEvent.CLICK , onEditorInit );
			} else {
				trace( "__isImage not!" );
				progressAreaClip.progressBar.addChildAt( progressAreaClip.progressBar.color2 , 1 );
				progressAreaClip.btnEditorInit.addChild( progressAreaClip.btnEditorInit.btnEditorOff );
				progressAreaClip.btnEditorInit.removeEventListener( MouseEvent.CLICK , onEditorInit );
			}
		}
		
		public function onProgressing( e:ProgressEvent ):void 
		{
			var loadedText:String = StringUtils.conv_filesize( e.bytesLoaded.toString() );
			var totalText:String = StringUtils.conv_filesize( e.bytesTotal.toString() );
			var progressWidthRate:Number = Math.round( e.bytesLoaded / e.bytesTotal * 100 );
			
			progressWidthValue = maskMaxWidth * e.bytesLoaded / e.bytesTotal;
			
			progressAreaClip.during_txt.text = loadedText + " / " + totalText;
			fileProgressing( progressWidthRate + "%" );
		}
		
		public function progressComplete( file:FileReference ):void
		{
			progressAreaClip.complete_txt.text = "완료";
			progressAreaClip.name_txt.text = file.name;
			progressAreaClip.btnDel.alpha = 1;
			progressAreaClip.btnDel.addEventListener( MouseEvent.CLICK , onDel );
			progressAreaClip.btnDel.buttonMode = true;
		}
			private function onDel( e:MouseEvent ):void
			{
				trace('onDel!');
				dispatchEvent( new EventInData( num , EventInData.onAction + "onDel" ) );
			}
		
		public function initBtnShow():void
		{
			progressAreaClip.btnEditorInit.addChild( progressAreaClip.btnEditorInit.btnEditorOn );
			progressAreaClip.btnEditorInit.btnEditorOn.buttonMode = true;
			progressAreaClip.btnEditorInit.addEventListener( MouseEvent.CLICK , onEditorInit );
		}
			private function onEditorInit( e:MouseEvent ):void
			{
				
				var file_path:String = ""
				if( is_data_path.length > 0 )
					file_path = PreSet.UPLOAD_DATA_DIR_PATH + is_data_path + "/" + realFileName;
				else
					file_path = PreSet.UPLOAD_EDITOR_DIR_PATH + realFileName
				ExternalInterface.call("editorInit" , file_path );
				trace( "realFileName  click! : " + file_path );
				dispatchEvent( new EventInData( num , EventInData.onAction + "onEditorInit" ) );
			}
			
		public function sBarSet( during_txt:String = "0/0" , fileName:String = "" , fileRealName:String = "" ):void
		{
			var tmp:Array = during_txt.split("/");
			
			progressAreaClip.during_txt.text = StringUtils.conv_filesize( tmp[0] ) + "/" + StringUtils.conv_filesize( tmp[1] );
			progressAreaClip.name_txt.text = fileName;
			progressAreaClip.complete_txt.text = "완료";
			realFileName = fileRealName;
			progressWidthValue = maskMaxWidth;
			fileProgressing( "100%" );
			progressAreaClip.btnDel.alpha = 1;
			progressAreaClip.btnDel.addEventListener( MouseEvent.CLICK , onDel );
		}
		
		public function setDel():void
		{
			progressAreaClip.during_txt.text = progressAreaClip.name_txt.text = "";
			progressAreaClip.complete_txt.text = "삭제";
			progressAreaClip.removeChild( progressAreaClip.btnDel );
		}
		private function fileProgressing( Rate:String ):void
		{
			// Progress Bar Mask Set
			progressAreaClip.progressBarMask1.width = progressWidthValue;
			progressAreaClip.progressBarMask2.width = maskMaxWidth - progressAreaClip.progressBarMask1.width ;
			progressAreaClip.progressBarMask2.x = progressAreaClip.progressBarMask1.width;
			// Rate Text Set
			progressAreaClip.progressBar.rate_txt_mc1.rate_txt.text = progressAreaClip.rate_txt_mc2.rate_txt.text = Rate;
		}
		
		
	}
}