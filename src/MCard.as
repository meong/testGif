package
{
	import caurina.transitions.Tweener;
	
	import com.fwang.events.EventInData;
	import com.fwang.events.XMLLoaderEvent;
	import com.fwang.net.SingleImgLoader;
	import com.fwang.net.XMLLoader;
	import com.fwang.utils.JPEGEncoder;
	import com.mcard.Setting.Preset;
	import com.mcard.Stage01;
	import com.mcard.Stage02;
	import com.mcard.TopNavi;
	import com.mcard.ViewerItemEdit;
	import com.mcard.events.EventInDataClass;
	import com.mcard.manager.ImageGirlManager;
	import com.mcard.manager.ImageManManager;
	import com.mcard.manager.ImageManager;
	import com.mcard.manager.ImageTitleManager;
	import com.mcard.manager.MemberManager;
	import com.mcard.manager.SkinManager;
	import com.mcard.popup.CommonPop;
	import com.mcard.popup.EditPop;
	import com.mcard.popup.LoadingPop;
	import com.mcard.popup.PreviewPop;
	import com.mcard.popup.SavePop;
	import com.mcard.viewerItem;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF ( width="900" , height="700" , frameRate="36" , backgroundColor="0xBBBBBB" ) ]
	
	public class MCard extends Sprite
	{
		static public var xml:XML = new XML();
		private var encoder:JPEGEncoder = new JPEGEncoder( Preset.JPEG_QUALITY );
		private var bgImageClip:BackgroundImageClip = new BackgroundImageClip();
		private var loadingPop:LoadingPop = new LoadingPop();
		private var previewPop:PreviewPop = new PreviewPop();
		private var commonPop:CommonPop = new CommonPop();
		private var savePop:SavePop = new SavePop();
		private var viewerItemEdit:ViewerItemEdit = new ViewerItemEdit();
		private var editPop:EditPop = new EditPop();
		
		private var topNavi:TopNavi = new TopNavi();
		private var body01:Stage01 = new Stage01();
		private var body02:Stage02 = new Stage02();
		private var bodyBox:MovieClip = new MovieClip();
		private var bodyBoxMask:MovieClip = new MovieClip();
		
		private var xmlLoader:XMLLoader = new XMLLoader();
		private var imgManager:ImageManager = new ImageManager();
		private var skinManager:SkinManager = new SkinManager();
		private var titleManager:ImageTitleManager = new ImageTitleManager();
		private var manManager:ImageManManager = new ImageManManager();
		private var girlManager:ImageGirlManager = new ImageGirlManager();
		private var memberManager:MemberManager = new MemberManager();
		
		private var imgLoadStatus:Number = 0;
		private var swfLoadStatus:Number = 0;
		private var titleLoadStatus:Number = 0;
		private var manLoadStatus:Number = 0;
		private var girlLoadStatus:Number = 0;
		
		private var loaderVec:Vector.<LoaderInfo> = new Vector.<LoaderInfo>;
		private var loader1Vec:Vector.<Vector.<LoaderInfo>> = new Vector.<Vector.<LoaderInfo>>;
		private var loader2Vec:Vector.<Vector.<LoaderInfo>> = new Vector.<Vector.<LoaderInfo>>;
		private var loader3Vec:Vector.<Vector.<LoaderInfo>> = new Vector.<Vector.<LoaderInfo>>;
		
		private var isFirst:Boolean = true;
		private var isSkinMinCount:Boolean = false;
		private var isStepStatus:Number = 1;
		
		private var body01IsStageInit:Boolean = false;
		private var body02IsStageInit:Boolean = false;
		private var topNaviIsStageInit:Boolean = false;
		private var editPopIsStageInit:Boolean = false;
		private const SWF_LOAD_SPEAR:Number = 3;
		// debuger
		private var debuger:MonsterDebugger = new MonsterDebugger();
		
		public function MCard()
		{
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			addChild( bgImageClip );
			addChild( topNavi );
			addChild( bodyBox );
			addChild( bodyBoxMask );
			bodyBox.addChild( body01 );
			bodyBox.addChild( body02 );
			
			addChild( loadingPop );
			addChild( previewPop );
			addChild( commonPop );
			addChild( savePop );
			addChild( editPop );
		}
		private function setListener():void
		{
			xmlLoader.addEventListener( XMLLoaderEvent.XML_COMPLETE , loadComplete );
			
			body01.addEventListener( "next" , nextStep );
			body01.addEventListener( "preview" , previewShow1 );
			body01.addEventListener( Preset.EVENT_STR_SAVE_DOWN , savePopShow1 );
			body01.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			
			body02.addEventListener( "bodyGoPrev" , bodyGoPrev );
			body02.addEventListener( "preview" , previewShow2 );
			body02.addEventListener( Preset.EVENT_STR_SAVE_DOWN , savePopShow2 );
			body02.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			
			topNavi.addEventListener( "imgSet" , imgSet );
			topNavi.addEventListener( "editBtnClick" , imageEditShow );
			topNavi.addEventListener( Preset.COMMONPOP_SHOW_DISPATCH_STR , commonPopShow );
			topNavi.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			
			previewPop.addEventListener( Preset.COMMONPOP_SHOW_DISPATCH_STR , commonPopShow );
			previewPop.addEventListener( Preset.DISPATCH_GET_TEL , getTelNumber );
			
			editPop.addEventListener( "imgEditSet" , imgEditSet ); 
			editPop.addEventListener( Preset.DISPATCH_STAGEINIT_COMPLETE , stageInitComplete );
			editPop.addEventListener( Preset.EVENT_STR_EDITPOP_CLOSE , editPopClose );
			stage.addEventListener( MouseEvent.MOUSE_UP , stageMouseUp );
		}
		private function setDefault():void
		{
			topNavi.x = Preset.TOPNAVI_CLIP_XY[0];		topNavi.y = Preset.TOPNAVI_CLIP_XY[1];
			body01.x = Preset.BODY01_XY[0];				body01.y = Preset.BODY01_XY[1];
			body02.x = Preset.BODY02_XY[0];				body02.y = Preset.BODY02_XY[1];
			viewerItemEdit.x = Preset.EDIT_BODY[0];		viewerItemEdit.y = Preset.EDIT_BODY[1];
			
			bodyBoxMask.graphics.beginFill( 0xff0000 );
			bodyBoxMask.graphics.drawRect( 0 , 0 , Preset.BODYBOX_MASK_XYWH[2] , Preset.BODYBOX_MASK_XYWH[3] );
			bodyBoxMask.graphics.endFill();
			bodyBoxMask.x = Preset.BODYBOX_MASK_XYWH[0];
			bodyBoxMask.y = Preset.BODYBOX_MASK_XYWH[1];
			bodyBox.mask = bodyBoxMask;
			
			previewPop.hide();
			commonPop.hide();
			savePop.hide();
			editPop.hide();
			
			if( stage.loaderInfo.parameters.remoteXML )
			{
				MonsterDebugger.trace( this , stage.loaderInfo.parameters.remoteXML );
				xmlLoader.load( Preset.SITE_URL + stage.loaderInfo.parameters.remoteXML );
			} else {
				xmlLoader.load( Preset.SITE_URL + Preset.LOAD_URL );
			}
		}
		
		
		private function loadComplete( e:XMLLoaderEvent ):void
		{
			MonsterDebugger.trace( this , e.xml );
			xml = e.xml;
			var ii:Number;
			var jj:Number;
			var imgLoader:SingleImgLoader;
			var thumbLoader:SingleImgLoader;
			var lor:Loader;
			var titleLoader:SingleImgLoader;
			var manLoader:SingleImgLoader;
			var girlLoader:SingleImgLoader;
			
			// img manager set
			memberManager.setIsFirst( xml.isFirst[0].@value );
			if( MemberManager.isFirst != 1 )
			{
				for( ii = 0 ; ii < xml.isFirst[0].img.length() ; ii++ )
				{
					imgLoadStatus = imgLoadStatus + 2;
					imgLoader = new SingleImgLoader();
					thumbLoader = new SingleImgLoader();
					
					imgLoader.loaderSetup( Preset.SITE_URL + xml.isFirst[0].img[ii].@src , imgLoadSet , ii );
				}
				memberManager.setSkinIndex( xml.isFirst[0].skinIndex[0].@value );
				memberManager.setTitleIndex( xml.isFirst[0].title[0].@index );
				memberManager.setTitleX( xml.isFirst[0].title[0].@x );
				memberManager.setTitleY( xml.isFirst[0].title[0].@y );
				memberManager.setTitleAlpha( xml.isFirst[0].title[0].@alpha );
				memberManager.setTitleColor( xml.isFirst[0].title[0].@color );
				memberManager.setManIndex( xml.isFirst[0].man[0].@index );
				memberManager.setManX( xml.isFirst[0].man[0].@x );
				memberManager.setManY( xml.isFirst[0].man[0].@y );
				memberManager.setGirlIndex( xml.isFirst[0].girl[0].@index );
				memberManager.setGirlX( xml.isFirst[0].girl[0].@x );
				memberManager.setGirlY( xml.isFirst[0].girl[0].@y );
				memberManager.setTextfieldX( xml.isFirst[0].textfield[0].@x );
				memberManager.setTextfieldY( xml.isFirst[0].textfield[0].@y );
				memberManager.setTextfieldWidth( xml.isFirst[0].textfield[0].@width );
				memberManager.setTextfieldHeight( xml.isFirst[0].textfield[0].@height );
				memberManager.setTextfieldText( xml.isFirst[0].textfield[0] );
				var isFirstBgColor:Number = NaN;
				if( xml.isFirst[0].bg[0].@color != "" )
				{
					isFirstBgColor = xml.isFirst[0].bg[0].@color;
				}
				memberManager.setTextfieldBgColor( isFirstBgColor );
				memberManager.setTextfieldBgAlpha( xml.isFirst[0].bg[0].@alpha );
			}
			
			// skin manager set
			skinManager.length = xml.skin.length();
			if( skinManager.length < Preset.SKIN_MIN_COUNT )
			{
				isSkinMinCount = true;
				commonPop.show( Preset.COMMONPOP_SKIN_COUNT_ERROR );
				return void;
			} else {
				for ( ii = 0 ; ii < xml.skin.length() ; ii++ )
				{
					swfLoadStatus++;
					lor = new Loader();
					loaderVec[ii] = lor.contentLoaderInfo;
					lor.load( new URLRequest( Preset.SITE_URL + xml.skin[ii].@body ) );
					lor.contentLoaderInfo.addEventListener( Event.COMPLETE , swfLoadComplete );
				}
			}
			
			// title man girl swf load count set
			titleManager.setImgCnt( xml.title.length() + SWF_LOAD_SPEAR );
			manManager.setImgCnt( xml.title.length() + SWF_LOAD_SPEAR );
			girlManager.setImgCnt( xml.title.length() + SWF_LOAD_SPEAR );
			// title manager set
			for( ii = 0 ; ii < xml.title.length() ; ii++ )
			{
				loader1Vec[ii] = new Vector.<LoaderInfo>;
				for( jj = 0 ; jj <= xml.skin.length() + SWF_LOAD_SPEAR ; jj++ )
				{
					titleLoadStatus++;
					lor = new Loader();
					loader1Vec[ii][jj] = lor.contentLoaderInfo;
					lor.load( new URLRequest( Preset.SITE_URL + xml.title[ii].@src ) );
					lor.contentLoaderInfo.addEventListener( Event.COMPLETE , titleLoadSet );
				}
			}
			
			// man manager set
			for( ii = 0 ; ii < xml.man.length() ; ii++ )
			{
				loader2Vec[ii] = new Vector.<LoaderInfo>;
				for( jj = 0 ; jj <= xml.skin.length() + SWF_LOAD_SPEAR ; jj++ )
				{
					manLoadStatus++;
					lor = new Loader();
					loader2Vec[ii][jj] = lor.contentLoaderInfo;
					lor.load( new URLRequest( Preset.SITE_URL + xml.man[ii].@src ) );
					lor.contentLoaderInfo.addEventListener( Event.COMPLETE , manLoadSet );
				}
			}
			
			// girl manager set
			for( ii = 0 ; ii < xml.girl.length() ; ii++ )
			{
				loader3Vec[ii] = new Vector.<LoaderInfo>;
				for( jj = 0 ; jj <= xml.skin.length() + SWF_LOAD_SPEAR ; jj++ )
				{
					girlLoadStatus++;
					lor = new Loader();
					loader3Vec[ii][jj] = lor.contentLoaderInfo;
					lor.load( new URLRequest( Preset.SITE_URL + xml.girl[ii].@src ) );
					lor.contentLoaderInfo.addEventListener( Event.COMPLETE , girlLoadSet );
				}
			}
			
			// member manager set
			memberManager.setTxt( xml.member[0].toString() );
			memberManager.setManTel1( xml.member[0].@telMan1 );
			memberManager.setManTel2( xml.member[0].@telMan2 );
			memberManager.setManTel3( xml.member[0].@telMan3 );
			memberManager.setGirlTel1( xml.member[0].@telGirl1 );
			memberManager.setGirlTel2( xml.member[0].@telGirl2 );
			memberManager.setGirlTel3( xml.member[0].@telGirl3 );
			memberManager.setQrUrl( xml.member[0].@qr_url );
			
			// preview popup qr code load
			previewPop.previewLoad();
		}
		private function imgLoadSet( b:Bitmap , ii:Number ):void
		{
			imgLoadStatus--;
			imgManager.setImg( ii , b );
			imgManager.setOrigImg( ii , b );
			
			imgLoadStatus--;
			imgManager.setThumb( ii , b );
			
			stageInitCk();
		}
		private function thumbLoadSet( b:Bitmap , ii:Number ):void
		{
			imgLoadStatus--;
			imgManager.setThumb( ii , b );
			stageInitCk();
		}
		private function swfLoadComplete( e:Event ):void
		{
			swfLoadStatus--;
			
			var ii:Number = 0;
			for( ; ii < loaderVec.length ; ii++ )
			{
				if( loaderVec[ii] == e.currentTarget )
				{
					skinManager.setSkin( ii , e.currentTarget.content );
				}
			}
			stageInitCk();
		}
		
		private function titleLoadSet( e:Event ):void
		{
			titleLoadStatus--
			var ii:Number = 0;
			var jj:Number = 0;
			for( ii = 0 ; ii < loader1Vec.length ; ii++ )
			{
				for( jj = 0 ; jj < loader1Vec[ii].length ; jj++ )
				{
					if( loader1Vec[ii][jj] == e.currentTarget )
					{
						titleManager.setImg( ii , jj , e.currentTarget.content );
					}
				}
			}
			stageInitCk();
		}
		
		private function manLoadSet( e:Event ):void
		{
			manLoadStatus--
			var ii:Number = 0;
			var jj:Number = 0;
			for( ii = 0 ; ii < loader2Vec.length ; ii++ )
			{
				for( jj = 0 ; jj < loader2Vec[ii].length ; jj++ )
				{
					if( loader2Vec[ii][jj] == e.currentTarget )
					{
						manManager.setImg( ii , jj , e.currentTarget.content );
					}
				}
			}
			stageInitCk();
		}
		
		private function girlLoadSet( e:Event ):void
		{
			girlLoadStatus--
			var ii:Number = 0;
			var jj:Number = 0;
			for( ii = 0 ; ii < loader2Vec.length ; ii++ )
			{
				for( jj = 0 ; jj < loader3Vec[ii].length ; jj++ )
				{
					if( loader3Vec[ii][jj] == e.currentTarget )
					{
						girlManager.setImg( ii , jj , e.currentTarget.content );
					}
				}
			}
			stageInitCk();
		}
		
		private function stageInitCk():void
		{
			if( imgLoadStatus == 0 && swfLoadStatus == 0 && titleLoadStatus == 0 && manLoadStatus == 0 && girlLoadStatus == 0 )
			{
				stageInit();
			}
		}
		
		private function imgSet( e:EventInData , index:Number = NaN ):void
		{
			var data:EventInDataClass = e.data as EventInDataClass;
			var idx:Number;
			if( isNaN( index ) )
			{
				idx = data.numb;
			} else {
				idx = index;
			}
			
			// data.bitmap 이 null 로 넘어 오면 해당 idx 삭제.
			if( data.bitmap != null )
			{
				if( data.isFirst )
				{
					imgManager.setImg( idx, data.bitmap );
					imgManager.setOrigImg( idx , data.bitmap );
					imgManager.setThumb( idx , data.bitmap );
				} else {
					imgManager.setImg( idx, data.bitmap , false );
					imgManager.setOrigImg( idx , data.origBitmap );
				}
				
				stageInit( idx , data.isFirst );
				if( !isNaN( data.swapBeginIndex ) && !isNaN( data.swapEndIndex ) )
				{
					//  이미지 이동일 경우 시작점과 끝점을 받아서  이미지 보정 데이타도 옮긴다.
					var dummyData:EventInDataClass = new EventInDataClass( 99 );
					var ii : Number;
					
					// dummy에 임시로 담는다.
					dummyData.rotate = ImageManager.rotateV[data.swapBeginIndex];
					dummyData.positionX = ImageManager.positionX[data.swapBeginIndex];
					dummyData.positionY = ImageManager.positionY[data.swapBeginIndex];
					dummyData.effectSepia = ImageManager.effectSepia[data.swapBeginIndex];
					dummyData.effectGray = ImageManager.effectGray[data.swapBeginIndex];
					dummyData.effectOld = ImageManager.effectOld[data.swapBeginIndex];
					dummyData.effectLuxury = ImageManager.effectLuxury[data.swapBeginIndex];
					dummyData.effectLomo = ImageManager.effectLomo[data.swapBeginIndex];
					dummyData.effectBrightness = ImageManager.effectBrightness[data.swapBeginIndex];
					dummyData.effectContrast = ImageManager.effectContrast[data.swapBeginIndex];
					
					if( data.swapBeginIndex > data.swapEndIndex )
					{
						for( ii = data.swapBeginIndex - 1 ; ii >= data.swapEndIndex ; ii-- )
						{
							ImageManager.rotateV[ii + 1] = ImageManager.rotateV[ii];
							ImageManager.positionX[ii + 1] = ImageManager.positionX[ii];
							ImageManager.positionY[ii + 1] = ImageManager.positionY[ii];
							ImageManager.effectSepia[ii + 1] = ImageManager.effectSepia[ii];
							ImageManager.effectGray[ii + 1] = ImageManager.effectGray[ii];
							ImageManager.effectOld[ii + 1] = ImageManager.effectOld[ii];
							ImageManager.effectLuxury[ii + 1] = ImageManager.effectLuxury[ii];
							ImageManager.effectLomo[ii + 1] = ImageManager.effectLomo[ii];
							ImageManager.effectBrightness[ii + 1] = ImageManager.effectBrightness[ii];
							ImageManager.effectContrast[ii + 1] = ImageManager.effectContrast[ii];
						}
					} else {
						for( ii = data.swapBeginIndex + 1 ; ii <= data.swapEndIndex ; ii++ )
						{
							ImageManager.rotateV[ii - 1] = ImageManager.rotateV[ii];
							ImageManager.positionX[ii - 1] = ImageManager.positionX[ii];
							ImageManager.positionY[ii - 1] = ImageManager.positionY[ii];
							ImageManager.effectSepia[ii - 1] = ImageManager.effectSepia[ii];
							ImageManager.effectGray[ii - 1] = ImageManager.effectGray[ii];
							ImageManager.effectOld[ii - 1] = ImageManager.effectOld[ii];
							ImageManager.effectLuxury[ii - 1] = ImageManager.effectLuxury[ii];
							ImageManager.effectLomo[ii - 1] = ImageManager.effectLomo[ii];
							ImageManager.effectBrightness[ii - 1] = ImageManager.effectBrightness[ii];
							ImageManager.effectContrast[ii - 1] = ImageManager.effectContrast[ii];
						}
					}
					ImageManager.rotateV[data.swapEndIndex] = dummyData.rotate;
					ImageManager.positionX[data.swapEndIndex] = dummyData.positionX;
					ImageManager.positionY[data.swapEndIndex] = dummyData.positionY;
					ImageManager.effectSepia[data.swapEndIndex] = dummyData.effectSepia;
					ImageManager.effectGray[data.swapEndIndex] = dummyData.effectGray;
					ImageManager.effectOld[data.swapEndIndex] = dummyData.effectOld;
					ImageManager.effectLuxury[data.swapEndIndex] = dummyData.effectLuxury;
					ImageManager.effectLomo[data.swapEndIndex] = dummyData.effectLomo;
					ImageManager.effectBrightness[data.swapEndIndex] = dummyData.effectBrightness;
					ImageManager.effectContrast[data.swapEndIndex] = dummyData.effectContrast;					
				}
			} else {
				imgManager.delImg( idx );
				imgManager.delThumb( idx );
				stageInit( NaN , true , idx );
			}
		}
		private function imgEditSet( e:EventInData ):void
		{
			var eData:EventInDataClass = e.data as EventInDataClass;
			imgManager.setImg( eData.numb , eData.bitmap , true , eData.effectGray , eData.effectSepia , eData.effectOld , eData.effectLuxury , eData.effectLomo , eData.effectBrightness , eData.effectContrast , eData.positionX , eData.positionY , eData.rotate );
			imgManager.setThumb( eData.numb , eData.bitmap );
			if( eData.isFinal )
			{
				topNavi.stageInit();
				body01.bitmapSet();
				body02.bitmapReset();
				editPop.bitmapSet();
			}
			editPop.hide();
		}
		
		// isAll 이 없으면 해당 idx 만 stageInit 적용. isAll 값이 있으면 해당 idx 부터 끝까지 stageInit
		private function stageInit( idx:Number = NaN , isFirstTopNavi:Boolean = true , isAll:Number = NaN ):void
		{
			var maxII:Number = 5;
			if( ImageManager.length() > 5 )
			{
				maxII = ImageManager.length();
			}
			
			if( !isSkinMinCount )
			{
				if( !isNaN( isAll ) )
				{
					for( var ii : Number = isAll ; ii < maxII ; ii++ )
					{
						body01.stageInit( ii );
						body02.stageInit( ii , isFirst );
						topNavi.stageInit( isFirstTopNavi );
						editPop.stageInit( ii , isFirst );
					}
					
				} else {
					body01.stageInit( idx );
					body02.stageInit( idx , isFirst );
					topNavi.stageInit( isFirstTopNavi );
					editPop.stageInit( ii , isFirst );
				}
			}
		}
		
		private function stageInitComplete( e:EventInData ):void
		{
			switch( e.data )
			{
				case Preset.BODY01_CLASS_STRING :
					body01IsStageInit = true;
					break;
				case Preset.BODY02_CLASS_STRING :
					body02IsStageInit = true;
					break;
				case Preset.TOP_NAVI_CLASS_STRING :
					topNaviIsStageInit = true;
					break;
				case Preset.EDIT_POP_CLASS_STRING :
					editPopIsStageInit = true;
					break;
			}
			if( body01IsStageInit && body02IsStageInit && topNaviIsStageInit && editPopIsStageInit )
			{
				loadingPop.hide();
				if( MemberManager.isFirst != 1 && isFirst )
				{
					bodyShow( 2 );
				}
				if( isFirst )
				{
					isFirst = false;
				}
			}
		}
		private function editPopClose( e:Event ):void
		{
			body02.editPopClose();
		}
		// 이미지 보정 팝업창 띄움
		private function imageEditShow( e:EventInData ):void
		{
			if( isStepStatus == 2 )
			{
				editPop.show( e.data as Number , body01._status );
			}
		}
		private function nextStep( e:Event ):void
		{
			bodyShow(2);
		}
		private function previewShow1( e:Event ) :void
		{
			previewPop.showTest( body01._status , body01.getSkinItem( body01._status ) as viewerItem );
		}
		private function previewShow2( e:Event ) :void
		{
			previewPop.showTest( body01._status , body02.getSaveImage() as viewerItem );
		}
		private function bodyGoPrev( e:Event ):void
		{
			//bodyShow( 1 );
			commonPop.show( Preset.COMMONPOP_DATA_RESET_CONFIRM );
			commonPop.addEventListener( Preset.COMMONPOP_CLOSE_CLICK_DISPATCH_STR , bodyGoPrevAction );
		}
		private function bodyGoPrevAction( e:Event ):void
		{
			bodyShow(1);
		}
		private function bodyShow( ty:Number ):void
		{
			switch( ty )
			{
				case 1 :
					stepStatusSet( 1 );
					Tweener.addTween( bodyBox , { x:0 , time:2 , onComplete:twEditComplete1 } );
					body01.btnRemoveListener();
					body02.btnRemoveListener();
					break;
				case 2 :
					stepStatusSet( 2 );
					Tweener.addTween( bodyBox , { x: -Preset.BODY02_XY[0] + Preset.BODY02_POSITION_GAP , time:1.5 , onComplete:twEditComplete2 } );
					if( isFirst )
					{
						body02.editSwfLoad( MemberManager.skinIndex );
					} else {
						body02.editSwfLoad( body01._status );
					}
					body01.btnRemoveListener();
					body02.btnRemoveListener();
					break;
				default : 
					
					break;
			}
		}
		private function stepStatusSet( numb:Number ):void
		{
			isStepStatus = numb;
			topNavi._stepStatus = numb;
		}
		private function twEditComplete1():void
		{
			body01.btnAddListener();
			body02.twEditComplete1();
		}
		private function twEditComplete2():void
		{
			body02.btnAddListener();
			body02.twEditComplete2();
		} 
		private function commonPopShow( e:EventInData ):void
		{ 
			commonPop.show( e.data as Number );
		}
		private function getTelNumber( e:Event ):void
		{
			var _vector:Vector.<String> = new Vector.<String>;
			_vector[0] = body02.manTel;
			_vector[1] = body02.girlTel;
			previewPop.smsSend( _vector );
		}
		
		// Image Server Upload
		private function savePopShow1( e:Event ):void
		{
			savePop.manTel = body02.manTel;
			savePop.girlTel = body02.girlTel;
			savePop.saveShowTest( body01.getSkinItem( body01._status ) );
		}
		private function savePopShow2( e:Event ):void
		{
			savePop.manTel = body02.manTel;
			savePop.girlTel = body02.girlTel;
			savePop.saveShowTest( body02.getSaveImage() );
		}
		
		private function imageSaveComplete( e:Event ):void
		{
		
		}
		private function stageMouseUp( e:MouseEvent ):void
		{
			topNavi.topNaviUpAction( e );
			body02.stageMouseUp();
		}
	}
	
}