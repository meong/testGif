package com.mcard.manager
{
	public class MemberManager
	{
		static public var txt:String;
		static public var manTel1:String;
		static public var manTel2:String;
		static public var manTel3:String;
		static public var girlTel1:String;
		static public var girlTel2:String;
		static public var girlTel3:String;
		static public var qrUrl:String;
		
		static public var isFirst:Number;
		static public var skinIndex:Number;
		static public var titleIndex:Number;
		static public var titleX:Number;
		static public var titleY:Number;
		static public var titleAlpha:Number;
		static public var titleColor:Number;
		static public var manIndex:Number;
		static public var manX:Number;
		static public var manY:Number;
		static public var girlIndex:Number;
		static public var girlX:Number;
		static public var girlY:Number;
		static public var textfieldX:Number;
		static public var textfieldY:Number;
		static public var textfieldWidth:Number;
		static public var textfieldHeight:Number;
		static public var textfieldText:String;
		static public var textfieldBgColor:Number;
		static public var textfieldBgAlpha:Number;
		
		public function MemberManager()
		{
		}
		
		public function setTxt( str:String ):void
		{
			txt = str.replace( /\r\n/g, "\n" );
		}
		public function setManTel1( str:String ):void
		{
			manTel1 = str;
		}
		public function setManTel2( str:String ):void
		{
			manTel2 = str;
		}
		public function setManTel3( str:String ):void
		{
			manTel3 = str;
		}
		public function setGirlTel1( str:String ):void
		{
			girlTel1 = str;
		}
		public function setGirlTel2( str:String ):void
		{
			girlTel2 = str;
		}
		public function setGirlTel3( str:String ):void
		{
			girlTel3 = str;
		}
		public function setQrUrl( str:String ):void
		{
			qrUrl = str;
		}
		
		public function setSkinIndex( numb:Number ):void
		{
			skinIndex = numb;
		}
		public function setIsFirst( numb:Number ):void
		{
			isFirst = numb;
		}
		public function setTitleIndex( numb:Number ):void
		{
			titleIndex = numb;
		}
		public function setTitleX( numb:Number ):void
		{
			titleX = numb;
		}
		public function setTitleY( numb:Number ):void
		{
			titleY = numb;
		}
		public function setTitleAlpha( numb:Number ):void
		{
			titleAlpha = numb;
		}
		public function setTitleColor( numb:Number ):void
		{
			titleColor = numb;
		}
		public function setManIndex( numb:Number ):void
		{
			manIndex = numb;
		}
		public function setManX( numb:Number ):void
		{
			manX = numb;
		}
		public function setManY( numb:Number ):void
		{
			manY = numb;
		}
		public function setGirlIndex( numb:Number ):void
		{
			girlIndex = numb;
		}
		public function setGirlX( numb:Number ):void
		{
			girlX = numb;
		}
		public function setGirlY( numb:Number ):void
		{
			girlY = numb;
		}
		public function setTextfieldX( numb:Number ):void
		{
			textfieldX = numb;
		}
		public function setTextfieldY( numb:Number ):void
		{
			textfieldY = numb;
		}
		public function setTextfieldWidth( numb:Number ):void
		{
			textfieldWidth = numb;
		}
		public function setTextfieldHeight( numb:Number ):void
		{
			textfieldHeight = numb;
		}
		public function setTextfieldText( str:String ):void
		{
			textfieldText = str;
		}
		public function setTextfieldBgColor( numb:Number ):void
		{
			textfieldBgColor = numb;
		}
		public function setTextfieldBgAlpha( numb:Number ):void
		{
			textfieldBgAlpha = numb;
		}
		
	}
}