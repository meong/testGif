package com.mcard
{
	import caurina.transitions.Tweener;
	
	import com.fwang.components.SliderBar;
	import com.fwang.controller.TextfieldEditor;
	import com.fwang.events.EventInData;
	import com.fwang.utils.DisplayObjectUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageManager;
	import com.mcard.manager.MemberManager;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Stage02 extends Sprite
	{
		private var stageIsFirst:Boolean = true;
		private var body02Clip:Body02 = new Body02();
		private var viewerMask:MovieClip = new MovieClip();			
		private var textfieldBgMc:MovieClip = new MovieClip();
		private var viewerItemEdit:ViewerItemEdit = new ViewerItemEdit();
		private var titleBox:Stage02ItemboxSlider = new Stage02ItemboxSlider( body02Clip.titleBoxArrow , Preset.TITLE_BOX_GAP , Preset.TITLE_ITEM_STRING );
		private var manBox:Stage02ItemboxSlider = new Stage02ItemboxSlider( body02Clip.manBoxArrow , Preset.MAN_BOX_GAP , Preset.MAN_ITEM_STRING );
		private var girlBox:Stage02ItemboxSlider = new Stage02ItemboxSlider( body02Clip.girlBoxArrow , Preset.GIRL_BOX_GAP , Preset.GIRL_ITEM_STRING );
		private var comboboxDataColor:DataProvider = new DataProvider();
		private var comboboxDataFontStyle:DataProvider = new DataProvider();
		private var comboboxDataFontSize:DataProvider = new DataProvider();
		private var comboboxDataLetterspacing:DataProvider = new DataProvider();
		private var sliderbarTxtAlpha:SliderBar = new SliderBar( body02Clip.copyBox.sliderbarAlpha );
		private var sliderbarTitleAlpha:SliderBar = new SliderBar( body02Clip.sliderbarTitleAlpha );
		private var textfieldEditor:TextfieldEditor = new TextfieldEditor( body02Clip.copyBox.txt.txt );
		private var defaultTextFormat:TextFormat = new TextFormat();
		
		//private var skinIdx:Number;
		private var titleSkinIndex:Number;
		private var manSkinIndex:Number;
		private var girlSkinIndex:Number;
		private var numb:Number;
		private var titleItemAlpha:Number;
		private var titleItemColor:Number;
		private var txtBgAlpha:Number;
		private var txtBgColor:Number;
		private var fontlistArr:Array;
		private var manTel1:String;
		private var girlTel1:String;
		
		private var viewerItemEditIsStageInit:Boolean = false;
		private var titleBoxIsStageInit:Boolean = false;
		private var manBoxIsStageInit:Boolean = false;
		private var girlBoxIsStageInit:Boolean = false;
		
		public function Stage02()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			addChild( body02Clip );
			addChild( titleBox );
			addChild( manBox );
			addChild( girlBox );
			addChild( viewerItemEdit );
			addChild( viewerMask );
		}
		private function setListener():void
		{
			body02Clip.btnComplete.addEventListener( MouseEvent.MOUSE_DOWN , btnCompleteDown );
			body02Clip.btnPreview.addEventListener( MouseEvent.CLICK , btnPreviewClick );
			body02Clip.btnCancel.addEventListener( MouseEvent.CLICK , btnCancelClick );
			sliderbarTitleAlpha.addEventListener( SliderBar.CHANGE , sliderbarTitleAlphaChange );
			body02Clip.colorPickerTitle.addEventListener( ColorPickerEvent.CHANGE , titleColorChange );
			body02Clip.btnOrig.addEventListener( MouseEvent.CLICK , btnOrigClick );
			titleBox.addEventListener( EventInData.onAction , itemBoxItemSet );
			manBox.addEventListener( EventInData.onAction , itemBoxItemSet );
			girlBox.addEventListener( EventInData.onAction , itemBoxItemSet );
			body02Clip.txtManTel.btnTxt1.addEventListener( MouseEvent.CLICK , tel1Click );
			body02Clip.txtManTel.txt1.tel010.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtManTel.txt1.tel011.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtManTel.txt1.tel016.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtManTel.txt1.tel017.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtManTel.txt1.tel018.addEventListener( MouseEvent.CLICK , telItemClick);
			body02Clip.txtManTel.txt1.tel019.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.btnTxt1.addEventListener( MouseEvent.CLICK , tel1Click );
			body02Clip.txtGirlTel.txt1.tel010.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.txt1.tel011.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.txt1.tel016.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.txt1.tel017.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.txt1.tel018.addEventListener( MouseEvent.CLICK , telItemClick );
			body02Clip.txtGirlTel.txt1.tel019.addEventListener( MouseEvent.CLICK , telItemClick );
			
			//copybox
			body02Clip.copyBox.txt.txt.addEventListener( MouseEvent.CLICK , textfieldClick );
			body02Clip.copyBox.txt.txt.addEventListener( KeyboardEvent.KEY_UP , textfieldKeyboardClick );
			body02Clip.copyBox.txt.txt.addEventListener( TextEvent.TEXT_INPUT , textfieldInput );
			body02Clip.copyBox.colorPickerWrap.addEventListener( MouseEvent.CLICK , cpWrapClick );
			body02Clip.copyBox.colorPickerBg.addEventListener( ColorPickerEvent.CHANGE , cpBgChange );
			sliderbarTxtAlpha.addEventListener( SliderBar.CHANGE , sliderbarTxtAlphaChange );
			this.addEventListener( MouseEvent.MOUSE_UP , stageMouseUp );
			body02Clip.copyBox.comboboxFontStyle.addEventListener( Event.CHANGE , copyboxFontChange );
			body02Clip.copyBox.comboboxFontSize.addEventListener( Event.CHANGE , copyboxFontsizeChange );
			//body02Clip.copyBox.comboboxletterspacing.addEventListener( Event.CHANGE , copyboxLetterSpacingChange );
			body02Clip.copyBox.colorPicker.addEventListener( ColorPickerEvent.CHANGE , copyboxFontcolorChange );
			body02Clip.copyBox.btnBold.addEventListener( MouseEvent.CLICK , copyboxBoldClick );
			body02Clip.copyBox.btnItalic.addEventListener( MouseEvent.CLICK , copyboxItalicClick );
			//body02Clip.copyBox.btnNormal.addEventListener( MouseEvent.CLICK , copyboxNormalClick );
			body02Clip.copyBox.btnAlignLeft.addEventListener( MouseEvent.CLICK , copyboxAlignLeftClick );
			body02Clip.copyBox.btnAlignCenter.addEventListener( MouseEvent.CLICK , copyboxAlignCenterClick );
			body02Clip.copyBox.btnAlignRight.addEventListener( MouseEvent.CLICK , copyboxAlignRightClick );
			body02Clip.copyBox.btnTextSet.addEventListener( MouseEvent.CLICK , btnTextSetClick );
			
			viewerItemEdit.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			titleBox.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			manBox.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			girlBox.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
		}
		private function setDefault():void
		{
			var ii:Number;
			/*
			for( var ii:Number = 1 ; ii <= Preset.TEL_TYPE.length ; ii++ )
			{
				( body02Clip.txtManTel.txt1 as ComboBox ).addItem( { label : Preset.TEL_TYPE[ ii ] } );
				( body02Clip.txtGirlTel.txt1 as ComboBox ).addItem( { label : Preset.TEL_TYPE[ ii ] } );
			}
			*/
			body02Clip.copyBox.txt.addChildAt( textfieldBgMc , 0 );
			viewerItemEdit.x = Preset.EDIT_BODY[0];
			viewerItemEdit.y = Preset.EDIT_BODY[1];
			viewerMask.x = Preset.EDIT_BODY[0];
			viewerMask.y = Preset.EDIT_BODY[2];
			titleBox.x = Preset.TITLE_COMPONENT_XY[0];
			titleBox.y = Preset.TITLE_COMPONENT_XY[1];
			manBox.x = Preset.MAN_COMPONENT_XY[0];
			manBox.y = Preset.MAN_COMPONENT_XY[1];
			girlBox.x = Preset.GIRL_COMPONENT_XY[0];
			girlBox.y = Preset.GIRL_COMPONENT_XY[1];
			body02Clip.txtManTel.txt1.alpha = 0; body02Clip.txtManTel.txt1.height = 10;
			body02Clip.txtGirlTel.txt1.alpha = 0; body02Clip.txtGirlTel.txt1.height = 10;
			body02Clip.txtManTel.txt2.maxChars = 4;
			body02Clip.txtGirlTel.txt2.maxChars = 4;
			body02Clip.txtManTel.txt3.maxChars = 4;
			body02Clip.txtGirlTel.txt3.maxChars = 4;
			
			// font style setting
			fontlistArr = Font.enumerateFonts( true );
			
			//comboboxData.addItems( fontlistArr );
			for each ( var font:Font in fontlistArr )
			{
				comboboxDataFontStyle.addItem( { label:font.fontName, data:font } );
			}
			body02Clip.copyBox.comboboxFontStyle.dataProvider = comboboxDataFontStyle;
			
			for( ii = Preset.COPYBOX_COMBOBOX_FONTSIZE_PEOD[0] ; ii <= Preset.COPYBOX_COMBOBOX_FONTSIZE_PEOD[1] ; ii ++ )
			{
				comboboxDataFontSize.addItem( { label:ii, data:ii } );
			}
			body02Clip.copyBox.comboboxFontSize.dataProvider = comboboxDataFontSize;
			
			/*for( ii = Preset.COPYBOX_COMBOBOX_LETTERSPACING[0] ; ii <= Preset.COPYBOX_COMBOBOX_LETTERSPACING[1] ; ii ++ )
			{
				comboboxDataLetterspacing.addItem( { label: ii , data:ii } );
			}
			body02Clip.copyBox.comboboxletterspacing.dataProvider = comboboxDataLetterspacing;
			*/
			
			//color picker setting
			body02Clip.copyBox.colorPicker.colors = Preset.COPYBOX_COLORPICKER_COLOR;
			body02Clip.copyBox.colorPickerBg.colors = Preset.COPYBOX_COLORPICKER_COLOR;
			
			viewerMask.graphics.beginFill( 0xFF0000 );
			viewerMask.graphics.drawRect( 0 , 0 , Preset.STAGE02_SKIN_WH[0] + 30 , Preset.STAGE02_SKIN_WH[1] );
			viewerMask.graphics.endFill();
			viewerItemEdit.mask = viewerMask;
		}
		
		public function get manTel():String
		{
			return manTel1 + body02Clip.txtManTel.txt2.text + body02Clip.txtManTel.txt3.text;
		}
		public function get girlTel():String
		{
			return girlTel1 + body02Clip.txtGirlTel.txt2.text + body02Clip.txtGirlTel.txt3.text;
		}
		// edit swf load function 
		public function stageInit( i:Number , isFirst:Boolean ):void
		{
			//trace(" stage02!! stageInit i , isfirst : " + i , isFirst );
			viewerItemEdit.stageInit( i );
			titleItemAlpha = 1;
			titleItemColor = NaN;
			if( isFirst )
			{
				titleBox.stageInit( MCard.xml.title , Preset.TITLE_ITEM_STRING );
				manBox.stageInit( MCard.xml.man , Preset.MAN_ITEM_STRING );
				girlBox.stageInit( MCard.xml.girl , Preset.GIRL_ITEM_STRING );
				textInit();
			} else {
				titleBoxIsStageInit = true;
				manBoxIsStageInit = true;
				girlBoxIsStageInit = true;
			}
		}
		
		public function editSwfLoad( numb:Number ):void
		{
			this.numb = numb;
			if( MemberManager.isFirst != 1 )
			{
				titleSkinIndex = MemberManager.titleIndex;
				manSkinIndex = MemberManager.manIndex;
				girlSkinIndex = MemberManager.girlIndex;
			} else {
				titleSkinIndex = MCard.xml.skin[numb].skinTitle.@index;
				manSkinIndex = MCard.xml.skin[numb].skinMan.@index;
				girlSkinIndex = MCard.xml.skin[numb].skinGirl.@index;
			}
			
			var lor:Loader = new Loader();
			lor.load( new URLRequest( Preset.SITE_URL + MCard.xml.skin[numb].@body ) );
			lor.contentLoaderInfo.addEventListener( Event.COMPLETE , editSwfLoadComplete );
		}
		
		private function stageInitComplete( e:EventInData ):void
		{
			switch( e.data )
			{
				case Preset.TITLE_ITEM_STRING :
					titleBoxIsStageInit = true;
					break;
				case Preset.MAN_ITEM_STRING :
					manBoxIsStageInit = true;
					break;
				case Preset.GIRL_ITEM_STRING :
					girlBoxIsStageInit = true;
					break;
				default :
					viewerItemEditIsStageInit = true;
					break;
			}
			if( viewerItemEditIsStageInit && titleBoxIsStageInit && manBoxIsStageInit && girlBoxIsStageInit )
			{
				dispatchEvent( new EventInData( Preset.BODY02_CLASS_STRING , Preset.DISPATCH_STAGEINIT_COMPLETE ) );
			}
		}
		//public function editSwfLoad( e:Event , status:Number ):void
		private function editSwfLoadComplete( e:Event ):void
		{
			//this.numb = status;
			//viewerItemEdit.viewerItemInit( e.currentTarget.content , status );
			viewerItemEdit.viewerItemInit( e.currentTarget.content , numb );
			if( MemberManager.isFirst != 1 && stageIsFirst )
			{
				stageIsFirst = false;
				txtBgColor = MemberManager.textfieldBgColor;
				txtBgAlpha = MemberManager.textfieldBgAlpha;
				textfieldBgSet();
				textBoxBgInit( txtBgColor , txtBgAlpha );
				
			} else {
				textStyleInit();
			}
		}
		// bitmap reset function
		public function bitmapReset():void
		{
			for( var ii :Number = 0 ; ii < ImageManager.length() ; ii++ )
			{
				viewerItemEdit.bitmapSet( ii );
			}
		}
		
		public function twEditComplete1():void
		{
			viewerItemEdit.y = Preset.EDIT_BODY[1];
			viewerItemEdit.stageRemove();
		}
		public function twEditComplete2():void
		{
			Tweener.addTween( viewerItemEdit , { y:Preset.EDIT_BODY[2] , time:2 } );
		}
		public function getSaveImage():MovieClip
		{
			return viewerItemEdit.getSaveImage();
		}
		/*
		public function imageMake():ByteArray
		{
			//var ba:ByteArray;
			var bmd:BitmapData = new BitmapData( Preset.SKIN_WH[0] , Preset.SKIN_WH[1] );
			bmd.draw( viewerItemEdit );
			var ba:ByteArray = new JPEGEncoder( Preset.JPEG_QUALITY ).encode( bmd );
			return ba;
		}
		*/
		
		private function textBoxBgInit( _color:uint = NaN , _alpha:Number = NaN ):void
		{
			sliderbarTxtAlpha.setPoint( _alpha * 100 );
			body02Clip.copyBox.colorPickerBg.selectedColor = _color;
		}
		private function textInit():void
		{
			var _textforamt:TextFormat = new TextFormat();
			_textforamt.bold = true;
			( body02Clip.txtManTel.txt2 as TextField ).defaultTextFormat = _textforamt;
			( body02Clip.txtManTel.txt3 as TextField ).defaultTextFormat = _textforamt;
			( body02Clip.txtGirlTel.txt2 as TextField ).defaultTextFormat = _textforamt;
			( body02Clip.txtGirlTel.txt3 as TextField ).defaultTextFormat = _textforamt;
			telItemSet( body02Clip.txtManTel.txt1.getChildByName( "tel" + MemberManager.manTel1 ) );
			body02Clip.txtManTel.txt2.text = MemberManager.manTel2;
			body02Clip.txtManTel.txt3.text = MemberManager.manTel3;
			telItemSet( body02Clip.txtGirlTel.txt1.getChildByName( "tel" + MemberManager.girlTel1 ) );
			body02Clip.txtGirlTel.txt2.text = MemberManager.girlTel2;
			body02Clip.txtGirlTel.txt3.text = MemberManager.girlTel3;
			
			if( MemberManager.isFirst != 1 )
			{
				body02Clip.copyBox.txt.txt.htmlText = MemberManager.textfieldText;
			} else {
				body02Clip.copyBox.txt.txt.text = MemberManager.txt;
			}
		}
		private function textStyleInit( isFirst:Boolean = true ):void
		{
			var txtfield:TextField = body02Clip.copyBox.txt.txt ;
			var txtformat:TextFormat;
			var font:Font;
			var ii:Number;
			
			var fontStyle:String;
			var fontSize:Number;
			var fontColor:Number;
			var letterSpacing:Number;
			var isBold:String;
			var isItalic:String;
			var alignStr:String;
			var bgColor:uint;
			var bgAlpha:Number;
			
			if( isFirst )
			{
				fontStyle = MCard.xml.skin[numb].skinTxt.@style;
				fontSize = Number( MCard.xml.skin[numb].skinTxt.@size );
				letterSpacing = Number( MCard.xml.skin[numb].skinTxt.@letterspacing );
				fontColor = ( MCard.xml.skin[numb].skinTxt.@color == "" ) ? NaN : MCard.xml.skin[numb].skinTxt.@color;
				isBold = MCard.xml.skin[numb].skinTxt.@bold;
				isItalic = MCard.xml.skin[numb].skinTxt.@italic;
				alignStr = MCard.xml.skin[numb].skinTxt.@align;
				
				txtBgColor = ( MCard.xml.skin[numb].skinTxt.@bg == "" ) ? NaN : MCard.xml.skin[numb].skinTxt.@bg;
				txtBgAlpha = MCard.xml.skin[numb].skinTxt.@bgAlpha;
				defaultTextFormat.font = MCard.xml.skin[numb].skinTxt.@style;
				defaultTextFormat.size = MCard.xml.skin[numb].skinTxt.@size;
				defaultTextFormat.letterSpacing = MCard.xml.skin[numb].skinTxt.@letterspacing;
				defaultTextFormat.color = fontColor;
				defaultTextFormat.bold = ( isBold != "0" ) ? true : false;
				defaultTextFormat.italic = ( isItalic != "0" ) ? true : false;
				defaultTextFormat.align = alignStr;
				( body02Clip.copyBox.txt.txt as TextField ).setTextFormat( defaultTextFormat );
				
				// background movieclip set
				textfieldBgMc.graphics.clear();
				
				if( !isNaN( bgColor ) )
				{
					textfieldBgSet();
				}
				
			} else {
				txtformat = ( txtfield.selectionBeginIndex < txtfield.length ) ? txtfield.getTextFormat( txtfield.selectionBeginIndex ) : txtfield.defaultTextFormat;
				fontStyle = txtformat.font;
				fontSize = ( txtformat.size as Number );
				letterSpacing = ( txtformat.letterSpacing as Number );
				fontColor = txtformat.color as Number;
				isBold = ( txtformat.bold as Boolean ) ? "1" : "0" ;
				isItalic = ( txtformat.italic as Boolean ) ? "1" : "0";
				alignStr = txtformat.align;
			}
			
			for( ii = 0 ; ii < fontlistArr.length ; ii++ )
			{
				font = fontlistArr[ii];
				if( font.fontName == fontStyle )
				{
					break;
				}
			}
			// fontStyleIndex = ii;
			body02Clip.copyBox.comboboxFontStyle.selectedIndex = ii; 
			body02Clip.copyBox.comboboxFontSize.selectedIndex = fontSize - Preset.COPYBOX_COMBOBOX_FONTSIZE_PEOD[0];
			//body02Clip.copyBox.comboboxletterspacing.selectedIndex = letterSpacing - Preset.COPYBOX_COMBOBOX_LETTERSPACING[0];
			body02Clip.copyBox.colorPicker.selectedColor = fontColor;
			( isBold != "0" ) ? ( body02Clip.copyBox.btnBold as MovieClip ).gotoAndStop( 2 ) : ( body02Clip.copyBox.btnBold as MovieClip ).gotoAndStop( 1 );
			( isItalic != "0" ) ? ( body02Clip.copyBox.btnItalic as MovieClip ).gotoAndStop( 2 ) : ( body02Clip.copyBox.btnItalic as MovieClip ).gotoAndStop( 1 );
			
			switch( alignStr )
			{
				case TextFormatAlign.LEFT :
					copyboxAlignLeftClick();
					break;
				case TextFormatAlign.CENTER :
					copyboxAlignCenterClick();
					break;
				case TextFormatAlign.RIGHT :
					copyboxAlignRightClick();
					break;
				default : 
					
					break;
			}
			sliderbarTxtAlpha.setPoint( txtBgAlpha * 100 );
			body02Clip.copyBox.colorPickerBg.selectedColor = txtBgColor;
		}
		private function btnCompleteDown( e:MouseEvent ):void
		{
			dispatchEvent( new Event( Preset.EVENT_STR_SAVE_DOWN ) );
		}
		
		private function btnPreviewClick( e:MouseEvent ):void
		{
			dispatchEvent( new Event( "preview" ) );
		}
		private function btnCancelClick( e:MouseEvent ):void
		{
			dispatchEvent( new Event( "bodyGoPrev" ) );
		}
		private function tel1Click( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget.parent.getChildByName( "txt1" );
			if( _mc.alpha == 0 )
			{
				_mc.alpha = 1;	_mc.height = Preset.TEL1_LIST_HEIGHT;
			} else {
				_mc.alpha = 0;	_mc.height = 10;
			}
		}
		private function telItemClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			telItemSet( _mc );
		}
		private function telItemSet( _mc:MovieClip ):void
		{
			if( _mc.parent.parent.name == "txtManTel" )
			{
				manTel1 = _mc.name.replace( "tel" , "" );
			} else if ( _mc.parent.parent.name == "txtGirlTel" )
			{
				girlTel1 = _mc.name.replace( "tel" , "" );
			}
			var _mcCopy:MovieClip = DisplayObjectUtils.duplicate( _mc ) as MovieClip;
			if( _mc.parent.parent.getChildByName( Preset.TEL1_MC_NAME ) != null ) 
			{
				_mc.parent.parent.removeChild( _mc.parent.parent.getChildByName( Preset.TEL1_MC_NAME ) );
			}
			_mcCopy.name = Preset.TEL1_MC_NAME;
			_mc.parent.parent.addChildAt( _mcCopy , 1 );
			_mcCopy.x = Preset.TEL1_XY[0];
			_mcCopy.y = Preset.TEL1_XY[1];
			_mc.parent.parent.getChildByName( "txt1" ).alpha = 0;	_mc.parent.parent.getChildByName( "txt1" ).height = 10;
		}
		private function itemBoxItemSet( e:EventInData ):void
		{
			switch( e.data[0] )
			{
				case Preset.TITLE_ITEM_STRING :
					titleSkinIndex = e.data[1];
					break;
				case Preset.MAN_ITEM_STRING : 
					manSkinIndex = e.data[1];
					break;
				case Preset.GIRL_ITEM_STRING :
					girlSkinIndex = e.data[1];
					break;
			}
			viewerItemEdit.setSkinItem( e.data[0] , e.data[1] );
		}
		private function textfieldClick( e:MouseEvent ):void
		{
			textStyleInit( false );
		}
		private function textfieldKeyboardClick( e:KeyboardEvent ):void
		{
			textStyleInit( false );
		}
		private function textfieldInput( e:TextEvent ):void
		{
			textStyleInit( false );
		}
		private function cpWrapClick( e:MouseEvent ):void
		{
			body02Clip.copyBox.colorPicker.open();
		}
		private function cpBgChange( e:ColorPickerEvent ):void
		{
			txtBgColor = e.color;
			textfieldBgSet();
			
		}
		private function sliderbarTxtAlphaChange( e:EventInData ):void
		{
			txtBgAlpha = ( e.data as Number ) / 100;
		}
		private function sliderbarTitleAlphaChange( e:EventInData ):void
		{
			titleItemAlpha = ( e.data as Number ) / 100;
			viewerItemEdit.setSkinTitle( titleItemAlpha , titleItemColor );
		}
		private function titleColorChange( e:ColorPickerEvent ):void
		{
			titleItemColor = e.color;
			viewerItemEdit.setSkinTitle( titleItemAlpha , titleItemColor );
		}
		private function btnOrigClick( e:MouseEvent ):void
		{
			titleItemColor = NaN;
			viewerItemEdit.setSkinTitle( titleItemAlpha , titleItemColor );
		}
		private function stageMouseUp( e:MouseEvent ):void
		{
			txtBgAlpha = sliderbarTxtAlpha.rate;
			sliderbarTxtAlpha.stopDrag();
			textfieldBgSet();
		}
		private function copyboxFontChange( e:Event ):void
		{
			textfieldEditor.setFont( ( e.currentTarget as ComboBox ).selectedLabel );
		}
		private function copyboxFontsizeChange( e:Event ):void
		{
			textfieldEditor.setFontSize( Number( ( e.currentTarget as ComboBox ).value ) );
		}
		private function copyboxLetterSpacingChange( e:Event ):void
		{
			textfieldEditor.setLetterSpacing( Number( ( e.currentTarget as ComboBox ).value ) );
		}
		private function copyboxFontcolorChange( e:ColorPickerEvent ):void
		{
			textfieldEditor.setFontColor( e.color );
		}
		private function copyboxBoldClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _boo:Boolean;
			if( _mc.currentFrame == 1 )
			{
				_mc.gotoAndStop( 2 );
				_boo = true;
			} else {
				_mc.gotoAndStop( 1 );
				_boo = false;
			}
			textfieldEditor.setBold( _boo );
		}
		private function copyboxItalicClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _boo:Boolean;
			if( _mc.currentFrame == 1 )
			{
				_mc.gotoAndStop( 2 );
				_boo = true;
			} else {
				_mc.gotoAndStop( 1 );
				_boo = false;
			}
			textfieldEditor.setItalic( _boo );
		}
		private function copyboxNormalClick( e:MouseEvent ):void
		{
			textfieldEditor.setNormal();
		}
		private function copyboxAlignLeftClick( e:MouseEvent = null ):void
		{
			if( body02Clip.copyBox.btnAlignLeft.currentFrame == 1 )
			{
				( body02Clip.copyBox.btnAlignLeft as MovieClip ).gotoAndStop( 2 );
				( body02Clip.copyBox.btnAlignCenter as MovieClip ).gotoAndStop( 1 );
				( body02Clip.copyBox.btnAlignRight as MovieClip ).gotoAndStop( 1 );
				textfieldEditor.setAlign( TextFormatAlign.LEFT );
			}
		}
		private function copyboxAlignCenterClick( e:MouseEvent = null ):void
		{
			if( body02Clip.copyBox.btnAlignCenter.currentFrame == 1 )
			{
				( body02Clip.copyBox.btnAlignLeft as MovieClip ).gotoAndStop( 1 );
				( body02Clip.copyBox.btnAlignCenter as MovieClip ).gotoAndStop( 2 );
				( body02Clip.copyBox.btnAlignRight as MovieClip ).gotoAndStop( 1 );
				textfieldEditor.setAlign( TextFormatAlign.CENTER );
			}
		}
		private function copyboxAlignRightClick( e:MouseEvent = null ):void
		{
			if( body02Clip.copyBox.btnAlignRight.currentFrame == 1 )
			{
				( body02Clip.copyBox.btnAlignLeft as MovieClip ).gotoAndStop( 1 );
				( body02Clip.copyBox.btnAlignCenter as MovieClip ).gotoAndStop( 1 );
				( body02Clip.copyBox.btnAlignRight as MovieClip ).gotoAndStop( 2 );
				textfieldEditor.setAlign( TextFormatAlign.RIGHT );
			}
		}
		private function btnTextSetClick( e:MouseEvent ):void
		{
			var textfield:TextField = body02Clip.copyBox.txt.txt;
			var txt:String = textfield.htmlText;
			/*var txtformat:TextFormat = textfield.getTextFormat();
			var txtformatArr:Vector.<TextFormat> = new Vector.<TextFormat>();
			txtformatArr[0] = txtformat;
			for( var ii:Number = 0 ; ii < txt.length ; ii++ )
			{
				txtformatArr[ii] = textfield.getTextFormat( ii , ii + 1 );
			}*/
			viewerItemEdit.textfieldSet( txt , txtBgColor , txtBgAlpha );
		}
		private function textfieldBgSet():void
		{
			if( !isNaN( txtBgColor ) )
			{
				textfieldBgMc.graphics.clear();
				textfieldBgMc.graphics.beginFill( txtBgColor );
				textfieldBgMc.graphics.drawRect( 0 , 0 , body02Clip.copyBox.txt.txt.width , body02Clip.copyBox.txt.txt.height );
				textfieldBgMc.graphics.endFill();
				textfieldBgMc.alpha = txtBgAlpha;
			}
		}
	}
}