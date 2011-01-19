package com.fwang.controller
{
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextfieldEditor extends EventDispatcher
	{
		private var textfield:TextField;
		//private var textformat:TextFormat = new TextFormat();
		//private var textformatAlign:TextFormat = new TextFormat();
		
		public function TextfieldEditor( textfield:TextField )
		{
			//trace("textfieldEditor init!" );
			this.textfield = textfield;
			textfield.alwaysShowSelection = true;
		}
		
		public function setBold( _boo:Boolean = true ):void
		{
			//trace( "setBold" );
			var txtformat:TextFormat = new TextFormat();
			txtformat.bold = _boo;
			setTextFormat( txtformat );
		}
		public function setItalic( _boo:Boolean ):void
		{
			//trace("setItalic");
			var txtformat:TextFormat = new TextFormat();
			txtformat.italic = _boo;
			setTextFormat( txtformat );
		}
		public function setNormal():void
		{
			//trace("setNormal");
		}
		public function setFontColor( _color:uint ):void
		{
			//trace("setFontColor");
			var txtformat:TextFormat = new TextFormat();
			txtformat.color = _color;
			setTextFormat( txtformat );
		}
		public function setAlign( ty:String ):void
		{
			var txtformat:TextFormat = new TextFormat();
			txtformat.align = ty;
			setTextFormat( txtformat , true );
		}
		
		public function setFont( font:String ):void
		{
			//trace("set font : " , font );
			var txtformat:TextFormat = new TextFormat();
			txtformat.font = font;
			setTextFormat( txtformat );
		}
		public function setFontSize( size:Number ):void
		{
			var txtformat:TextFormat = new TextFormat();
			txtformat.size = size;
			setTextFormat( txtformat );
		}
		public function setLetterSpacing( letterSpacing:Number ):void
		{
			var txtformat:TextFormat = new TextFormat();
			txtformat.letterSpacing = letterSpacing;
			setTextFormat( txtformat );
		}
		public function getTextFormat():TextFormat
		{
			return textfield.getTextFormat();
		}
		private function setTextFormat( textformat:TextFormat , isAlign:Boolean = false ):void
		{
			if( textfield.selectionEndIndex != 0 && textfield.selectionBeginIndex < textfield.length && textfield.selectionBeginIndex != textfield.selectionEndIndex && !isAlign ) {
				if( textfield.text.charCodeAt( textfield.selectionEndIndex ) == 13 )
				{
					// 다음 문자가 엔터이면 한문자 더 적용한다.
					textfield.setTextFormat( textformat , textfield.selectionBeginIndex , textfield.selectionEndIndex + 1 );
				} else {
					textfield.setTextFormat( textformat , textfield.selectionBeginIndex , textfield.selectionEndIndex );
				}
			} else if ( textfield.selectionBeginIndex == textfield.selectionEndIndex && !isAlign ) {
				// 커서가 맨끝
				textfield.defaultTextFormat = textformat;
			} else if( isAlign ) {
				textfield.setTextFormat( textformat );
			}
		}
	}
}