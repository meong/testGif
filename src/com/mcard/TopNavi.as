package com.mcard
{
	import caurina.transitions.Tweener;
	
	import com.fwang.events.EventInData;
	import com.fwang.utils.DisplayObjectUtils;
	import com.fwang.utils.ImageUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.events.EventInDataClass;
	import com.mcard.manager.ImageManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	public class TopNavi extends Sprite
	{
		private var topNaviClip:TopNaviClip = new TopNaviClip();
		private var topNaviBox:Sprite = new Sprite();
		private var topNaviDownId:Number;
		private var frList:FileReferenceList = new FileReferenceList();
		private var loader:Loader = new Loader();
		
		private var curFileNum:Number = 0;
		private var fileCnt:Number = 0 ;
		private var isCommonPop:Boolean = false;
		private var isTopClick:Number = NaN;
		private var topMoveArr:Array = new Array();
		private var isDelClick:Boolean;
		private var gap:Number = 0;
		private var isStepStatus:Number = 1;
		private var btnImgEditDummyXY:Vector.<Number> = new Vector.<Number>;
		
		public function TopNavi()
		{
			super();
			setView();
			setListener();
			setDefault();
		}
		private function setView():void
		{
			addChild( topNaviClip );
			this.addChild( topNaviBox );
		}
		private function setListener():void
		{
			topNaviClip.btnFile.addEventListener( MouseEvent.CLICK , fileClick );
			topNaviClip.btnImgEdit.addEventListener( MouseEvent.CLICK , imageEdit );
			frList.addEventListener( Event.SELECT , onFileSelect );
			frList.addEventListener( Event.CANCEL , onFileCancel );
		}
		private function setDefault():void
		{
			topNaviBox.x = Preset.TOPNAVI_BOX_XY[0];		topNaviBox.y = Preset.TOPNAVI_BOX_XY[1];
			btnImgEditDummyXY[0] = topNaviClip.btnImgEditDummy.x;
			btnImgEditDummyXY[1] = topNaviClip.btnImgEditDummy.y;
			btnImgEditDummyXY[2] = -1000;
		}
		public function show():void
		{
			topNaviClip.x = 0;
		}
		public function hide():void
		{
			topNaviClip.x = -topNaviClip.width;
		}
		public function stageInit( imgSetFirst:Boolean = true ):void
		{
			gap = 0;
			if( imgSetFirst ) {
				topNaviRemove();
				var ii:Number = 0;
				for( ii ; ii < ImageManager.thumbArr.length ; ii++ )
				{ 
					setTopNaviItem( ImageManager.thumbArr[ii] , ii );
				}
			}
			dispatchEvent( new EventInData( Preset.TOP_NAVI_CLASS_STRING , Preset.DISPATCH_STAGEINIT_COMPLETE ) ) ;
		}
		public function topNaviRemove():void
		{
			for( var ii:Number = topNaviBox.numChildren - 1 ; ii >= 0 ; ii-- )
			{
				topNaviBox.removeChildAt( ii );
			}
		}
		public function set _stepStatus( numb:Number ):void
		{
			isStepStatus = numb;
			
			if( numb == 2 )
			{
				topNaviClip.btnImgEditDummy.y = btnImgEditDummyXY[2];
			} else {
				topNaviClip.btnImgEditDummy.y = btnImgEditDummyXY[1];
			}
		}
		
		private function setTopNaviItem( e:Bitmap , num:Number ):void
		{
			var mc:MovieClip = DisplayObjectUtils.duplicate( topNaviClip.BodyItem , true ) as MovieClip;
			mc.removeChildAt(0);
			var bBoxMc:MovieClip = new MovieClip();				
			var b:Bitmap = ImageUtils.duplicateImage( e );
			bBoxMc.name = Preset.TOPNAVI_ITEM_BITMAP_NAME;
			mc.name = Preset.TOPNAVI_ITEM_NAME + num ;
			topNaviBox.addChild( mc );
			mc.addChildAt( bBoxMc , 0 ) ;
			bBoxMc.addChild( b );
			bBoxMc.width = Preset.TOPNAVI_WH[0] - 2;
			bBoxMc.height = Preset.TOPNAVI_WH[1] - 2;
			bBoxMc.x = bBoxMc.y = 1;
			if( num == 1 || num == 5 )
			{
				gap += Preset.TOPNAVI_GAP2;
			}
			mc.x = ( Preset.TOPNAVI_WH[0] + Preset.TOPNAVI_GAP ) * num + gap;
			mc.y = 0;
			//mc.addEventListener( MouseEvent.CLICK , topNaviClick );
			mc.addEventListener( MouseEvent.MOUSE_OVER , topNaviOver );
			mc.addEventListener( MouseEvent.MOUSE_OUT , topNaviOut );
			bBoxMc.addEventListener( MouseEvent.MOUSE_DOWN , topNaviDown );
			//mc.addEventListener( MouseEvent.MOUSE_UP , topNaviUp );
			mc.btnDel.addEventListener( MouseEvent.CLICK , topNaviDelClick );
		}
		
		private function topNaviDelClick( e:MouseEvent ):void
		{
			isDelClick = true;
			var _mc:MovieClip = ( e.currentTarget as MovieClip ).parent as MovieClip;
			_mc.removeEventListener( MouseEvent.CLICK , topNaviClick );
			_mc.removeEventListener( MouseEvent.MOUSE_OVER , topNaviOver );
			_mc.removeEventListener( MouseEvent.MOUSE_OUT , topNaviOut );
			_mc.removeEventListener( MouseEvent.MOUSE_DOWN , topNaviDown );
			_mc.removeEventListener( MouseEvent.MOUSE_UP , topNaviUp );
			var num:Number = _mc.parent.getChildIndex( _mc.parent.getChildByName( _mc.name ) );
			delTopNaviItem( num );
			
		}
		private function delTopNaviItem( num:Number ):void
		{
			topMoveArr.length = 0;
			topMoveArr[0] = num;
			Tweener.addTween( topNaviBox.getChildAt( num ) , { alpha:0 , time:0.3 , transition:"linear" , onComplete:topNaviDel , onCompleteParams:topMoveArr } );
		}
		private function topNaviDel( num:Number ):void
		{
			var ii:Number;
			var moveMc:MovieClip;
			var moveV:Number;
			
			
			
			for( ii = num + 1 ; ii < ImageManager.length() ; ii++ )
			{
				moveMc = topNaviBox.getChildAt( ii ) as MovieClip;
				moveV = ( Preset.TOPNAVI_WH[0] + Preset.TOPNAVI_GAP );
				if( ii == 1 || ii == 5 )
				{
					moveV += Preset.TOPNAVI_GAP2;
				}
				if( ii == num + 1 )
				{
					topMoveArr.length = 0;
					topMoveArr[0] = num;
					Tweener.addTween( moveMc , { x:moveMc.x - moveV , time:0.7 , onComplete:topNaviDelComplete , onCompleteParams:topMoveArr } );
				} else {
					Tweener.addTween( moveMc , { x:moveMc.x - moveV , time:0.7 } );
				}
			}
			
			if( num + 1 == ImageManager.length() )
			{
				topNaviDelComplete( num );
			}
		}
		private function topNaviDelComplete( num:Number ):void
		{
			topNaviBox.removeChildAt( num );
			var inData:EventInDataClass = new EventInDataClass( num , null , null , false );
			dispatchEvent( new EventInData( inData , "imgSet" ) );
		}
		
		private function topNaviClick( e:MouseEvent ):void
		{
			if( !isDelClick )
			{
				var _mc:MovieClip = e.currentTarget as MovieClip;
				var _parent:MovieClip = _mc.parent as MovieClip;
				var _index:Number = _mc.parent.getChildIndex( _mc.parent.getChildByName( _mc.name ) );
				if( isNaN( isTopClick ) )
				{
					isTopClick = _index;
				} else if( isTopClick != _index ){
					topMoveArr.length = 0;
					topMoveArr[0] = isTopClick;
					topMoveArr[1] = _index;
					Tweener.addTween( _mc.parent.getChildAt( isTopClick ) , { alpha:0 , time:0.3 , transition:"linear" , onComplete:topMove , onCompleteParams:topMoveArr } );
					isTopClick = NaN;
				} else if ( isTopClick == _index )
				{
					isTopClick = NaN;
				}
			}
			isDelClick = false;
		}
		
		private function topNaviOver( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			_mc.focus.gotoAndStop(2);
		}
		private function topNaviOut( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;

			if( _mc.parent != null )
			{
				var _index:Number = _mc.parent.getChildIndex( _mc.parent.getChildByName( _mc.name ) );
				if( isTopClick != _index || isNaN( isTopClick ) )
				{
					_mc.focus.gotoAndStop(1);
				}
			}				
		}
		
		private function topNaviDown( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var _mcCopy:MovieClip = DisplayObjectUtils.duplicate( _mc , true ) as MovieClip;
			var _b:Bitmap = ImageUtils.duplicateImage( _mc.getChildAt(0) as Bitmap );
			_mcCopy.addChildAt( _b , 0 );
			topNaviBox.addChild( _mcCopy );
			_mcCopy.x = _mc.parent.x;
			//_mcCopy.y = 10//_mc.y;
			
			//_mcCopy.getChildAt(0).name = Preset.TOPNAVI_ITEM_BITMAP_NAME;
			//_b.width = Preset.TOPNAVI_WH[0] - 2;
			//_b.height = Preset.TOPNAVI_WH[1] - 2;
			//_b.x = _b.y = 1;
			
			_mcCopy.alpha = 0.7;
			var rect:Rectangle = new Rectangle( 0 , _mc.y , topNaviBox.width - _mc.width , 0 );
			_mcCopy.startDrag( false , rect );
			_mcCopy.addEventListener( MouseEvent.MOUSE_UP , topNaviUp );
			
			topNaviDownId = _mc.parent.parent.getChildIndex( _mc.parent );
		}
		private function topNaviUp( e:MouseEvent ):void
		{
			var _mc:MovieClip = e.currentTarget as MovieClip;
			var ii:Number;
			var endIndex:Number;
			
			for( ii = 0 ; ii < _mc.parent.numChildren - 1 ; ii++ )
			{
				if( _mc.parent.getChildAt( ii ).x <= ( _mc.x + _mc.width / 2 ) )
				{
					if( ( ii == _mc.parent.numChildren - 2 ) || _mc.parent.getChildAt( ii + 1 ).x > ( _mc.x + _mc.width / 2 ) )
					{
						endIndex = ii;
					}
				}
			}
			
			topMoveArr.length = 0;
			topMoveArr[0] = topNaviDownId;
			topMoveArr[1] = endIndex;
			if( topNaviDownId != endIndex && !isNaN( topNaviDownId ) && !isNaN( endIndex ) )
			{
				Tweener.addTween( _mc.parent.getChildAt( topNaviDownId ) , { alpha:0 , time:0.3 , transition:"linear" , onComplete:topMove , onCompleteParams:topMoveArr } );
			}
			topNaviDownId = NaN;
			
			_mc.stopDrag();
			_mc.parent.removeChild( _mc );
		}
		private function topMove( beforeIndex:Number , afterIndex:Number ):void
		{
			var ii:Number;
			var moveMc:MovieClip;
			var moveV:Number;
			if( beforeIndex > afterIndex )
			{
				
				
				for( ii = beforeIndex - 1 ; ii >= afterIndex ; ii-- )
				{
					moveMc = topNaviBox.getChildAt( ii ) as MovieClip;
					moveV = ( Preset.TOPNAVI_WH[0] + Preset.TOPNAVI_GAP );
					if( ii == 0 || ii == 4 )
					{
						moveV += Preset.TOPNAVI_GAP2;
					}
					if( ii == afterIndex )
					{
						topMoveArr.length = 0;
						topMoveArr[0] = beforeIndex;
						topMoveArr[1] = afterIndex;
						topMoveArr[2] = moveMc.x;
						Tweener.addTween( moveMc , { x:moveMc.x + moveV , time:0.7 , onComplete:topMoveComplete , onCompleteParams:topMoveArr } );
					} else {
						Tweener.addTween( moveMc , { x:moveMc.x + moveV , time:0.7 } );
					}
				}
			} else if( beforeIndex < afterIndex ){
				
				for( ii = beforeIndex + 1 ; ii <= afterIndex ; ii++ )
				{
					moveMc = topNaviBox.getChildAt( ii ) as MovieClip;
					moveV = -( Preset.TOPNAVI_WH[0] + Preset.TOPNAVI_GAP );
					if( ii == 1 || ii == 5 )
					{
						moveV -= Preset.TOPNAVI_GAP2;
					}
					if( ii == afterIndex )
					{
						topMoveArr.length = 0;
						topMoveArr[0] = beforeIndex;
						topMoveArr[1] = afterIndex;
						topMoveArr[2] = moveMc.x;
						Tweener.addTween( moveMc , { x:moveMc.x + moveV , time:0.7 , onComplete:topMoveComplete , onCompleteParams:topMoveArr } );
					} else {
						Tweener.addTween( moveMc , { x:moveMc.x + moveV , time:0.7 } );
					}
				}
			}
		}
		private function topMoveComplete( beforeIndex:Number , afterIndex:Number , setX:Number ):void
		{
			topNaviBox.getChildAt( beforeIndex ).x = setX;
			topNaviBox.getChildAt( beforeIndex ).alpha = 1;
			( topNaviBox.getChildAt( beforeIndex ) as MovieClip ).focus.gotoAndStop( 1 );
			topNaviBox.addChildAt( topNaviBox.getChildAt( beforeIndex ) , afterIndex );
			
			// image manager 재정렬
			var ii:Number = beforeIndex;
			var tmpBitmap:Bitmap = ImageManager.imgArr[beforeIndex];
			var tmpThumbBitmap:Bitmap = ImageManager.thumbArr[beforeIndex];
			var inData:EventInDataClass;
			if( beforeIndex > afterIndex )
			{
				for( ii = beforeIndex - 1 ; ii >= afterIndex ; ii-- )
				{
					inData = new EventInDataClass( ii + 1 , ImageManager.imgArr[ii] , ImageManager.thumbArr[ii] , false );
					dispatchEvent( new EventInData( inData , "imgSet" ) );
				}
			} else {
				for( ii = beforeIndex + 1 ; ii <= afterIndex ; ii++ )
				{
					inData = new EventInDataClass( ii - 1 , ImageManager.imgArr[ii] , ImageManager.thumbArr[ii] , false );
					dispatchEvent( new EventInData( inData , "imgSet" ) );
				}
			}
			inData = new EventInDataClass( afterIndex , tmpBitmap , tmpThumbBitmap , false );
			dispatchEvent( new EventInData( inData , "imgSet" ) );
		}
		private function topClickSetNaN():void
		{
			isTopClick = NaN;
			for( var ii:Number = 0 ; ii < topNaviBox.numChildren ; ii++ )
			{
				 ( topNaviBox.getChildByName( Preset.TOPNAVI_ITEM_NAME + ii ) as MovieClip ).focus.gotoAndStop( 1 );
			}
		}
		private function imageEdit( e:MouseEvent ):void
		{
			dispatchEvent( new EventInData( isTopClick , "editBtnClick" ) );
			topClickSetNaN();
		}
		private function fileClick( e:MouseEvent ):void
		{
			var fileFileFilter:FileFilter = new FileFilter("All Files" , Preset.FILE_EXT );
			frList.browse([fileFileFilter]);
		}
		private function onFileSelect( e:Event ):void
		{
			curFileNum = 0;
			if( topNaviBox.numChildren >= 10 ) {
				// 파일 업로드 수량 제한 오버
				dispatchEvent( new EventInData( Preset.COMMONPOP_FILEMAX_ERROR , Preset.COMMONPOP_SHOW_DISPATCH_STR ) );
				return void;
			}
			fileCnt = frList.fileList.length;
			if( fileCnt + topNaviBox.numChildren > 10 )
			{
				isCommonPop = true;
			} else {
				isCommonPop = false;
			}
			fileLoad( frList.fileList[curFileNum] );
		}
		private function fileLoadComplete( e:Event ):void
		{
			curFileNum++;
			var loadFr:FileReference = FileReference( e.target );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, dataCompleteHandler);
			loader.loadBytes( loadFr.data );
			if( topNaviBox.numChildren >= 10 - 1 ) {
				// 파일 업로드 수량 제한 오버
				if( isCommonPop )
				{
					dispatchEvent( new EventInData( Preset.COMMONPOP_FILEMAX_ERROR , Preset.COMMONPOP_SHOW_DISPATCH_STR ) );
				}
				return void;
			}
			
			if( curFileNum != fileCnt ) {
				fileLoad( frList.fileList[ curFileNum ] );
			}
			
		}
		private function fileLoad( fr:FileReference ):void
		{
			var _fr:FileReference = FileReference( frList.fileList[curFileNum] );
			_fr.addEventListener( Event.COMPLETE , fileLoadComplete );
			_fr.load();
		}
		private function dataCompleteHandler( e:Event ):void
		{
			var inData:EventInDataClass = new EventInDataClass( ImageManager.length() , e.target.content as Bitmap );
			dispatchEvent( new EventInData( inData , "imgSet" ) );
			
		}
		private function onFileCancel( e:Event ):void
		{
			
		}
	}
}