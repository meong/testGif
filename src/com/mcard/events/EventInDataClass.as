package com.mcard.events
{
	import flash.display.Bitmap;

	public class EventInDataClass
	{
		private var _bitmap:Bitmap;
		private var _origBitmap:Bitmap;
		private var _numb:Number;
		private var _swapBeginIndex:Number;
		private var _swapEndIndex:Number;
		private var _isFirst:Boolean;
		
		// effect
		private var _rotate:Number;
		private var _positionX:Number;
		private var _positionY:Number;
		private var _effectSepia:Boolean;
		private var _effectGray:Boolean;
		private var _effectOld:Boolean;
		private var _effectLuxury:Boolean;
		private var _effectLomo:Number;
		private var _effectBrightness:Number;
		private var _effectContrast:Number;
		
		private var _isFinal:Boolean = false;
		
		public function EventInDataClass( numb:Number , bitmap:Bitmap = null , origBitmap:Bitmap = null , isFirst:Boolean = true )
		{
			_bitmap = bitmap;
			_origBitmap = origBitmap;
			_numb = numb;
			_isFirst = isFirst;
			//trace( "eventindataClass w h : " , _bitmap.width , _bitmap.height );
		}
		public function get bitmap():Bitmap
		{
			//trace( "bitmap Getter : " , _bitmap.width , _bitmap.height );
			return _bitmap;
		}
		public function get origBitmap():Bitmap
		{
			//trace( "bitmap Getter : " , _bitmap.width , _bitmap.height );
			return _origBitmap;
		}
		
		public function get numb():Number
		{
			return _numb;
		}
		public function get swapBeginIndex():Number
		{
			return _swapBeginIndex;
		}
		public function set swapBeginIndex( _swapBeginIndex:Number ):void
		{
			this._swapBeginIndex = _swapBeginIndex;
		}
		public function get swapEndIndex():Number
		{
			return _swapEndIndex;
		}
		public function set swapEndIndex( _swapEndIndex:Number ):void
		{
			this._swapEndIndex = _swapEndIndex;
		}
		
		public function get isFirst():Boolean
		{
			return _isFirst;
		}
		
		public function set rotate( numb:Number ):void
		{
			this._rotate = numb;
		}
		public function get rotate():Number
		{
			return _rotate;
		}
		
		public function set positionX( numb:Number ):void
		{
			this._positionX = numb;
		}
		public function get positionX():Number
		{
			return _positionX;
		}
		
		public function set positionY( numb:Number ):void
		{
			this._positionY = numb;
		}
		public function get positionY():Number
		{
			return _positionY;
		}
		
		public function set effectSepia( boo:Boolean ):void
		{
			this._effectSepia = boo;
		}
		public function get effectSepia():Boolean
		{
			return _effectSepia;
		}
		
		public function set effectGray( boo:Boolean ):void
		{
			this._effectGray= boo;
		}
		public function get effectGray():Boolean
		{
			return _effectGray;
		}
		
		public function set effectOld( boo:Boolean ):void
		{
			this._effectOld = boo;
		}
		public function get effectOld():Boolean
		{
			return _effectOld;
		}
		
		public function set effectLuxury( boo:Boolean ):void
		{
			this._effectLuxury = boo;
		}
		public function get effectLuxury():Boolean
		{
			return _effectLuxury;
		}
		
		public function set effectLomo( numb:Number ):void
		{
			this._effectLomo = numb;
		}
		public function get effectLomo():Number
		{
			return _effectLomo;
		}
		
		public function set effectBrightness( numb:Number ):void
		{
			this._effectBrightness = numb;
		}
		public function get effectBrightness():Number
		{
			return _effectBrightness;
		}
		
		public function set effectContrast( numb:Number ):void
		{
			this._effectContrast= numb;
		}
		public function get effectContrast():Number
		{
			return _effectContrast;
		}
		
		public function set isFinal( _isFinal:Boolean ):void
		{
			this._isFinal = _isFinal;
		}
		public function get isFinal():Boolean
		{
			return _isFinal;
		}
	}
}