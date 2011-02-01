package com.mcard.popup
{
	import com.fwang.components.SliderBar;
	import com.fwang.events.EventInData;
	import com.fwang.filter.FilterCollection;
	import com.fwang.utils.DisplayObjectUtils;
	import com.fwang.utils.ImageUtils;
	import com.fwang.utils.MathUtils;
	import com.gskinner.geom.ColorMatrix;
	import com.mcard.Setting.Preset;
	import com.mcard.events.EventInDataClass;
	import com.mcard.manager.ImageManager;
	import com.mcard.manager.SkinManager;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;

	public class EditPop extends Sprite
	{
		private var editClip:EditClip = new EditClip();
		private var topNaviBox:MovieClip = new MovieClip();
		private var lomoBox:ComboBox = new ComboBox();
		private var lomoBoxData:DataProvider = new DataProvider();
		private var sliderbarBrightness:SliderBar = new SliderBar( editClip.sliderbarBrightness );
		private var sliderbarContrast:SliderBar = new SliderBar( editClip.sliderbarContrast );
		private var wrapMask:MovieClip = new MovieClip();
		private var canvasWrapAngle:MovieClip = new MovieClip();
		private var canvasWrapAngleRect:MovieClip = new MovieClip();
		private var angleWH:Vector.<Number> = new Vector.<Number>;
		private var bmList:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var realB:Bitmap = new Bitmap;
		private var bOriginal:Bitmap = new Bitmap;
		private var bitmapOrigWH:Vector.<Number> = new Vector.<Number>;
		private var bd:BitmapData;
		private var bbd:BitmapData;
		private var bmBox:MovieClip = new MovieClip();
		
		private var filterCollector:FilterCollection = new FilterCollection();
		private var filtersArray:Vector.<String> = new Vector.<String>;
		private var colorMatrix:ColorMatrix = new ColorMatrix();
		private var numb:Number;
		private var skinNumb:Number;
		private var isFirst:Boolean = true;
		
		private var brightnessRate:Number;
		private var contrastRate:Number;
		private var rotationTy:Number = 0;
		private var isVertical:Boolean;
		private var positionX:Number = 0;
		private var positionY:Number = 0;
		private var isGray:Boolean = false;
		private var isSepia:Boolean = false;
		private var isOld:Boolean = false;
		private var isLuxury:Boolean = false;
		private var lomo:Number = 0;
		
		public function EditPop()
		{
			setDefault();
			setView();
			setListener();
		}
		private function setDefault():void
		{
			lomoBox.dataProvider = lomoBoxData;
			lomoBox.name = Preset.EDIT_POP_LOMOBOX_NAME;
			for( var ii:Number = 1 ; ii <= Preset.EDIT_POP_LOMOBOX_DATA.length ; ii++ )
			{
				lomoBoxData.addItem( { label : ii } );
			}
			
			// canvas mask
			wrapMask.graphics.beginFill( 0xFF0000 );
			wrapMask.graphics.drawRect( 0 , 0 , editClip.canvas.width , editClip.canvas.height );
			wrapMask.graphics.endFill();
			wrapMask.x = editClip.canvas.x;
			wrapMask.y = editClip.canvas.y;
			canvasWrapAngle.mask = wrapMask;
			canvasWrapAngle.name = "angleWrapper";
			editClip.btnSepia.buttonMode = true;
			editClip.btnOld.buttonMode = true;
			editClip.btnGray.buttonMode = true;
			editClip.btnLomo.buttonMode = true;
			editClip.btnLuxury.buttonMode = true;
		}
		private function setView():void
		{
			addChild( editClip );
			editClip.addChild( topNaviBox );
			topNaviBox.x = Preset.EDIT_POP_TOPNAVI_BOX_XY[0];
			topNaviBox.y = Preset.EDIT_POP_TOPNAVI_BOX_XY[1];
			editClip.addChild( lomoBox );
			lomoBox.x = Preset.EDIT_POP_LOMOBOX_XYWH[0];
			lomoBox.y = Preset.EDIT_POP_LOMOBOX_XYWH[1];
			lomoBox.width = Preset.EDIT_POP_LOMOBOX_XYWH[2];
			
			editClip.addChild( canvasWrapAngle );
			canvasWrapAngle.addChild( canvasWrapAngleRect );
			canvasWrapAngleRect.name = "canvasWrapAngleRect";
			editClip.addChild( wrapMask );
		}
		private function setListener():void
		{
			editClip.btnClose.addEventListener( MouseEvent.CLICK , closeClick );
			editClip.btnCancel.addEventListener( MouseEvent.CLICK , closeClick );
			editClip.btnSave.addEventListener( MouseEvent.CLICK , saveClick );
			editClip.btnRotationLeft.addEventListener( MouseEvent.CLICK , rotationLeftClick );
			editClip.btnRotationRight.addEventListener( MouseEvent.CLICK , rotationRightClick );
			addEventListener( MouseEvent.MOUSE_UP , stageMouseUp );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_GRAY_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_SEPIA_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_OLD_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_LUXURY_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_LOMO_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( Preset.EDIT_POP_LOMOBOX_NAME ).addEventListener( Event.CHANGE , comboboxSelected );
			sliderbarBrightness.addEventListener( SliderBar.CHANGE , sliderbarBrightnessChange );
			sliderbarContrast.addEventListener( SliderBar.CHANGE , sliderbarContrastChange );
			
			editClip.btnReset1.addEventListener( MouseEvent.CLICK , component1Reset );
			editClip.btnReset2.addEventListener( MouseEvent.CLICK , component2Reset );
			editClip.btnReset3.addEventListener( MouseEvent.CLICK , component3Reset );
			canvasWrapAngle.addEventListener( MouseEvent.MOUSE_DOWN , angleDown );
		}
		
		public function stageInit( numb:Number = NaN , isFirst:Boolean = true ):void
		{
			if( !isNaN( numb ) )
			{
				this.numb = numb;
			}
			
			this.isFirst = isFirst;
			if( isFirst )
			{
				//bitmapSet();
				//topNaviAngleSet();
			}
			dispatchEvent( new EventInData( Preset.EDIT_POP_CLASS_STRING , Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		}
		public function bitmapSet():void
		{
			var ii :Number;
			DisplayObjectUtils.removeChilds( topNaviBox );
			for( ii = topNaviBox.numChildren ; ii > 0 ; ii-- )
			{
				topNaviBox.removeChildAt(0);
			}
			
			for( ii = 0 ; ii < ImageManager.origImgArr.length ; ii++ )
			{
				var mc:MovieClip = DisplayObjectUtils.duplicate( editClip.topNaviBox.getChildAt(0) , true ) as MovieClip;
				var bbb:Bitmap = ImageUtils.duplicateImage( ImageManager.origImgArr[ii] );
				var bbbd:BitmapData;
				mc.name = Preset.EDIT_POP_TOPNAVI_PREFIX + ii;
				mc.buttonMode = true;
				
				//mc.addChildAt( bbb , 1 );
				//bbb.width = Preset.EDIT_POP_TOPNAVI_WH[0];
				//bbb.height = Preset.EDIT_POP_TOPNAVI_WH[1];
				topNaviBmSetWH( mc , bbb );
				mc.x = ( Preset.EDIT_POP_TOPNAVI_WH[0] + Preset.EDIT_POP_TOPNAVI_GAP ) * ii;
				mc.addEventListener( MouseEvent.CLICK , topNaviItemClick );
				topNaviBox.addChild( mc );
				
				//effect
				if( bbb != null )
				{
					bbb.filters = [ new ColorMatrixFilter( colorMatrix ) ];
					
					// 흑백 , 갈샐 필터 적용
					// 흑백 먼저 필터 주고 갈색 주면 갈색이 안먹는다.
					// 갈색 먼저 처리하고 흑백...
					if( ImageManager.effectSepia[ii] )
					{
						filterCollector.setSepia( bbb );
					}
					if( ImageManager.effectGray[ii] )
					{
						filterCollector.setGray( bbb );
					}
					
					bbbd = bbb.bitmapData;
					if( bbbd != null )
					{
						// 오래된 효과 적용
						if( ImageManager.effectOld[ii] )
						{
							bbbd = filterCollector.backTotheFuture( bbbd );
						}
						// 화사한 효과 적용
						if( ImageManager.effectLuxury[ii] )
						{
							bbbd = filterCollector.luxury( bbbd );
						}
						// 로모 적용
						if( ImageManager.effectLomo[ii] > 0 )
						{
							bbbd = filterCollector.lomo( bbbd , ImageManager.effectLomo[ii] );
						}
					}
					
					bbb.bitmapData = bbbd;
				}
			}
		}
		private function topNaviBmSetWH( $mc:MovieClip , $bm:Bitmap ):void
		{
			//DisplayObjectUtils.removeChilds( $mc , 1 );
			if( $mc.numChildren == 3 )
			{
				$mc.removeChildAt( 1 );
			}
			$mc.addChildAt( $bm , 1 );
			$bm.width = Preset.EDIT_POP_TOPNAVI_WH[0];
			$bm.height = Preset.EDIT_POP_TOPNAVI_WH[1];
		}
		public function show( numb:Number = NaN , skinNumb:Number = NaN ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < ImageManager.origImgArr.length ; ii++ )
			{
				ImageManager.positionXDummy[ii] = ImageManager.positionX[ii];
				ImageManager.positionYDummy[ii] = ImageManager.positionY[ii];
				ImageManager.rotateVDummy[ii] = ImageManager.rotateV[ii];
				ImageManager.isVerticalDummy[ii] = ImageManager.isVertical[ii];
				ImageManager.effectSepiaDummy[ii] = ImageManager.effectSepia[ii];
				ImageManager.effectGrayDummy[ii] = ImageManager.effectGray[ii];
				ImageManager.effectOldDummy[ii] = ImageManager.effectOld[ii];
				ImageManager.effectLuxuryDummy[ii] = ImageManager.effectLuxury[ii];
				ImageManager.effectLomoDummy[ii] = ImageManager.effectLomo[ii];
				ImageManager.effectBrightnessDummy[ii] = ImageManager.effectBrightness[ii];
				ImageManager.effectContrastDummy[ii] = ImageManager.effectContrast[ii];
				
				bmList[ii] = ImageUtils.duplicateImage( ImageManager.origImgArr[ii] );
			}
			
			bitmapSet();
			if( ImageManager.origImgArr.length )
			{
				numb = 0;	// 무조건 젤첫번째 이미지 띄운다.
			}
			this.skinNumb = skinNumb;
			stageInit( numb , true );
			
			DisplayObjectUtils.removeChilds( editClip.canvas , 1 );
			DisplayObjectUtils.removeChilds( bmBox );
			wrapperRemove();
			componentsEffectSet();
			if( !isNaN( numb ) )
			{
				wrapperSet();
			}
			
			editClip.y = 0;
		}
		public function hide():void
		{
			editClip.y = -editClip.height;
			dispatchEvent( new Event( Preset.EVENT_STR_EDITPOP_CLOSE ) );
		}
		
		private function closeClick( e:MouseEvent ):void
		{
			hide();
			numb = NaN;
		}
		private function saveClick( e:MouseEvent ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < ImageManager.origImgArr.length ; ii++ )
			{
				var bm:Bitmap = ImageUtils.duplicateImage( bmList[ii] );
				bm.width = bmList[numb].width;
				bm.height = bmList[numb].height;
				
				var inData:EventInDataClass = new EventInDataClass( ii , bm );
				inData.rotate = ImageManager.rotateVDummy[ii];
				inData.positionX = ImageManager.positionXDummy[ii];
				inData.positionY = ImageManager.positionYDummy[ii];
				inData.effectGray = ImageManager.effectGrayDummy[ii];
				inData.effectSepia = ImageManager.effectSepiaDummy[ii];
				inData.effectOld = ImageManager.effectOldDummy[ii];
				inData.effectLuxury = ImageManager.effectLuxuryDummy[ii];
				inData.effectLomo = ImageManager.effectLomoDummy[ii];
				inData.effectBrightness = ImageManager.effectBrightnessDummy[ii];
				inData.effectContrast = ImageManager.effectContrastDummy[ii];
				if( ii == ImageManager.origImgArr.length - 1 )
				{
					inData.isFinal = true;
				} else {
					inData.isFinal = false;
				}
				dispatchEvent( new EventInData( inData , "imgEditSet" ) );
			}
		}
		private function topNaviItemClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var ii:Number = e.currentTarget.name.replace( Preset.EDIT_POP_TOPNAVI_PREFIX , "" ) ;
			numb = ii;
			topNaviAngleSet();
			bmBox.rotation = rotationTy ;
			canvasInit();
			componentsEffectSet();
			if( !isNaN( numb ) )
			{
				wrapperSet();
			}
		}
		private function topNaviAngleSet():void
		{
			for( var ii:Number = 0 ; ii < ImageManager.origImgArr.length ; ii ++ )
			{
				var _mc:MovieClip = ( topNaviBox.getChildByName( Preset.EDIT_POP_TOPNAVI_PREFIX + ii ) as MovieClip ).focus as MovieClip;
				if( numb == ii )
				{
					_mc.gotoAndStop( 2 );
				} else {
					_mc.gotoAndStop( 1 );
				}
			}
		}
		
		private function sliderbarBrightnessChange( e:EventInData ):void
		{
			brightnessRate = e.data as Number;
		}
		private function sliderbarContrastChange( e:EventInData ):void
		{
			contrastRate = e.data as Number;
		}
		private function scrollMinusClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x - _parent.pointer.width;
			if( mvX < _mc.x + _mc.width / 2 + _parent.pointer.width / 2 )
				mvX = _mc.x + _mc.width / 2 + _parent.pointer.width / 2;				
			_parent.pointer.x = mvX;
		}
		private function scrollPlusClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x + _parent.pointer.width;
			if( mvX > _mc.x - _mc.width / 2 - _parent.pointer.width / 2 )
				mvX = _mc.x - _mc.width / 2 - _parent.pointer.width / 2;				
			_parent.pointer.x = mvX;
		}
		private function scrollPointerDown( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			
			var rect:Rectangle = new Rectangle( _parent.btnMinus.x + _parent.btnMinus.width / 2 + _mc.width / 2 , _mc.y , _parent.btnPlus.x - _parent.btnMinus.x - _parent.btnMinus.width - _mc.width , 0 );
			_mc.startDrag( false , rect );
		}
		private function stageMouseUp( e:MouseEvent ):void
		{
			brightnessRate = sliderbarBrightness.rate;
			sliderbarBrightness.stopDrag();
			contrastRate = sliderbarContrast.rate;
			sliderbarContrast.stopDrag();
			canvasWrapAngle.stopDrag();
			if( !isNaN( numb ) )
			{
				effectInit( false );
			}
		}
		
		private function angleDown( e:MouseEvent ):void
		{
			var rect:Rectangle = new Rectangle( editClip.canvas.x + ( editClip.canvas.width - editClip.canvas.getChildByName( "bmBox" ).width ) / 2 + angleWH[0] / 2 , editClip.canvas.y + ( editClip.canvas.height - editClip.canvas.getChildByName( "bmBox" ).height ) / 2 + angleWH[1] / 2 , editClip.canvas.getChildByName( "bmBox" ).width - angleWH[0] , editClip.canvas.getChildByName( "bmBox" ).height - angleWH[1] );
			( e.currentTarget as MovieClip ).startDrag( false , rect );
		}
		
		// canvas wrapper create
		// isOriginal : true 이면   0,0 으로   false 이면 저장된 위치로 wrapSet
		private function wrapperSet( isOriginal:Boolean = false ):void
		{
			wrapperRemove();
			
			if( numb < 5 )
			{
				var _width:Number;
				var _height:Number;

				switch( numb )
				{
					case 0 :
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).mainBox.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).mainBox.height;
						break;
					case 1 :
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox1.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox1.height;
						break;
					case 2 :
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox2.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox2.height;
						break;
					case 3 :
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox3.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox3.height;
						break;
					case 4 :
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox4.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).subBox4.height;
						break;
				}
				
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				var vect:Vector.<Number> = ImageUtils.getThumbWH( canvasWrapAngleRect , editClip.canvas , "max" , true );
				
				_width = vect[0];
				_height = vect[1];
				canvasWrapAngleRect.graphics.clear();
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				vect = ImageUtils.getThumbWH( canvasWrapAngleRect , editClip.canvas.getChildAt( editClip.canvas.numChildren - 1 ) );
				
				_width = vect[0];
				_height = vect[1];
				canvasWrapAngleRect.graphics.clear();
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				canvasWrapAngleRect.x = -_width / 2;
				canvasWrapAngleRect.y = -_height / 2;
				
				angleWH[0] = _width;
				angleWH[1] = _height;
				canvasWrapAngle.x = editClip.canvas.x + editClip.canvas.width / 2;
				canvasWrapAngle.y = editClip.canvas.y + editClip.canvas.height / 2;
				canvasWrapAngle.alpha = 0.4;
				
				// top mc
				canvasWrapAngle.graphics.beginFill( 0x000000 );
				canvasWrapAngle.graphics.drawRect( -Preset.EDIT_POP_CANVAS_WRAP_WHXY[0]/2 , -Preset.EDIT_POP_CANVAS_WRAP_WHXY[1]/2 , Preset.EDIT_POP_CANVAS_WRAP_WHXY[0] , ( Preset.EDIT_POP_CANVAS_WRAP_WHXY[1] - _height ) / 2 );
				canvasWrapAngle.graphics.drawRect( -Preset.EDIT_POP_CANVAS_WRAP_WHXY[0]/2 , -_height/2 , ( Preset.EDIT_POP_CANVAS_WRAP_WHXY[0] - _width ) / 2 , _height );
				canvasWrapAngle.graphics.drawRect( _width/2 , -_height/2 , ( Preset.EDIT_POP_CANVAS_WRAP_WHXY[0] - _width ) / 2 , _height );
				canvasWrapAngle.graphics.drawRect( -Preset.EDIT_POP_CANVAS_WRAP_WHXY[0]/2 , _height/2 , Preset.EDIT_POP_CANVAS_WRAP_WHXY[0] , ( Preset.EDIT_POP_CANVAS_WRAP_WHXY[1] - _height ) / 2 );
				canvasWrapAngle.graphics.endFill();
				
				if( !isOriginal )
				{
					if( !isNaN( ImageManager.positionX[numb] ) ) {
						canvasWrapAngle.x += ( editClip.canvas.getChildByName( "bmBox" ).width - angleWH[0] ) * ImageManager.positionXDummy[numb];
					}
					if( !isNaN( ImageManager.positionY[numb] ) ) {
						canvasWrapAngle.y += ( editClip.canvas.getChildByName( "bmBox" ).height - angleWH[1] ) * ImageManager.positionYDummy[numb];
					}
				}
			}
		}
		private function wrapperRemove():void
		{
			canvasWrapAngleRect.graphics.clear();
			canvasWrapAngle.graphics.clear();
		}
			
		private function canvasInit():void
		{
			if( !isNaN( numb ) )
			{
				bmBox.name = "bmBox";
				DisplayObjectUtils.removeChilds( editClip.canvas , 1 );
				DisplayObjectUtils.removeChilds( bmBox );
				editClip.canvas.addChild( bmBox );
				bmBox.rotation = rotationTy;
				bmBox.x = editClip.canvas.width / 2;
				bmBox.y = editClip.canvas.height / 2;
				
				bmList[numb] = ImageUtils.duplicateImage( ImageManager.origImgArr[numb] );
				bmBox.addChild( bmList[numb] );

				bitmapOrigWH[0] = bmList[numb].width;
				bitmapOrigWH[1] = bmList[numb].height;
				
				bitmapAddchild();
			}
		}
		
		// effect component reset
		private function componentsEffectSet():void
		{
			if( !isNaN(numb) )
			{
				isGray = ImageManager.effectGrayDummy[numb];
				isSepia = ImageManager.effectSepiaDummy[numb];
				isOld = ImageManager.effectOldDummy[numb];
				isLuxury = ImageManager.effectLuxuryDummy[numb];
				lomo = ImageManager.effectLomoDummy[numb];
				brightnessRate = ImageManager.effectBrightnessDummy[numb];
				contrastRate = ImageManager.effectContrastDummy[numb];
				rotationTy = ImageManager.rotateVDummy[numb];
				isVertical = ImageManager.isVerticalDummy[numb];
				positionX = ImageManager.positionXDummy[numb];
				positionY = ImageManager.positionYDummy[numb];
					
				if( isGray )
				{
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_GRAY_PREFIX ) as MovieClip ).gotoAndStop( 2 );
				} else {
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_GRAY_PREFIX ) as MovieClip ).gotoAndStop( 1 );
				}
				if( isSepia )
				{
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_SEPIA_PREFIX ) as MovieClip ).gotoAndStop( 2 );
				} else {
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_SEPIA_PREFIX ) as MovieClip ).gotoAndStop( 1 );
				}
				if( isOld )
				{
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_OLD_PREFIX ) as MovieClip ).gotoAndStop( 2 );
				} else {
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_OLD_PREFIX ) as MovieClip ).gotoAndStop( 1 );
				}
				if( isLuxury )
				{
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_LUXURY_PREFIX ) as MovieClip ).gotoAndStop( 2 );
				} else {
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_LUXURY_PREFIX ) as MovieClip ).gotoAndStop( 1 );
				}
				if( ImageManager.effectLomo[numb] > 0 )
				{
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_LOMO_PREFIX ) as MovieClip ).gotoAndStop( 2 );
				} else {
					( editClip.getChildByName( "btn" + Preset.EDIT_POP_LOMO_PREFIX ) as MovieClip ).gotoAndStop( 1 );
				}
				( editClip.getChildByName( Preset.EDIT_POP_LOMOBOX_NAME ) as ComboBox ).selectedIndex = Preset.EDIT_POP_LOMOBOX_DATA.indexOf( lomo );
				
				sliderbarBrightness.setPoint( brightnessRate );
				sliderbarContrast.setPoint( contrastRate );				
				
				effectInit();
			}
		}
		private function component1Reset( e:MouseEvent = null ):void
		{
			positionX = 0;
			positionY = 0;
			rotationTy = 0;
			isVertical = true;
			canvasWrapAngle.x = editClip.canvas.x + editClip.canvas.width / 2 ;
			canvasWrapAngle.y = editClip.canvas.y + editClip.canvas.height / 2 ;
			if( e != null )
			{
				effectInit();
				wrapperSet( true );
			}	
		}
		private function component2Reset( e:MouseEvent = null ):void
		{
			isGray = false;
			isSepia = false;
			isOld = false;
			isLuxury = false;
			lomo = 0;
			editClip.btnGray.gotoAndStop( 1 );
			editClip.btnSepia.gotoAndStop( 1 );
			editClip.btnOld.gotoAndStop( 1 );
			editClip.btnLuxury.gotoAndStop( 1 );
			editClip.btnLomo.gotoAndStop( 1 );
			( editClip.getChildByName( Preset.EDIT_POP_LOMOBOX_NAME ) as ComboBox ).selectedIndex = 0;
			if( e != null )
				effectInit();
		}
		private function component3Reset( e:MouseEvent = null ):void
		{
			sliderbarBrightness.reset();
			sliderbarContrast.reset();
			if( e != null )
				effectInit();
		}
		
		// rotation position 적용
		private function rotationLeftClick( e:MouseEvent ):void
		{
			isVertical = !isVertical;
			if( editClip.canvas.numChildren > 1 )
			{
				rotationTyRotate( false );
				editClip.canvas.getChildByName( "bmBox" ).rotation = rotationTy;
				effectInit();
				wrapperSet();
			}
			
		}
		private function rotationRightClick( e:MouseEvent ):void
		{
			isVertical = !isVertical;
			if( editClip.canvas.numChildren > 1 )
			{
				rotationTyRotate( true );
				editClip.canvas.getChildByName( "bmBox" ).rotation = rotationTy;
				effectInit();
				wrapperSet();
			}
		}
		
		// filter 효과
		private function effectClick( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var currentFrame:Number = ( _mc ).currentFrame;
			
			if( currentFrame == 1 )
			{
				_mc.gotoAndStop( 2 );
				switch( _mc.name )
				{
					case "btn" + Preset.EDIT_POP_GRAY_PREFIX :
						isGray = true;
						break;
					case "btn" + Preset.EDIT_POP_SEPIA_PREFIX :
						isSepia = true;
						break;
					case "btn" + Preset.EDIT_POP_OLD_PREFIX :
						isOld = true;
						break;
					case "btn" + Preset.EDIT_POP_LUXURY_PREFIX :
						isLuxury = true;
						break;
					case "btn" + Preset.EDIT_POP_LOMO_PREFIX :
						lomo = Preset.EDIT_POP_LOMOBOX_DATA[ lomoBox.selectedIndex ];
						break;
				}
			} else if ( currentFrame == 2 )
			{
				_mc.gotoAndStop( 1 );
				switch( _mc.name )
				{
					case "btn" + Preset.EDIT_POP_GRAY_PREFIX :
						isGray = false;
						break;
					case "btn" + Preset.EDIT_POP_SEPIA_PREFIX :
						isSepia = false;
						break;
					case "btn" + Preset.EDIT_POP_OLD_PREFIX :
						isOld = false;
						break;
					case "btn" + Preset.EDIT_POP_LUXURY_PREFIX :
						isLuxury = false;
						break;
					case "btn" + Preset.EDIT_POP_LOMO_PREFIX :
						lomo = 0;
						break;
				}
			}
			effectInit();
		}
		
		private function comboboxSelected( e:Event ):void
		{
			var _combobox:ComboBox = e.currentTarget as ComboBox;
			lomo = Preset.EDIT_POP_LOMOBOX_DATA[ _combobox.selectedIndex ];
			effectInit();
		}
		private function effectInit( isTopInit:Boolean = true ):void
		{
			canvasInit();
			
			// 밝기  정도 적용
			var brightnessRate:Number = this.brightnessRate * 2 - 100;
			// 대비 정도 적용
			var contrastRate:Number = this.contrastRate * 2 - 100;
			
			colorMatrix.reset();
			colorMatrix.adjustColor( brightnessRate , contrastRate , 0 , 0 );
			bmList[numb].filters = [ new ColorMatrixFilter( colorMatrix ) ];
			
			// 흑백 , 갈샐 필터 적용
			// 흑백 먼저 필터 주고 갈색 주면 갈색이 안먹는다.
			// 갈색 먼저 처리하고 흑백...
			if( isSepia )
			{
				filterCollector.setSepia( bmList[numb] );
			}
			if( isGray )
			{
				filterCollector.setGray( bmList[numb] );
			}
			
			bd = bmList[numb].bitmapData;
			if( bd != null )
			{
				// 오래된 효과 적용
				if( isOld )
				{
					bd = filterCollector.backTotheFuture( bd );
				}
				// 화사한 효과 적용
				if( isLuxury )
				{
					bd = filterCollector.luxury( bd );
				}
				// 로모 적용
				if( lomo > 0 )
				{
					bd = filterCollector.lomo( bd , lomo );
				}
			}
			bmList[numb].bitmapData = bd;
			
			
			var bbMc:MovieClip = topNaviBox.getChildByName( Preset.EDIT_POP_TOPNAVI_PREFIX + numb ) as MovieClip;
			var bb:Bitmap = ImageUtils.duplicateImage( ImageManager.origImgArr[numb] );
			topNaviBmSetWH( bbMc , bb );
			
			if( bb != null )
			{
				bb.filters = [ new ColorMatrixFilter( colorMatrix ) ];
				
				// 흑백 , 갈샐 필터 적용
				// 흑백 먼저 필터 주고 갈색 주면 갈색이 안먹는다.
				// 갈색 먼저 처리하고 흑백...
				if( isSepia )
				{
					filterCollector.setSepia( bb );
				}
				if( isGray )
				{
					filterCollector.setGray( bb );
				}
				
				bbd = bb.bitmapData;
				if( bbd != null )
				{
					// 오래된 효과 적용
					if( isOld )
					{
						bbd = filterCollector.backTotheFuture( bbd );
					}
					// 화사한 효과 적용
					if( isLuxury )
					{
						bbd = filterCollector.luxury( bbd );
					}
					// 로모 적용
					if( lomo > 0 )
					{
						bbd = filterCollector.lomo( bbd , lomo );
					}
				}
				
				bb.bitmapData = bbd;
			}
			
			if( !isTopInit )
			{
				ImageManager.positionXDummy[numb] = getPosition(true);
				ImageManager.positionYDummy[numb] = getPosition(false);
				ImageManager.rotateVDummy[numb] = rotationTy;
				ImageManager.isVerticalDummy[numb] = getIsVertical( rotationTy );
				ImageManager.effectSepiaDummy[numb] = isSepia;
				ImageManager.effectGrayDummy[numb] = isGray;
				ImageManager.effectOldDummy[numb] = isOld;
				ImageManager.effectLuxuryDummy[numb] = isLuxury;
				ImageManager.effectLomoDummy[numb] = lomo;
				ImageManager.effectBrightnessDummy[numb] = this.brightnessRate;
				ImageManager.effectContrastDummy[numb] = this.contrastRate;
			}	
		}
		private function getIsVertical( rotation:Number ):Boolean
		{
			var boo:Boolean;
			if( ( rotation / 90 ) % 2 == 0 )
			{
				boo = true;
			} else {
				boo = false;
			}
			return boo;
		}
		private function bitmapAddchild():void
		{
			var vc:Vector.<Number> = ImageUtils.getThumbWH( editClip.canvas.getChildByName( "bmBox" ) , editClip.canvas.getChildAt(0) );
			if( ( ( rotationTy / 90 ) % 2 ) == 0 )
			{
				bmList[numb].width = vc[0];
				bmList[numb].height = vc[1];
			} else if( ( ( rotationTy / 90 ) % 2 ) == 1 ) {
				bmList[numb].width = vc[1];
				bmList[numb].height = vc[0];
			} else {
			}
			bmList[numb].x = -bmList[numb].width / 2;
			bmList[numb].y = -bmList[numb].height / 2;
		}
		private function rotationTyRotate( boo:Boolean ):void
		{
			if( !boo )
			{
				rotationTy -= 90;
			} else {
				rotationTy += 90;
			}
			if( rotationTy < 0 )
			{
				rotationTy += 360;
			} else if ( rotationTy >= 360 ) {
				rotationTy -= 360;
			}
			ImageManager.rotateVDummy[numb] = rotationTy;
		}
		
		private function getPosition( boo:Boolean = true ):Number
		{
			var __width:Number;
			var __height:Number;
			var movable:Number;
			var x:Number;
			var y:Number;
			
			if( isVertical )
			{
				__width = bmBox.getChildAt(0).width;
				__height = bmBox.getChildAt(0).height;
			} else {
				__width = bmBox.getChildAt(0).height;
				__height = bmBox.getChildAt(0).width;
			}
			
			if( boo ) // true 이면 x 좌표
			{
				// [ 시작점( canvas.x + canvas.width / 2 ) 에서 이동된 좌표 간 거리 ] / [ 이동 가능한 거리 ( bitmap.width - canvasWrapAngleRect.width ) ]
				movable =  __width - canvasWrapAngleRect.width;
				if( movable != 0 )
				{
					x = MathUtils.round( ( canvasWrapAngle.x - ( editClip.canvas.x + editClip.canvas.width / 2 ) ) / movable , 2 );
				} else {
					x = 0;
				}
				return x;
			} else {	// false 이면 y 좌표
				movable = __height - canvasWrapAngleRect.height;
				if( movable != 0 )
				{
					y = MathUtils.round( ( canvasWrapAngle.y - ( editClip.canvas.y + editClip.canvas.height / 2 ) ) / movable , 2 );
				} else {
					y = 0;
				}
				return y;
			}
		}
	}
}