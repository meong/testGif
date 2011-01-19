package com.fwang.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DisplayObjectUtils
	{
		public function DisplayObjectUtils()
		{
			
		}
		public static function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject ):Bitmap
		{
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( displayObject , new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
		public static function removeChilds( dp:Sprite , idx:Number = 0 ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < dp.numChildren - idx ; ii++ )
			{
				dp.removeChildAt( idx );				
			}
			return void;
		}
		
		// effect filter
		private static function applyFilter(child:DisplayObject, matrix:Array):void {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(filter);
			child.filters = filters;
		}
		
		public static function duplicate(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
			// create duplicated object
			var targetClass:Class = Object(target).constructor;
			var duplicated:DisplayObject = new targetClass();
			// duplicate properties
			duplicated.transform = target.transform;
			duplicated.filters = target.filters;
			duplicated.cacheAsBitmap = target.cacheAsBitmap;
			duplicated.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicated.scale9Grid = rect;
			}
			
			// add to target parent's display list if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicated);
			}
			
			return duplicated;
		}
	}
}