package com.fwang.utils
{
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		public static function floor(val:Number , position:Number ):Number
		{
			var i:Number = 0;
			for( i = 0 ; i < position ; i++ ) {
				val = val * 10 ;
			}
			val = Math.floor( val );
			for( i = 0 ; i < position ; i++ ) {
				val = val / 10;
			}
			return val;
		}
		
		public static function ceil( val:Number , position:Number ):Number
		{
			var i :Number = 0;
			for( i = 0 ; i <position ; i++ ) {
				val = val * 10;
			}
			val = Math.ceil( val );
			for( i = 0 ; i < position ; i++ ) {
				val = val / 10;
			}
			return val;
		}
		
		public static function round( val:Number , position:Number ):Number
		{
			var i :Number = 0;
			for( i = 0 ; i <position ; i++ ) {
				val = val * 10;
			}
			val = Math.round( val );
			for( i = 0 ; i < position ; i++ ) {
				val = val / 10;
			}
			return val;
		}
		
		public static function random( min:Number , max:Number ):Number
		{
			var rand:Number = Math.random();
			return rand * ( max - min ) + min ;
		}
	}
}