package com.jesus119
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;

	public class SlideLoad extends Sprite
	{
		private var url:String = "http://jesus119.net/html/img/pastor/";
		private var imgLoader:SingleImgLoader = new SingleImgLoader();
		private var img2Loader:SingleImgLoader = new SingleImgLoader();		
		private var currentX:Number = 0;
		private var current2X:Number = 0;		
		private var currentY:Number = 0;
		private var currentI:Number = 0;
		private var currentII:Number = 0;
		private var xml:XML;
		private var gap:uint = 3;
		private var loadImgW: uint = 55;
		private var loadImgH: uint = 61;
		private var loadImgCnt : uint;
		public  var defaultSpeed : Number = 1;
		private var moveUpHeight : Number = 5;
		public var moveSpeed: Number;
		public var goDirection : Boolean = true;	// true : 오른쪽 , false : 왼쪽 
		private var mainContainer:MovieClip = new MovieClip();
		private var mcContainer:MovieClip = new MovieClip();
		private var mcContainer2:MovieClip = new MovieClip();		
		private var maskClip:MaskClip = new MaskClip();
		private var popUpClip:Box_mcClip = new Box_mcClip();
		private var bodyW : Number ;
		public function SlideLoad( xml:XML )
		{
			super();
			defaultSetting();
			this.xml = xml;
			this.loadImgCnt = xml.img.length(); 
			this. bodyW = ( loadImgW + gap ) * loadImgCnt ;
			imgLoader.loaderSetup( url + xml.img[currentI].@pastorId + "_gray.jpg" , onComplete );
			img2Loader.loaderSetup( url + xml.img[currentII].@pastorId + ".jpg" , onComplete2 );
		}
		private function defaultSetting():void
		{
			this.moveSpeed = this.defaultSpeed;
			
			// format setting
			var formatter01:TextFormat = new TextFormat();
			formatter01.letterSpacing = -0.7;
			formatter01.bold =true;
			var formatter02:TextFormat = new TextFormat();
			formatter02.letterSpacing = -0.7;
			
			popUpClip.title_txt.defaultTextFormat = formatter01;
			popUpClip.pastor_txt.defaultTextFormat = formatter01;
			popUpClip.date_txt.defaultTextFormat = formatter02;
			
			this.addChild( popUpClip );
			popUpClip.y = -300;
			this.addChild( mainContainer );
			mainContainer.addChild( mcContainer );
			mcContainer.x = mcContainer.y = 6;		// gray 는 안쪽으로 3X3 만큼 더 들어간다
			mainContainer.addChild( mcContainer2 );
			mainContainer.x = 14;
			mainContainer.y = 68;
			this.maskClip.x = 20;
			maskClip.y = 58;
			maskClip.width = 464;
			maskClip.height = 100;
			mainContainer.mask = maskClip;
						
		}
		
		private function onComplete( e:Bitmap ):void
		{
			var mc:MovieClip = new MovieClip();			mc.addChild( e );
			var moveW : uint = gap + loadImgW;
			mc.x = currentX;
			mc.y = currentY;
			mc.buttonMode = true;
			this.currentI ++;
			
			if(this.currentI < xml.img.length() )
			{
				currentX += moveW;
				imgLoader.loaderSetup( url + xml.img[currentI].@pastorId + "_gray.jpg" , onComplete );
			} else {
				this.addEventListener( Event.ENTER_FRAME , onEnter );
			}
			this.mcContainer.addChild( mc );

		}
		private function onComplete2 ( e:Bitmap ):void
		{
			var mc:MovieClip = new MovieClip();
			mc.addChild( e );
			mc.id = currentII;

			var moveW : uint = gap + loadImgW;
			mc.x = current2X;
			mc.y = currentY;
			mc.addEventListener( MouseEvent.MOUSE_OVER , onOver );
			mc.addEventListener( MouseEvent.MOUSE_OUT , onOut );
			mc.addEventListener( MouseEvent.CLICK , onClick );
			this.currentII ++;
			
			if(this.currentII < xml.img.length() )
			{
				current2X += moveW;
				img2Loader.loaderSetup( url + xml.img[currentII].@pastorId + ".jpg" , onComplete2 );
			}
			this.mcContainer2.addChild( mc );
			mc.alpha = 0;
		}
		private function onClick ( e: MouseEvent ) : void
		{
			var url :String = this.xml.img[ e.currentTarget.id ].@link ;  
			var req : URLRequest = new URLRequest( url ); 
			navigateToURL( req , "_self");
		}
		private function onOver ( e: MouseEvent ):void
		{
			popUpClip.title_txt.text = this.xml.img[ e.currentTarget.id ].@sermintitle;
			popUpClip.index_txt.text = this.xml.img[ e.currentTarget.id ].@serminjangjul;
			popUpClip.pastor_txt.text = this.xml.img[ e.currentTarget.id ].@serminname;
			popUpClip.date_txt.text = "| " + this.xml.img[ e.currentTarget.id ].@sermindate;
			
			this.popUpClip.x = this.mouseX - ( stage.mouseX / maskClip.width * 160 );
			this.popUpClip.y = 3;
			Tweener.addTween( e.currentTarget , {alpha:1 , y:-moveUpHeight ,  time:0.2 , transition:"linear"} );
			//Tweener.addTween( this.popUpClip , {alpha:1 , y:0 ,  time:0.2 , transition:"linear"} );
			this.moveSpeed = 0;
		}
		private function onOut( e:MouseEvent ):void
		{
			Tweener.addTween( e.currentTarget , {alpha:0 , y:0 , time:0.2 , transition:"easeInCubic"} );
			//Tweener.addTween( this.popUpClip , {alpha:0 , y:100 ,  time:0.2 , transition:"linear"} );	
			this.popUpClip.y = -300;		
			this.moveSpeed = this.defaultSpeed;
		}
		private function onEnter( e: Event ):void
		{

			if( this.goDirection )
			{	// 방향 오른쪽이면
				if( this.x < -( bodyW - maskClip.width ) ) {
					this.goDirection = false;
					if ( this.moveSpeed != this.defaultSpeed )		this.moveSpeed = 0; 
				} else {
					this.x -= this.moveSpeed;
				}			
				

			}	else	{
				if( this.x > 0 ) {
					this.goDirection = true;
					if ( this.moveSpeed != this.defaultSpeed )		this.moveSpeed = 0;
				} else {
					this.x += this.moveSpeed;
				}	
			}
		}
	}
}