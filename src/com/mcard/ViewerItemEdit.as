package com.mcard
{
	import com.fwang.components.ScrollBarController;
	import com.fwang.events.EventInData;
	import com.fwang.utils.ImageUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ViewerItemEdit extends Sprite
	{
		private var _mc:MovieClip;
		private var viewItem:viewerItem;
		private var viewItemEdit:viewerItem;
		private var bmBox:MovieClip = new MovieClip();
		private var bm6:Bitmap;
		private var bm7:Bitmap;
		private var bm8:Bitmap;
		private var bm9:Bitmap;
		private var bm10:Bitmap;
		private var isViewerSet:Boolean = false;
		private var isFirst:Boolean = true;
		private var isDrag:Boolean;
		
		// scroll bar setting
		private var sBarClip:ScrollBarControllerClip;
		private var sBar:ScrollBarController; // = new ScrollBarController( bmBox , sBarClip , bmBox.height + Preset.IMGVIEWER02_WH[1] , Preset.IMGVIEWER02_WH[1] ); 

		public function ViewerItemEdit( isDrag:Boolean = true )
		{
			this.isDrag = isDrag;
			viewItem = new viewerItem( true , isDrag );
			super();
			setDefault();
			setView();
			setListener();
			if( isDrag )
			{
				dragAbleSet();
			}
		}
		private function setDefault():void
		{
			viewItem.isDrag = isDrag;
		}
		private function setView():void
		{
			bmBox.addChild( viewItem );
			addChild( bmBox );
		}
		private function setListener():void
		{
			viewItem.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
		}
		private function dragAbleSet():void
		{
			sBarClip = new ScrollBarControllerClip();
			sBarClip.x = Preset.SBAR_CLIP[0];
			sBarClip.y = Preset.SBAR_CLIP[1];
			addChild( sBarClip );
		}
		
		public function get _width():Number
		{
			return viewItem.width;
		}
		public function set _width( w:Number ):void
		{
			viewItem.width = w;
		}
		public function get _height():Number
		{
			return viewItem.height;
		}
		public function set _height( h:Number ):void
		{
			viewItem.height = h;
		}
		
		public function viewerItemInit( _mc:MovieClip = null , idx:Number = NaN ):void
		{
			if( _mc != null ) {
				viewItem.viewerItemInit( idx , _mc );
				if( isFirst ) {
					//var sizeRate:Number = Preset.STAGE02_SKIN_WH[0] / viewItem.width;
					var sizeRate:Number = Preset.STAGE02_SKIN_WH[0] / Preset.SKIN_WH[0];
					viewItem.width *= sizeRate;
					viewItem.height *= sizeRate;
					isFirst = !isFirst;
				}
				isViewerSet = true;
			}	
			bitmapSet( idx );
			
			if( isDrag )
			{
				sBarClip.y = Preset.SBAR_CLIP[1];
				sBar = new ScrollBarController( bmBox , sBarClip , Preset.STAGE02_SKIN_WH[1] , Preset.SBAR_CLIP_MOVE_HEIGHT );
			}
		}
		public function bitmapSet( idx:Number = NaN ):void
		{
			if( idx >= 0 && idx < 5 && isViewerSet ) {
				trace( "viewItem.imgSetting " , idx );
				viewItem.imgSetting( idx , ImageManager.imgArr[idx] );
			}
			
			var numCnt:Number = bmBox.numChildren;
			for( var ii:Number = 0 ; ii < numCnt - 1 ; ii++ ) 
			{
				bmBox.removeChild( bmBox.getChildAt(1) );
			}
			
			if( ImageManager.imgArr[5] )
			{
				setImage( bm6 , ImageManager.imgArr[5] );
			}
			if( ImageManager.imgArr[6] )
			{
				setImage( bm7 , ImageManager.imgArr[6] );
			}
			if( ImageManager.imgArr[7] )
			{
				setImage( bm8 , ImageManager.imgArr[7] );
			}
			if( ImageManager.imgArr[8] ) 
			{
				setImage( bm9 , ImageManager.imgArr[8] );
			}
			if( ImageManager.imgArr[9] )
			{
				setImage( bm10 , ImageManager.imgArr[9] );
			}
			dispatchEvent( new EventInData( null , Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		}
		public function stageInit( isFirst:Number = NaN ):void
		{
			//trace("viewerItemInit( null , isFirst ) :: " + isFirst );
			viewerItemInit( null , isFirst );
		}
		
		public function stageRemove():void
		{
			isViewerSet = false;
			var numCnt:Number = bmBox.numChildren;
			//trace(" numCnt:::::::::::::" + numCnt );
			for( var ii:Number = 0 ; ii < numCnt - 1 ; ii++ )
			{
				bmBox.removeChildAt(1);
			}
			( bmBox.getChildAt(0) as viewerItem ).stageRemove();
			
		}
		
		// Stage02ItemBoxSlider 에서 클릭한 값  edit skin 에 적용
		public function setSkinItem( ty:String , numb:Number ):void
		{
			viewItem.itemSetting( ty , numb );
		}
		public function setSkinTitle( _alpha:Number , _color:Number ):void
		{
			//trace( "ViewerItemEdit setSkinTitle alpha , color : " , _alpha , _color );
			viewItem.titleSetting( _alpha , _color );
		}
		public function textfieldSet( _text:String , _color:uint , _alpha:Number ):void
		{
			viewItem.textfieldSet( _text , _color , _alpha );
		}
		public function saveImageMake( b:Bitmap ):Bitmap
		{
			setXYWH( b );
			return b;
		}
		public function getSaveImage():MovieClip
		{
			return bmBox.getChildAt(0) as MovieClip;
		}
		public function viewerItemEditSet( mc:viewerItem ):void
		{
			viewItemEdit = mc;
			
			setSkinItem( Preset.TITLE_ITEM_STRING , viewItemEdit._titleItemNumb );
			setSkinItem( Preset.MAN_ITEM_STRING , viewItemEdit._manItemNumb );
			setSkinItem( Preset.GIRL_ITEM_STRING , viewItemEdit._girlItemNumb );
			viewItem.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).x = viewItemEdit.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).x;
			viewItem.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).y = viewItemEdit.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).y;
				
			viewItem.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x = viewItemEdit.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x;
			viewItem.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y = viewItemEdit.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y;
			
			viewItem.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x = viewItemEdit.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x;
			viewItem.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y = viewItemEdit.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y;
			
			//( viewItem.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText = ( viewItemEdit.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText;
			viewItem.textfieldSet( ( viewItemEdit.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText , viewItemEdit._textfieldBgColor , viewItemEdit._textfieldBgAlpha );
			//viewItem.getChildByName( Preset.VIEWERITEM_TEXTFIELD_BG_NAME ).alpha = viewItemEdit._textfieldBgAlpha;
			//viewItem.getChildByName( Preset.VIEWERITEM_TEXTFIELD_BG_NAME ).colo = viewItemEdit._textfieldBgColor;
			
			/*parameters.TitleX1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).x;
			parameters.TitleY1 = mainMc.getChildByName( Preset.VIEWERITEM_TITLE_NAME ).y;
			parameters.TitleIndex = mainMc._titleItemNumb;
			parameters.TitleAlpha = mainMc._titleItemAlpha;
			parameters.TitleColor = mainMc._titleItemColor;
			
			parameters.ManX1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x;
			parameters.ManY1 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y;
			parameters.ManX2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).width;
			parameters.ManY2 = mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_MAN_NAME ).height;
			parameters.ManIndex = mainMc._manItemNumb;
			
			parameters.GirlX1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x;
			parameters.GirlY1 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y;
			parameters.GirlX2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).x + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).width;
			parameters.GirlY2 = mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).y + mainMc.getChildByName( Preset.VIEWERITEM_GIRL_NAME ).height;
			parameters.GirlIndex = mainMc._girlItemNumb;
			
			parameters.TextfieldText = ( mainMc.getChildByName( Preset.VIEWERITEM_TEXTFIELD_NAME ) as TextField ).htmlText;
			
			parameters.TextfieldBgColor = mainMc._textfieldBgColor;
			parameters.TextfieldBgAlpha = mainMc._textfieldBgAlpha;
			*/
			
		}
		private function stageInitComplete( e:Event ):void
		{
			dispatchEvent( new EventInData( null , Preset.DISPATCH_STAGEINIT_COMPLETE ) ) ;
		}
		private function setImage( b:Bitmap , parentB:Bitmap ):void
		{
			b = null;
			b = ImageUtils.duplicateImage( parentB );
			bmBox.addChild( b );
			setXYWH( b );
		}
		private function setXYWH( b:Bitmap ):void
		{
			var tmpW:Number = b.width;
			b.width = Preset.STAGE02_SKIN_WH[0];
			b.height = b.height * b.width / tmpW;
			if( bmBox.numChildren > 2 )
			{
				b.y = bmBox.getChildAt( bmBox.numChildren - 2 ).y + bmBox.getChildAt( bmBox.numChildren - 2 ).height;
			} else {
				//b.y = bmBox.getChildAt( bmBox.numChildren - 2 ).height;
				b.y = Preset.STAGE02_SKIN_WH[0] / Preset.SKIN_WH[0] * Preset.SKIN_WH[1]; 
			}
		}
		private function getHeightdependenWidth( b:Bitmap ):Number
		{
			return 0;
		}
	}
}