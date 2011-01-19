package com.mcard.manager
{
	import flash.display.Sprite;
	
	public class SkinManager extends Sprite
	{
		static public var skinBody:Vector.<Sprite> = new Vector.<Sprite>;
		/*
		static public var main:Vector.<Number> = new Vector.<Number>;
		static public var sub1:Vector.<Number> = new Vector.<Number>;
		static public var sub2:Vector.<Number> = new Vector.<Number>;
		static public var sub3:Vector.<Number> = new Vector.<Number>;
		static public var sub4:Vector.<Number> = new Vector.<Number>;
		*/
		
		public function SkinManager()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			
		}
		private function setListener():void
		{
		}
		private function setDefault():void
		{
		}
		public function getSkin( i:Number ):Sprite
		{
			//trace( 'getImg init ');
			return skinBody[i];
		}
		public function setSkin( i:Number , b:Sprite ):void
		{
			//trace( 'setImg init ');
			skinBody[i] = b;
		}
		/*
		public function getSkinBm( i:Number ):Bitmap
		{
			//trace( 'getImg init ');
			return skinBodyBm[i];
		}
		public function setSkinBm( i:Number , b:Bitmap ):void
		{
			//trace( 'setImg init ');
			skinBodyBm[i] = b;
		}
		public function getSkinBm2( i:Number ):Bitmap
		{
			//trace( 'getImg init ');
			return skinBodyBm2[i];
		}
		public function setSkinBm2( i:Number , b:Bitmap ):void
		{
			//trace( 'setImg init ');
			skinBodyBm2[i] = b;
		}
		*/
		public function set length( i:Number ):void
		{
			skinBody.length = i;
			//skinBodyBm.length = i;
			//skinBodyBm2.length = i;
		}
		public function get length():Number
		{
			return skinBody.length;
		}
	}
}