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
		private var b:Bitmap = new Bitmap;
		private var bOriginal:Bitmap = new Bitmap;
		private var bitmapOrigWH:Vector.<Number> = new Vector.<Number>;
		private var bd:BitmapData;
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
			trace( "setDefualt" );
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
			editClip.getChildByName( "btn" + Preset.EDIT_POP_GRAY_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_SEPIA_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_OLD_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_LUXURY_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( "btn" + Preset.EDIT_POP_LOMO_PREFIX ).addEventListener( MouseEvent.CLICK , effectClick );
			editClip.getChildByName( Preset.EDIT_POP_LOMOBOX_NAME ).addEventListener( Event.CHANGE , comboboxSelected );
			sliderbarBrightness.addEventListener( SliderBar.CHANGE , sliderbarBrightnessChange );
			sliderbarContrast.addEventListener( SliderBar.CHANGE , sliderbarContrastChange );
			this.addEventListener( MouseEvent.MOUSE_UP , stageMouseUp );
			editClip.btnReset1.addEventListener( MouseEvent.CLICK , component1Reset );
			editClip.btnReset2.addEventListener( MouseEvent.CLICK , component2Reset );
			editClip.btnReset3.addEventListener( MouseEvent.CLICK , component3Reset );
			canvasWrapAngle.addEventListener( MouseEvent.MOUSE_DOWN , angleDown );
		}
		
		public function stageInit( numb:Number = NaN , isFirst:Boolean = true ):void
		{
			//trace("eidtInit start!111111111!! , numb , isFirst " , numb , isFirst );
			//trace( ImageManager.thumbArr.length );
			//trace( ImageManager.thumbArr );
			if( !isNaN( numb ) )
			{
				this.numb = numb;
			}
			
			this.isFirst = isFirst;
			if( isFirst )
			{
				bitmapSet();
			}
			dispatchEvent( new EventInData( Preset.EDIT_POP_CLASS_STRING , Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		}
		public function bitmapSet():void
		{
			DisplayObjectUtils.removeChilds( topNaviBox );
			
			for( var ii :Number = 0 ; ii < ImageManager.thumbArr.length ; ii++ )
			{
				var mc:MovieClip = new MovieClip();
				var b:Bitmap = ImageUtils.duplicateImage( ImageManager.thumbArr[ii] );
				mc.name = Preset.EDIT_POP_TOPNAVI_PREFIX + ii;
				mc.addChild( b );
				b.width = Preset.EDIT_POP_TOPNAVI_WH[0];
				b.height = Preset.EDIT_POP_TOPNAVI_WH[1];
				mc.x = ( Preset.EDIT_POP_TOPNAVI_WH[0] + Preset.EDIT_POP_TOPNAVI_GAP ) * ii;
				mc.addEventListener( MouseEvent.CLICK , topNaviItemClick );
				topNaviBox.addChild( mc );
			}
		}
		public function show( numb:Number = NaN , skinNumb:Number = NaN ):void
		{
			trace(" edit pop show! numb : " + numb );
			this.numb = numb;
			this.skinNumb = skinNumb;
			stageInit( numb , true );
			//canvasInit();
			
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
		}
		
		private function closeClick( e:MouseEvent ):void
		{
			//trace( "close btn click" );
			hide();
			numb = NaN;
		}
		private function saveClick( e:MouseEvent ):void
		{
			trace("saveClick!");
			
			//trace( bitmapOrigWH );
			var bm:Bitmap = ImageUtils.duplicateImage( b );
			//trace( bm.width , bm.height );
			bm.width = bitmapOrigWH[0];
			bm.height = bitmapOrigWH[1];
			var inData:EventInDataClass = new EventInDataClass( numb , bm );
			inData.rotate = rotationTy;
			inData.positionX = getPosition( true );
			inData.positionY = getPosition( false );
			inData.effectGray = isGray;
			inData.effectSepia = isSepia;
			inData.effectOld = isOld;
			inData.effectLuxury = isLuxury;
			inData.effectLomo = lomo;
			inData.effectBrightness = brightnessRate;
			inData.effectContrast = contrastRate;
			
			dispatchEvent( new EventInData( inData , "imgEditSet" ) );
		}
		private function topNaviItemClick( e:MouseEvent ):void
		{
			//trace("topNaviItemClick" );
			var ii:Number = e.currentTarget.name.replace( Preset.EDIT_POP_TOPNAVI_PREFIX , "" ) ;
			numb = ii;
			bmBox.rotation = rotationTy ;//= 0;
			canvasInit();
			componentsEffectSet();
			if( !isNaN( numb ) )
			{
				wrapperSet();
			}
		}
		
		private function sliderbarBrightnessChange( e:EventInData ):void
		{
			//trace("sliderbarBrightnessChange e.data : " + e.data );
			brightnessRate = e.data as Number;
		}
		private function sliderbarContrastChange( e:EventInData ):void
		{
			//trace("sliderbarContrastRateChange e.data : " + e.data );
			contrastRate = e.data as Number;
		}
		private function scrollMinusClick( e:MouseEvent ):void
		{
			//trace( "scrollMinusClick" );
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x - _parent.pointer.width;
			if( mvX < _mc.x + _mc.width / 2 + _parent.pointer.width / 2 )
				mvX = _mc.x + _mc.width / 2 + _parent.pointer.width / 2;				
			_parent.pointer.x = mvX;
		}
		private function scrollPlusClick( e:MouseEvent ):void
		{
			//trace( "scrollPlusClick" );
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			var mvX:Number = _parent.pointer.x + _parent.pointer.width;
			if( mvX > _mc.x - _mc.width / 2 - _parent.pointer.width / 2 )
				mvX = _mc.x - _mc.width / 2 - _parent.pointer.width / 2;				
			_parent.pointer.x = mvX;
		}
		private function scrollPointerDown( e:MouseEvent ):void
		{
			//trace( "scrollPointerDown" );
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _parent:MovieClip = _mc.parent as MovieClip;
			
			var rect:Rectangle = new Rectangle( _parent.btnMinus.x + _parent.btnMinus.width / 2 + _mc.width / 2 , _mc.y , _parent.btnPlus.x - _parent.btnMinus.x - _parent.btnMinus.width - _mc.width , 0 );
			_mc.startDrag( false , rect );
		}
		private function stageMouseUp( e:MouseEvent ):void
		{
			trace("stageMouseUp");
			brightnessRate = sliderbarBrightness.rate;
			sliderbarBrightness.stopDrag();
			contrastRate = sliderbarContrast.rate;
			sliderbarContrast.stopDrag();
			canvasWrapAngle.stopDrag();
			effectInit();
		}
		
		private function angleDown( e:MouseEvent ):void
		{
			//var rect:Rectangle = new Rectangle( editClip.canvas.x + angleWH[0] / 2 , editClip.canvas.y + angleWH[1] / 2 , wrapMask.width - angleWH[0] , wrapMask.height - angleWH[1] );
			var rect:Rectangle = new Rectangle( editClip.canvas.x + ( editClip.canvas.width - editClip.canvas.getChildByName( "bmBox" ).width ) / 2 + angleWH[0] / 2 , editClip.canvas.y + ( editClip.canvas.height - editClip.canvas.getChildByName( "bmBox" ).height ) / 2 + angleWH[1] / 2 , editClip.canvas.getChildByName( "bmBox" ).width - angleWH[0] , editClip.canvas.getChildByName( "bmBox" ).height - angleWH[1] );
			( e.currentTarget as MovieClip ).startDrag( false , rect );
			
			// 이동 거리 / 이동 가능한 거리 
			// 이동 거리 = ( 중심점.x - 이동한.x )
			trace( "move rate : " , ( editClip.getChildByName( "angleWrapper" ).x - ( editClip.canvas.width / 2 + editClip.canvas.x ) ) / (  editClip.canvas.getChildByName( "bmBox" ).width - angleWH[0] ) );
			/*
			trace( editClip.getChildByName( "angleWrapper" ).x );
			trace( editClip.getChildByName( "angleWrapper" ).width );
			trace( editClip.canvas.getChildByName( "bmBox" ).x );
			trace( editClip.canvas.getChildByName( "bmBox" ).width );
			trace( ( editClip.getChildByName( "angleWrapper" ) as MovieClip ).getChildByName( "canvasWrapAngleRect" ).x );
			trace( ( editClip.getChildByName( "angleWrapper" ) as MovieClip ).getChildByName( "canvasWrapAngleRect" ).y );
			*/
		}
		
		// canvas wrapper create
		// isOriginal : true 이면   0,0 으로   false 이면 저장된 위치로 wrapSet
		private function wrapperSet( isOriginal:Boolean = false ):void
		{
			canvasWrapAngle.graphics.clear();
			canvasWrapAngleRect.graphics.clear();
			if( numb < 5 )
			{
				var _width:Number;
				var _height:Number;

				switch( numb )
				{
					case 0 :
						//trace("case 1 ");
						_width = ( SkinManager.skinBody[skinNumb] as MovieClip ).mainBox.width;
						_height = ( SkinManager.skinBody[skinNumb] as MovieClip ).mainBox.height;
						break;
					case 1 :
						//trace("case 2 ");
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
				//trace( _width , _height );
				
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				var vect:Vector.<Number> = ImageUtils.getThumbWH( canvasWrapAngleRect , editClip.canvas , "max" , true );
				//trace("vect : " , vect );
				
				_width = vect[0];
				_height = vect[1];
				canvasWrapAngleRect.graphics.clear();
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				vect = ImageUtils.getThumbWH( canvasWrapAngleRect , editClip.canvas.getChildAt( editClip.canvas.numChildren - 1 ) );
				//trace("vect2 : " , vect );
				
				_width = vect[0];
				_height = vect[1];
				canvasWrapAngleRect.graphics.clear();
				canvasWrapAngleRect.graphics.beginFill( 0xFF0000 , 0 );
				canvasWrapAngleRect.graphics.drawRect( 0 , 0 ,_width , _height );
				canvasWrapAngleRect.graphics.endFill();
				canvasWrapAngleRect.x = -_width / 2;
				canvasWrapAngleRect.y = -_height / 2;
				
				//_width = editClip.canvas.getChildByName( Preset.EDIT_POP_CANVAS_IMAGE_PREFIX ).width;
				//_height = editClip.canvas.getChildByName( Preset.EDIT_POP_CANVAS_IMAGE_PREFIX ).height;
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
						canvasWrapAngle.x += ( editClip.canvas.getChildByName( "bmBox" ).width - angleWH[0] ) * ImageManager.positionX[numb];
					}
					if( !isNaN( ImageManager.positionY[numb] ) ) {
						canvasWrapAngle.y += ( editClip.canvas.getChildByName( "bmBox" ).height - angleWH[1] ) * ImageManager.positionY[numb];
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
			//trace( "canvasInit!!!" );
			if( !isNaN( numb ) )
			{
				//trace("numb!!!" , numb );
				
				bmBox.name = "bmBox";
				DisplayObjectUtils.removeChilds( editClip.canvas , 1 );
				DisplayObjectUtils.removeChilds( bmBox );
				editClip.canvas.addChild( bmBox );
				bmBox.rotation = rotationTy;
				bmBox.x = editClip.canvas.width / 2;
				bmBox.y = editClip.canvas.height / 2;
				
				b = ImageUtils.duplicateImage( ImageManager.origImgArr[numb] );
				bmBox.addChild( b );
								
				bitmapOrigWH[0] = b.width;
				bitmapOrigWH[1] = b.height;
				
				bitmapAddchild();
				
				//b.name = Preset.EDIT_POP_CANVAS_IMAGE_PREFIX;
			}
		}
		
		// effect component reset
		private function componentsEffectSet():void
		{
			trace( "componentsEffectSet" , numb );
			
			if( !isNaN(numb) )
			{
				isGray = ImageManager.effectGray[numb];
				isSepia = ImageManager.effectSepia[numb];
				isOld = ImageManager.effectOld[numb];
				isLuxury = ImageManager.effectLuxury[numb];
				lomo = ImageManager.effectLomo[numb];
				brightnessRate = ImageManager.effectBrightness[numb];
				contrastRate = ImageManager.effectContrast[numb];
				rotationTy = ImageManager.rotateV[numb];
				isVertical = ImageManager.isVertical[numb];
				positionX = ImageManager.positionX[numb];
				positionY = ImageManager.positionY[numb];
					
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
				
				//component1Reset();
				//component2Reset();
				//component3Reset();
				effectInit();
			}
		}
		private function component1Reset( e:MouseEvent = null ):void
		{
			//ImageManager.positionX[numb] = positionX = 0;
			//ImageManager.positionY[numb] = positionY = 0;
			//ImageManager.rotateV[numb] = rotationTy = 0;
			positionX = 0;
			positionY = 0;
			rotationTy = 0;
			isVertical = true;
			canvasWrapAngle.x = editClip.canvas.x + editClip.canvas.width / 2 ;
			canvasWrapAngle.y = editClip.canvas.y + editClip.canvas.height / 2 ;
			if( e != null )
			{
				trace( 'e != null' );
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
						//trace( 'gray Click!');
						break;
					case "btn" + Preset.EDIT_POP_SEPIA_PREFIX :
						//trace( 'sepia Click!');
						isSepia = true;
						break;
					case "btn" + Preset.EDIT_POP_OLD_PREFIX :
						//trace( 'old Click!');
						isOld = true;
						break;
					case "btn" + Preset.EDIT_POP_LUXURY_PREFIX :
						//trace( 'luxury Click!');
						isLuxury = true;
						break;
					case "btn" + Preset.EDIT_POP_LOMO_PREFIX :
						//trace( 'lomo Click!');
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
						//trace( 'gray Click!');
						break;
					case "btn" + Preset.EDIT_POP_SEPIA_PREFIX :
						//trace( 'sepia Click!');
						isSepia = false;
						break;
					case "btn" + Preset.EDIT_POP_OLD_PREFIX :
						//trace( 'old Click!');
						isOld = false;
						break;
					case "btn" + Preset.EDIT_POP_LUXURY_PREFIX :
						//trace( 'luxury Click!');
						isLuxury = false;
						break;
					case "btn" + Preset.EDIT_POP_LOMO_PREFIX :
						//trace( 'lomo Click!');
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
		private function effectInit():void
		{
			canvasInit();
			
			// 밝기  정도 적용
			var brightnessRate:Number = this.brightnessRate * 2 - 100;
			// 대비 정도 적용
			var contrastRate:Number = this.contrastRate * 2 - 100;
			
			//trace( "colorMatrix.adjustColor!! : " , brightnessRate , contrastRate );
			//colorMatrix.adjustColor( 0 , 0 , 0 , 0 );
			colorMatrix.reset();
			colorMatrix.adjustColor( brightnessRate , contrastRate , 0 , 0 );
			b.filters = [ new ColorMatrixFilter( colorMatrix ) ];
			
			// 흑백 , 갈샐 필터 적용
			// 흑백 먼저 필터 주고 갈색 주면 갈색이 안먹는다.
			// 갈색 먼저 처리하고 흑백...
			//if( ( editClip.getChildByName( "btn" + Preset.EDIT_POP_SEPIA_PREFIX ) as MovieClip ).currentFrame == 2 )
			if( isSepia )
			{
				filterCollector.setSepia( b );
			}
			//if( ( editClip.getChildByName( "btn" + Preset.EDIT_POP_GRAY_PREFIX ) as MovieClip ).currentFrame == 2 )
			if( isGray )
			{
				filterCollector.setGray( b );
			}
			
			bd = b.bitmapData;
			if( bd != null )
			{
				// 오래된 효과 적용
				//if( ( editClip.getChildByName( "btn" + Preset.EDIT_POP_OLD_PREFIX ) as MovieClip ).currentFrame == 2 )
				if( isOld )
				{
					bd = filterCollector.backTotheFuture( bd );
				}
				
				// 화사한 효과 적용
				//if( ( editClip.getChildByName( "btn" + Preset.EDIT_POP_LUXURY_PREFIX ) as MovieClip ).currentFrame == 2 )
				if( isLuxury )
				{
					bd = filterCollector.luxury( bd );
				}
				// 로모 적용
				//if( ( editClip.getChildByName( "btn" + Preset.EDIT_POP_LOMO_PREFIX ) as MovieClip ).currentFrame == 2 )
				if( lomo > 0 )
				{
					//bd = filterCollector.lomo( bd , Preset.EDIT_POP_LOMOBOX_DATA[ lomoBox.selectedIndex ] );
					bd = filterCollector.lomo( bd , lomo );
				}
			}
			
			b.bitmapData = bd;
			
		}
		private function bitmapAddchild():void
		{
			var vc:Vector.<Number> = ImageUtils.getThumbWH( editClip.canvas.getChildByName( "bmBox" ) , editClip.canvas.getChildAt(0) );
			//trace( "bitmapAddchild : " , vc );
			if( ( ( rotationTy / 90 ) % 2 ) == 0 )
			{
				//trace(" rotation 0 180 " );
				b.width = vc[0];
				b.height = vc[1];
			} else if( ( ( rotationTy / 90 ) % 2 ) == 1 ) {
				//trace(" rotation 90 270 " );
				b.width = vc[1];
				b.height = vc[0];
			} else {
				//trace(" rotation?? " , rotationTy );
			}
			b.x = -b.width / 2;
			b.y = -b.height / 2;
			
			// effect set
			
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
		}
		
		private function getPosition( boo:Boolean = true ):Number
		{
			trace( bmBox.getChildAt(0).width , bmBox.getChildAt(0).height );
			trace( canvasWrapAngleRect.width , canvasWrapAngleRect.height );
			trace( canvasWrapAngle.x , canvasWrapAngle.y );
			trace( editClip.canvas.x + editClip.canvas.width / 2 , editClip.canvas.y + editClip.canvas.height / 2 );
			
			trace( canvasWrapAngle.x - ( editClip.canvas.x + editClip.canvas.width / 2 ) );
			trace( canvasWrapAngleRect.width - bmBox.getChildAt(0).width );
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
				//trace( "x : " , x );
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