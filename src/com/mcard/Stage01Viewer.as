package com.mcard
{
	import caurina.transitions.Tweener;
	
	import com.fwang.utils.DisplayObjectUtils;
	import com.mcard.Setting.Preset;
	import com.mcard.manager.ImageManager;
	import com.mcard.manager.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Stage01Viewer extends Sprite
	{
		private var naviBox:MovieClip = new MovieClip();
		private var viewBody:MovieClip = new MovieClip();
		private var naviClip:MovieClip;
		private var maskBody:Sprite = new Sprite();
		private var status:Number = 0;
		private var eff_time:Number = Preset.EFF_TIME;
		private var isMoving:Boolean = false;
		private var resizeWH:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
		
		public function Stage01Viewer( clip:MovieClip )
		{
			naviClip = clip;
			super();
			
			setDefault();
			setView();
			setListener();
			
		}
		private function setView():void
		{
			addChild( naviBox );
			addChild( viewBody );
			naviBox.addChild( naviClip );
			addChild( maskBody );
		}
		private function setListener():void
		{
			naviClip.addEventListener( MouseEvent.CLICK , naviClick );
			
		}
		private function setDefault():void
		{
			naviClip.x = 0;
			naviClip.y = Preset.IMGVIEWER_NAVI_Y;
			maskBody.graphics.beginFill( 0x000000 );
			maskBody.graphics.drawRect( 0 , 0 , Preset.IMGVIEWER_MASK_WH[0] , Preset.IMGVIEWER_MASK_WH[1] );
			maskBody.graphics.endFill();
			
			viewBody.mask = maskBody;
		}
		public function get _status():Number
		{
			return status;	
		}
		
		/* XML 에  skin 노드 체크 하여 스킨 배치   */
		public function stageInit():void
		{
			var ii:Number = 0;
			var mc:MovieClip = new MovieClip();
			
			for( ; ii < SkinManager.skinBody.length ; ii++ )
			{
				addItem( ii , SkinManager.skinBody[ii] as MovieClip );
				if( ii != 0 ) 
				{
					mc = DisplayObjectUtils.duplicate( naviClip , true ) as MovieClip;
					mc.name = "naviClip" + ii;
					mc.x = ( mc.width - 3 ) * ii;
					mc.addEventListener( MouseEvent.CLICK , naviClick );
				}
			}
			
			// navi position set 
			naviBox.x = ( maskBody.width - naviBox.width ) / 2;
			( naviBox.getChildAt(0) as MovieClip ).gotoAndStop(2);
			dispatchEvent( new Event( Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		} 
		// get save skin
		public function getSkinItem( skinIdx:Number ):MovieClip
		{
			return viewBody.getChildAt( skinIdx ) as MovieClip;
		}
									 
		private function itemInitFunc( e:Event ):void
		{
			
			if( viewBody.numChildren == SkinManager.skinBody.length )
			{
				itemResize();
			}
			
		}
		private function itemResize():void
		{
			var ii:Number;
			var status_prev1:Number = status - 1;
			var status_prev2:Number = status - 2;
			if( status_prev2 < 0 )
			{
				status_prev2 += SkinManager.skinBody.length ;
				if( status_prev1 < 0 )
				{
					status_prev1 += SkinManager.skinBody.length ;
				}
			}
			var status_next1:Number = status + 1;
			var status_next2:Number = status + 2;
			if( status_next2 >= SkinManager.skinBody.length )
			{
				status_next2 -= SkinManager.skinBody.length;
				if( status_next1 >= SkinManager.skinBody.length )
				{
					status_next1 -= viewBody.numChildren;
				}
			}
			viewerItemSetWH( true );
			
			
			viewBody.getChildAt( status_prev2 ).x = Preset.IMGVIEWER01_XY[0];
			viewBody.getChildAt( status_prev2 ).y = Preset.IMGVIEWER01_XY[1];
			skinResize( status_prev2 );	//skinResize( viewBody.getChildAt( status_prev2 ) as MovieClip , -1 );
			viewBody.getChildAt( status_prev1 ).x = Preset.IMGVIEWER02_XY[0];
			viewBody.getChildAt( status_prev1 ).y = Preset.IMGVIEWER02_XY[1];
			skinResize( status_prev1 );	//skinResize( viewBody.getChildAt( status_prev1 ) as MovieClip , -1 );
			
			viewBody.getChildAt( status ).x = Preset.IMGVIEWER03_XY[0];
			viewBody.getChildAt( status ).y = Preset.IMGVIEWER03_XY[1];
			skinResize( status );	//skinResize( viewBody.getChildAt( status ) as MovieClip , 0 );
			
			viewBody.getChildAt( status_next1 ).x = Preset.IMGVIEWER04_XY[0];
			viewBody.getChildAt( status_next1 ).y = Preset.IMGVIEWER04_XY[1];
			skinResize( status_next1 );	//skinResize( viewBody.getChildAt( status_next1 ) as MovieClip , 1 );
			viewBody.getChildAt( status_next2 ).x = Preset.IMGVIEWER05_XY[0];
			viewBody.getChildAt( status_next2 ).y = Preset.IMGVIEWER05_XY[1];
			skinResize( status_next2 );	//skinResize( viewBody.getChildAt( status_next2 ) as MovieClip , 1 );
			
			for( ii = 0 ; ii < viewBody.numChildren ; ii++ )
			{
				if( ii != status_prev1 && ii != status_prev2 && ii != status && ii != status_next1 && ii != status_next2 )
				{
					viewBody.getChildAt( ii ).x = Preset.IMGVIEWER00_XY[0];
					viewBody.getChildAt( ii ).y = Preset.IMGVIEWER00_XY[1];
					skinResize( ii );	//skinResize( viewBody.getChildAt( ii ) as MovieClip , -1 );
				}
			}
		}
			
		/* 스킨 추가  */
		private function addItem( numb:Number , _mc:MovieClip ):void
		{
			var viewItem:viewerItem = new viewerItem();
			viewBody.addChild( viewItem );
			viewBody.getChildAt( viewBody.numChildren - 1 ).x = viewBody.getChildAt( viewBody.numChildren - 1 ).y = -1000;
			
			viewItem.addEventListener( "itemInit" , itemInitFunc );
			viewItem.viewerItemInit( numb , _mc );
		}
		
		/*  네비 게시션에 따른 이동 */
		public function move( boo:Boolean , at:Number = 100 ):void
		{
			if( !isMoving ) 
			{
				isMoving = true;
				if( at == 100 )	eff_time = Preset.EFF_TIME;
				
				var _at:Array = new Array( 2 );
				_at[0] = boo;
				_at[1] = at;
				var mc0Status:Number = status - 3;
				var mc1Status:Number = status - 2;
				var mc2Status:Number = status - 1;
				var mc3Status:Number = status;
				var mc4Status:Number = status + 1;
				var mc5Status:Number = status + 2;
				var mc6Status:Number = status + 3;
				if( mc0Status < 0 )
				{
					mc0Status += SkinManager.skinBody.length;
					if( mc1Status < 0 )
					{
						mc1Status += SkinManager.skinBody.length;
						if( mc2Status < 0 )
						{
							mc2Status += SkinManager.skinBody.length;
						}
					}
				}
				if( mc6Status >= SkinManager.skinBody.length )
				{
					mc6Status -= SkinManager.skinBody.length;
					if( mc5Status >= SkinManager.skinBody.length )
					{
						mc5Status -= SkinManager.skinBody.length;
						if( mc4Status >= SkinManager.skinBody.length )
						{
							mc4Status -= SkinManager.skinBody.length;
						}
					}
				}
				
				//if( mc0Status < 0 ) mc0Status = mc0Status + SkinManager.skinBody.length;
				//if( mc1Status < 0 ) mc1Status = mc1Status + SkinManager.skinBody.length;
				//if( mc3Status >= SkinManager.skinBody.length ) mc3Status = mc3Status - SkinManager.skinBody.length;
				//if( mc4Status >= SkinManager.skinBody.length ) mc4Status = mc4Status - SkinManager.skinBody.length;
				
				var mc0:MovieClip =  viewBody.getChildAt( mc0Status ) as MovieClip;
				var mc1:MovieClip =  viewBody.getChildAt( mc1Status ) as MovieClip;
				var mc2:MovieClip =  viewBody.getChildAt( mc2Status ) as MovieClip;
				var mc3:MovieClip =  viewBody.getChildAt( mc3Status ) as MovieClip;
				var mc4:MovieClip =  viewBody.getChildAt( mc4Status ) as MovieClip;
				var mc5:MovieClip =  viewBody.getChildAt( mc5Status ) as MovieClip;
				var mc6:MovieClip =  viewBody.getChildAt( mc6Status ) as MovieClip;
				
				mc0.x = Preset.IMGVIEWER00_XY[0];
				mc0.y = Preset.IMGVIEWER00_XY[1];
				mc6.x = Preset.IMGVIEWER06_XY[0];
				mc6.y = Preset.IMGVIEWER06_XY[1];
				
				if( boo ) {
					// 정방향 이동
					( naviBox.getChildAt( status ) as MovieClip ).gotoAndStop(1);
					status++;
					if( status == SkinManager.skinBody.length ) 	status = 0;
					( naviBox.getChildAt( status ) as MovieClip ).gotoAndStop(2);
					
					//mc0.x = mc0.y = -1000;
					mc6.x = Preset.IMGVIEWER06_XY[0];
					mc6.y = Preset.IMGVIEWER06_XY[1];
					Tweener.addTween( mc1 , { x:Preset.IMGVIEWER00_XY[0] , y:Preset.IMGVIEWER00_XY[1] , time:eff_time , transition:"linear" , onComplete:moveComplete , onCompleteParams:_at } );
					Tweener.addTween( mc2 , { x:Preset.IMGVIEWER01_XY[0] , y:Preset.IMGVIEWER01_XY[1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc3 , { x:Preset.IMGVIEWER02_XY[0] , y:Preset.IMGVIEWER02_XY[1] , width:resizeWH[mc3Status][0], height:resizeWH[mc3Status][1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc4 , { x:Preset.IMGVIEWER03_XY[0] , y:Preset.IMGVIEWER03_XY[1] , width:resizeWH[mc4Status][2] , height:resizeWH[mc4Status][3] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc5 , { x:Preset.IMGVIEWER04_XY[0] , y:Preset.IMGVIEWER04_XY[1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc6 , { x:Preset.IMGVIEWER05_XY[0] , y:Preset.IMGVIEWER05_XY[1] , time:eff_time , transition:"linear" } );
				} else if( !boo ){
					// 반대방향 이동
					( naviBox.getChildAt( status ) as MovieClip ).gotoAndStop(1);
					status--;
					if( status < 0 )		status = SkinManager.skinBody.length - 1 ; 
					( naviBox.getChildAt( status ) as MovieClip ).gotoAndStop(2);
					//mc4.x = mc4.y = -1000;
					mc0.x = Preset.IMGVIEWER00_XY[0];
					mc0.y = Preset.IMGVIEWER00_XY[1];
					Tweener.addTween( mc0 , { x:Preset.IMGVIEWER01_XY[0] , y:Preset.IMGVIEWER01_XY[1] , time:eff_time , transition:"linear" , onComplete:moveComplete , onCompleteParams:_at } );
					Tweener.addTween( mc1 , { x:Preset.IMGVIEWER02_XY[0] , y:Preset.IMGVIEWER02_XY[1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc2 , { x:Preset.IMGVIEWER03_XY[0] , y:Preset.IMGVIEWER03_XY[1] , width:resizeWH[mc2Status][2] , height:resizeWH[mc2Status][3] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc3 , { x:Preset.IMGVIEWER04_XY[0] , y:Preset.IMGVIEWER04_XY[1] , width:resizeWH[mc3Status][0], height:resizeWH[mc3Status][1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc4 , { x:Preset.IMGVIEWER05_XY[0] , y:Preset.IMGVIEWER05_XY[1] , time:eff_time , transition:"linear" } );
					Tweener.addTween( mc5 , { x:Preset.IMGVIEWER06_XY[0] , y:Preset.IMGVIEWER06_XY[1] , time:eff_time , transition:"linear" } );
				}
			}
		}
		public function bitmapReset( index:Number ):void
		{
			var ii :Number = 0;
			for( ; ii < SkinManager.skinBody.length ; ii++ )
			{
				( viewBody.getChildAt( ii ) as viewerItem ).imgSetting( index , ImageManager.imgArr[index] );
			}
			//( viewBody.getChildAt( 0 ) as viewerItem ).imgSetting( index , ImageManager.imgArr[index] );
			viewerItemSetWH();
			dispatchEvent( new Event( Preset.DISPATCH_STAGEINIT_COMPLETE ) );
		}
		
		private function viewerItemSetWH( isFirst:Boolean = false ):void
		{
			var ii:Number;
			for( ii = 0 ; ii < viewBody.numChildren ; ii++ )
			{
				if( isFirst )
				{
					resizeWH[ii] = new Vector.<Number>;
					resizeWH[ii][0] = viewBody.getChildAt( ii ).width * Preset.IMGVIEWER01_RATE;
					resizeWH[ii][1] = viewBody.getChildAt( ii ).height * Preset.IMGVIEWER01_RATE;
					resizeWH[ii][2] = viewBody.getChildAt( ii ).width * Preset.IMGVIEWER02_RATE;
					resizeWH[ii][3] = viewBody.getChildAt( ii ).height * Preset.IMGVIEWER02_RATE;
					resizeWH[ii][4] = viewBody.getChildAt( ii ).width;
					resizeWH[ii][5] = viewBody.getChildAt( ii ).height;
				} else {
					
					if( status == ii )
					{
						resizeWH[ii][0] = viewBody.getChildAt( ii ).width / Preset.SKIN_SIZE_RATE2;
						resizeWH[ii][1] = viewBody.getChildAt( ii ).height / Preset.SKIN_SIZE_RATE2;
						resizeWH[ii][2] = viewBody.getChildAt( ii ).width;
						resizeWH[ii][3] = viewBody.getChildAt( ii ).height;						
					} else {
						resizeWH[ii][0] = viewBody.getChildAt( ii ).width;
						resizeWH[ii][1] = viewBody.getChildAt( ii ).height;
						resizeWH[ii][2] = viewBody.getChildAt( ii ).width * Preset.SKIN_SIZE_RATE2;
						resizeWH[ii][3] = viewBody.getChildAt( ii ).height * Preset.SKIN_SIZE_RATE2;
					}
				}
			}
		}
		private function skinResize2( mc:MovieClip , idx:Number ):void
		{
			if( idx == -1 )
			{
				mc.width = resizeWH[0][0];
				mc.height = resizeWH[0][1];
			} else if( idx == 0 ) {
				mc.width = resizeWH[0][2];
				mc.height = resizeWH[0][3];
			} else if ( idx == 1 ) {
				mc.width = resizeWH[0][0];
				mc.height = resizeWH[0][1];
			}
		}
		private function skinResize( idx:Number ):void
		{
			var _mc:MovieClip = viewBody.getChildAt( idx ) as MovieClip;
			if( idx == status )
			{
				_mc.width = resizeWH[idx][2];
				_mc.height = resizeWH[idx][3];
			} else {
				_mc.width = resizeWH[idx][0];
				_mc.height = resizeWH[idx][1];
			}
		}
		private function moveComplete( boo:Boolean ,  i:Number = 100 ):void
		{
			isMoving = false;
			if( i != 100 && i != status ) {
				move( boo , i );
			}
			
		}
		private function naviClick( e:MouseEvent ):void
		{
			var i:Number = new Number( e.currentTarget.name.replace("naviClip" , "" ) );
			if( !i ) 		i = 0;
			moveAt( i );
		}
		
		/*  네비 게시션에 따른 특정 위치로  이동 */
		private function moveAt( i:Number ):void
		{
			var boo:Boolean = true;
			eff_time = Preset.EFF_TIME / ( Math.abs( status - i ) );
			if( status - i < 0 )
			{
				boo = true;
			} else {
				boo = false;
			}
			if( Math.abs( status - i ) > Math.floor( SkinManager.skinBody.length / 2 ) ) {
				boo = !boo;
				eff_time = Preset.EFF_TIME / ( SkinManager.skinBody.length - Math.abs( status - i ) );
			}  
			
			var atI:Number = Math.abs( status - i );
			move( boo , i );
		}
	}
}