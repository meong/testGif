package com.mcard
{
	import com.aitmedia.utils.DisplayObjectContainerUtil;
	import com.fwang.net.SingleImgLoader;
	import com.fwang.utils.DisplayObjectUtils;
	import com.fwang.utils.ImageUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageGirlManager;
	import com.mcard.manager.ImageManManager;
	import com.mcard.manager.ImageManager;
	import com.mcard.manager.ImageTitleManager;
	import com.mcard.manager.MemberManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class viewerItem extends MovieClip
	{
		public var mcMask:MovieClip = new MovieClip();
		public var mainClip:ViewerItemMc;
		public var sub1Clip:ViewerItemMc;
		public var sub2Clip:ViewerItemMc;
		public var sub3Clip:ViewerItemMc;
		public var sub4Clip:ViewerItemMc;
		public var manItem:MovieClip = new MovieClip();
		public var girlItem:MovieClip = new MovieClip();
		public var isDrag:Boolean = false;
		
		private var numb:Number;
		private var mc:MovieClip;
		private var isEdit:Boolean;
		private var isViewer:Boolean;
		private var isFirst:Boolean;
		private var bmTitle:Bitmap;
		private var bmMan:Bitmap;
		private var bmGirl:Bitmap;
		private var txtfd:TextField = new TextField();
		private var txtfdStyleArr:Vector.<TextFormat> = new Vector.<TextFormat>();
		private var txtfdStyle:TextFormat = new TextFormat();
		private var txtfdBg:Sprite = new Sprite();
		
		private var imgLoader1:SingleImgLoader = new SingleImgLoader();
		private var imgLoader2:SingleImgLoader = new SingleImgLoader();
		private var imgLoader3:SingleImgLoader = new SingleImgLoader();
		
		private var bMain:Bitmap;// = ImageUtils.duplicateImage( ImageManager.imgArr[0] );
		private var bSub1:Bitmap;// = ImageUtils.duplicateImage( ImageManager.imgArr[1] );
		private var bSub2:Bitmap;// = ImageUtils.duplicateImage( ImageManager.imgArr[2] );
		private var bSub3:Bitmap;// = ImageUtils.duplicateImage( ImageManager.imgArr[3] );
		private var bSub4:Bitmap;// = ImageUtils.duplicateImage( ImageManager.imgArr[4] );
		
		private var itemCnt:Number = 5;
		private var titleItem:MovieClip = new MovieClip();
		private var titleItemColorMc:MovieClip = new MovieClip();
		private var titleItemNumb:Number;
		private var titleItemAlpha:Number = 1;
		private var titleItemColor:Number = NaN;
		private var manItemNumb:Number;
		private var girlItemNumb:Number;
		private var txtfdBgColor:Number;
		private var txtfdBgAlpha:Number;
		private var titleXY:Vector.<Number> = new Vector.<Number>;
		private var manXY:Vector.<Number> = new Vector.<Number>;
		private var girlXY:Vector.<Number> = new Vector.<Number>;
		private var txtfdBgAC:Vector.<Number> = new Vector.<Number>;
		private var skinLength:Number;
		
		public function viewerItem( isEdit:Boolean = false , isViewer:Boolean = false )
		{
			this.isEdit = isEdit;
			this.isViewer = isViewer;
			super();
			/*
			this.numb = numb;
			this.mc = mc;
			
			setDefault();
			setView();
			setListener();
			*/
		}
		public function viewerItemInit( numb:Number , mc:MovieClip ):void
		{
			this.numb = numb;
			this.mc = mc;
			
			if( !isFirst )
			{
				isFirst = true;
				if( MemberManager.isFirst != 1 && isEdit )
				{
					this.titleItemNumb = MemberManager.titleIndex;
					this.manItemNumb = MemberManager.manIndex;
					this.girlItemNumb = MemberManager.girlIndex;
					titleXY[0] = MemberManager.titleX;
					titleXY[1] = MemberManager.titleY;
					manXY[0] = MemberManager.manX;
					manXY[1] = MemberManager.manY;
					girlXY[0] = MemberManager.girlX;
					girlXY[1] = MemberManager.girlY;
					txtfdBgAC[0] = MemberManager.textfieldBgAlpha;
					txtfdBgAC[1] = MemberManager.textfieldBgColor;
				} else {
					this.titleItemNumb = MCard.xml.skin[numb].skinTitle.@index;
					this.manItemNumb = MCard.xml.skin[numb].skinMan.@index;
					this.girlItemNumb = MCard.xml.skin[numb].skinGirl.@index;
				}
			} else {
				this.titleItemNumb = MCard.xml.skin[numb].skinTitle.@index;
				this.manItemNumb = MCard.xml.skin[numb].skinMan.@index;
				this.girlItemNumb = MCard.xml.skin[numb].skinGirl.@index;
			}
			
			setDefault();
			setView();
			setListener();
			
			dispatchEvent( new Event( "itemInit" ) );
			dispatchEvent( new Event( Preset.DISPATCH_STAGEINIT_COMPLETE ) );
			//dispatchEvent( new EventInData( numb , "viewerItemInitComplete" ) );
		}
		private function setDefault():void
		{
			bMain = bSub1 = bSub2 = bSub3 = bSub4 = null;
			mainClip = sub1Clip = sub2Clip = sub3Clip = sub4Clip = null;
			if( ImageManager.imgArr[0] )
			{
				bMain = ImageUtils.duplicateImage( ImageManager.imgArr[0] );
				bMain.smoothing = true;
			}
			if( ImageManager.imgArr[1] )
			{
				bSub1 = ImageUtils.duplicateImage( ImageManager.imgArr[1] );
				bSub1.smoothing = true;
			}
			if( ImageManager.imgArr[2] )
			{
				bSub2 = ImageUtils.duplicateImage( ImageManager.imgArr[2] );
				bSub2.smoothing = true;
			}
			if( ImageManager.imgArr[3] )
			{
				bSub3 = ImageUtils.duplicateImage( ImageManager.imgArr[3] );
				bSub3.smoothing = true;
			}
			if( ImageManager.imgArr[4] )
			{
				bSub4 = ImageUtils.duplicateImage( ImageManager.imgArr[4] );
				bSub4.smoothing = true;
			}
			mainClip = new ViewerItemMc( mc.mainBox , bMain );
			sub1Clip = new ViewerItemMc( mc.subBox1 , bSub1 );
			sub2Clip = new ViewerItemMc( mc.subBox2 , bSub2 ); 
			sub3Clip = new ViewerItemMc( mc.subBox3 , bSub3 );
			sub4Clip = new ViewerItemMc( mc.subBox4 , bSub4 );
			mainClip.name = "mainClip";
			sub1Clip.name = "sub1Clip";
			sub2Clip.name = "sub2Clip";
			sub3Clip.name = "sub3Clip";
			sub4Clip.name = "sub4Clip";
			
			mcMask.graphics.beginFill( 0x000000 );
			mcMask.graphics.drawRect( 0 , 0 , Preset.SKIN_WH[0] , Preset.SKIN_WH[1] );
			mcMask.graphics.endFill();
			this.mask = mcMask;
			
			var titleMc:MovieClip;
			var manMc:MovieClip;
			var girlMc:MovieClip;
			skinLength = numb;
			if( isEdit )
			{
				if( isViewer ){
					skinLength = MCard.xml.skin.length()+2;
				} else {
					skinLength = MCard.xml.skin.length()+3;
				}
			}
			
			titleMc = ImageTitleManager.titleImgArr[MCard.xml.skin[numb].skinTitle.@index][skinLength];
			manMc = ImageManManager.manImgArr[MCard.xml.skin[numb].skinTitle.@index][skinLength];
			girlMc = ImageGirlManager.girlImgArr[MCard.xml.skin[numb].skinTitle.@index][skinLength];
			
			titleItem.addChild( titleMc );
			titleItem.name = Preset.VIEWERITEM_TITLE_NAME;
			manItem.addChild( manMc );
			manItem.name = Preset.VIEWERITEM_MAN_NAME;
			girlItem.addChild( girlMc );
			girlItem.name = Preset.VIEWERITEM_GIRL_NAME;
			
			if( titleXY.length )
			{
				titleItem.x = titleXY[0];
				titleItem.y = titleXY[1];
				titleXY.length = 0;
			} else {
				titleItem.x = MCard.xml.skin[numb].skinTitle.@x;
				titleItem.y = MCard.xml.skin[numb].skinTitle.@y;
			}
			if( manXY.length )
			{
				manItem.x = manXY[0];
				manItem.y = manXY[1];
				manXY.length = 0;
			} else {
				manItem.x = MCard.xml.skin[numb].skinMan.@x;
				manItem.y = MCard.xml.skin[numb].skinMan.@y;
			}
			if( girlXY.length )
			{
				girlItem.x = girlXY[0];
				girlItem.y = girlXY[1];
				girlXY.length = 0;
			} else {
				girlItem.x = MCard.xml.skin[numb].skinGirl.@x
				girlItem.y = MCard.xml.skin[numb].skinGirl.@y;
			}
			// textfield
			txtfd.x = txtfdBg.x = MCard.xml.skin[numb].skinTxt.@x;
			txtfd.y = txtfdBg.y = MCard.xml.skin[numb].skinTxt.@y;
			txtfd.width = MCard.xml.skin[numb].skinTxt.@width;
			txtfd.height = MCard.xml.skin[numb].skinTxt.@height;
			txtfd.name = Preset.VIEWERITEM_TEXTFIELD_NAME;
			txtfd.condenseWhite = true;
			txtfd.multiline = true;
			txtfd.mouseEnabled = false;
			txtfdBg.name = Preset.VIEWERITEM_TEXTFIELD_BG_NAME;
			
			txtfdStyle.align = MCard.xml.skin[numb].skinTxt.@align;
			
			var boldBoo:Number = 0;
			if( MCard.xml.skin[numb].skinTxt.@bold != "0" ) {
				boldBoo = 1;
			}
			txtfdStyle.bold = boldBoo;
			var italicBoo:Number = 0;
			if( MCard.xml.skin[numb].skinTxt.@italic != "0" ) {
				italicBoo = 1;
			}
			txtfdStyle.italic = italicBoo;
			txtfdStyle.color = MCard.xml.skin[numb].skinTxt.@color;
			txtfdStyle.size = MCard.xml.skin[numb].skinTxt.@size;
			txtfdStyle.font = MCard.xml.skin[numb].skinTxt.@style;
			txtfdStyle.letterSpacing = MCard.xml.skin[numb].skinTxt.@letterspacing;
			//txtfdStyleArr[0] = txtfdStyle;
			
			if( txtfdBgAC.length )
			{
				txtfdBgAC.length = 0;
				textfieldSetFirst();
			} else {
				textfieldSet( ( MCard.xml.member as XMLList ).toString() , MCard.xml.skin[numb].skinTxt.@bg , MCard.xml.skin[numb].skinTxt.@bgAlpha , txtfdStyle );
			}
		}
		private function setView():void
		{
			addChild( mc.bgTemp );
			DisplayObjectContainerUtil.addChilds( this , [ sub1Clip , sub2Clip , sub3Clip , sub4Clip , mainClip ] );
			if( mc.bgBody.numChildren > 0 )
			{
				addChild( mc.bgBody.getChildAt(0) );
			}
			addChild( mcMask );
			addChild( titleItem );
			addChild( manItem );
			addChild( girlItem );
			addChild( txtfdBg );
			addChild( txtfd );
		}
		
		private function setListener():void
		{
			titleItem.addEventListener( MouseEvent.MOUSE_DOWN , titleItemDown );
			manItem.addEventListener( MouseEvent.MOUSE_DOWN , manItemDown );
			girlItem.addEventListener( MouseEvent.MOUSE_DOWN , girlItemDown );
			titleItem.addEventListener( MouseEvent.MOUSE_UP , titleItemUp );
			manItem.addEventListener( MouseEvent.MOUSE_UP , manItemUp );
			girlItem.addEventListener( MouseEvent.MOUSE_UP , girlItemUp );
		}
		public function stageRemove():void
		{
			var numCnt:Number = this.numChildren;
			//trace(" numCnt:::::::::::::" + numCnt );
			for( var ii:Number = 0 ; ii < numCnt ; ii++ )
			{
				this.removeChildAt( 0 );
			}
			if( titleItem.numChildren )
			{
				titleItem.removeChildAt( 0 );
			}
			if( manItem.numChildren )
			{
				manItem.removeChildAt( 0 );
			}
			if( girlItem.numChildren )
			{
				girlItem.removeChildAt( 0 );
			}
			
			/*
			bMain = null;
			bSub1 = null;
			bSub2 = null;
			bSub3 = null;
			bSub4 = null;
			mc = null;*/
		}
		public function imgSetting( index:Number , b:Bitmap ):void
		{
			//trace( "img Setting init!!! : " + index );
			if( index == 0 )
			{
				( this.getChildByName("mainClip") as ViewerItemMc ).setBitmap( b );
			} else {
				( this.getChildByName("sub" + index + "Clip") as ViewerItemMc ).setBitmap( b );
			}
		}
		
		public function itemSetting( ty:String , _numb:Number ):void
		{
			var _mc:MovieClip;
			
			switch( ty )
			{
				case Preset.TITLE_ITEM_STRING :
					removeTitleMask();
					titleItemNumb = _numb;
					DisplayObjectUtils.removeChilds( titleItem );
					_mc = ImageTitleManager.titleImgArr[_numb][skinLength];
					titleItem.addChild( _mc );
					break;
				case Preset.MAN_ITEM_STRING :
					manItemNumb = _numb;
					DisplayObjectUtils.removeChilds( manItem );
					_mc = ImageManManager.manImgArr[_numb][skinLength];
					manItem.addChild( _mc );
					break;
				case Preset.GIRL_ITEM_STRING :
					girlItemNumb = _numb;
					DisplayObjectUtils.removeChilds( girlItem );
					_mc = ImageGirlManager.girlImgArr[_numb][skinLength];
					girlItem.addChild( _mc );
					break;
			}
		}
		public function titleSetting( _alpha:Number , _color:Number ):void
		{
			titleItemAlpha = _alpha;
			titleItemColor = _color;
			titleItem.alpha = titleItemAlpha;
			/*if( titleItem.numChildren > 1 )
			{
				titleItem.getChildAt( 0 ).mask = null;
				titleItem.removeChildAt( 0 );
				DisplayObjectUtils.removeChilds( titleItem , 1 );
			}*/
			removeTitleMask();
			
			if( !isNaN( _color ) )
			{
				var colorMc:Sprite = new Sprite();
				colorMc.graphics.beginFill( _color );
				colorMc.graphics.drawRect( 0 , 0 , titleItem.width , titleItem.height );
				colorMc.graphics.endFill();
				titleItem.addChildAt( colorMc , 0 );
				colorMc.mask = titleItem.getChildAt( 1 );
			}
		}
		private function removeTitleMask():void
		{
			if( titleItem.numChildren > 1 )
			{
				titleItem.getChildAt( 0 ).mask = null;
				titleItem.removeChildAt( 0 );
				DisplayObjectUtils.removeChilds( titleItem , 1 );
			}
		}
		public function textfieldSet( _text:String , _color:Number , _alpha:Number , _textformat:TextFormat = null ):void
		{
			txtfdBgColor = _color;
			txtfdBgAlpha = _alpha;
			
			if( _textformat == null )
			{
				txtfd.htmlText = _text;
			} else {
				txtfd.text = _text.replace( /\r\n/g, "\n" );
				txtfd.setTextFormat( _textformat );
			}
			txtfdBg.graphics.clear();
			if( !isNaN( txtfdBgColor ) )
			{
				txtfdBg.graphics.beginFill( txtfdBgColor , txtfdBgAlpha );
				txtfdBg.graphics.drawRect( 0 , 0 , MCard.xml.skin[numb].skinTxt.@width , MCard.xml.skin[numb].skinTxt.@height );
				txtfdBg.graphics.endFill();
			}
		}
		private function textfieldSetFirst():void
		{
			txtfdBgColor = MemberManager.textfieldBgColor;
			txtfdBgAlpha = MemberManager.textfieldBgAlpha;
			txtfd.condenseWhite = true;
			txtfd.htmlText = MemberManager.textfieldText;
			txtfdBg.graphics.clear();
			if( !isNaN( txtfdBgColor ) )
			{
				txtfdBg.graphics.beginFill( txtfdBgColor , txtfdBgAlpha );
				txtfdBg.graphics.drawRect( 0 , 0 , MemberManager.textfieldWidth , MemberManager.textfieldHeight );
				txtfdBg.graphics.endFill();
			}
		}
		public function get _titleItemNumb():Number
		{
			return titleItemNumb;
		}
		public function get _titleItemAlpha():Number
		{
			return titleItemAlpha;
		}
		public function get _titleItemColor():Number
		{
			return titleItemColor;
		}
		public function get _manItemNumb():Number
		{
			return manItemNumb;
		}
		public function get _girlItemNumb():Number 
		{
			return girlItemNumb;
		}
		public function get _textfieldBgColor():Number
		{
			return txtfdBgColor;
		}
		public function get _textfieldBgAlpha():Number
		{
			return txtfdBgAlpha;
		}
		
		private function titleItemDown( e:MouseEvent ):void
		{
			if( isDrag )
			{
				var _mc:MovieClip = e.currentTarget as MovieClip;
				var bounds:Rectangle = new Rectangle(0 , 0 , Preset.SKIN_WH[0] - _mc.width , Preset.SKIN_WH[1] - _mc.height );
				_mc.startDrag( false , bounds );
			}			
		}
		private function manItemDown( e:MouseEvent ):void
		{
			if( isDrag )
			{
				var _mc:MovieClip = e.currentTarget as MovieClip;
				var bounds:Rectangle = new Rectangle(0 , 0 , Preset.SKIN_WH[0] - _mc.width , Preset.SKIN_WH[1] - _mc.height );
				_mc.startDrag( false , bounds );
			}			
		}
		private function girlItemDown( e:MouseEvent ):void
		{
			if( isDrag )
			{
				var _mc:MovieClip = e.currentTarget as MovieClip;
				var bounds:Rectangle = new Rectangle(0 , 0 , Preset.SKIN_WH[0] - _mc.width , Preset.SKIN_WH[1] - _mc.height );
				_mc.startDrag( false , bounds );
			}
		}
		private function titleItemUp( e:MouseEvent ):void
		{
			if( isDrag )
			{
				( e.currentTarget as MovieClip ).stopDrag();
			}			
		}
		private function manItemUp( e:MouseEvent ):void
		{
			if( isDrag )
			{
				( e.currentTarget as MovieClip ).stopDrag();
			}
		}
		private function girlItemUp( e:MouseEvent ):void
		{
			if( isDrag )
			{
				( e.currentTarget as MovieClip ).stopDrag();
			}
		}
	}
}