package com.fwang.filter
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class FilterCollection
	{
		[Embed(source="blendmodes/ColorDodge.pbj",mimeType="application/octet-stream")]
		public var ColorDodge:Class;
		
		[Embed(source="blendmodes/Interpolation.pbj",mimeType="application/octet-stream")]
		public var Interpolation:Class;
		
		[Embed(source="blendmodes/Multiply.pbj",mimeType="application/octet-stream")]
		public var Multiply:Class;
		
		[Embed(source="blendmodes/autoLevel.pbj",mimeType="application/octet-stream")]
		public var AutoLevel:Class;
		
		[Embed(source="mosaic/MosaicFilter.pbj",mimeType="application/octet-stream")]
		public var Mosaic:Class;
		
		// 0:블러, 1:흑백, 2:채도감소, 3:채도증가, 4:세피아, 5:또렷한
		private const mat:Array = [
			[ 1, 1, 1, 1, 1,
				1, 3, 3, 3, 1,
				1, 3, 5, 3, 1,
				1, 3, 3, 3, 1,
				1, 1, 1, 1, 1 ],
			
			[ 0.3086, 0.6094, 0.082, 0, 0,
				0.3086, 0.6094, 0.082, 0, 0,
				0.3086, 0.6094, 0.082, 0, 0,
				0,      0,      0,     1, 0 ],
			
			[ 0.6543, 0.3047, 0.041, 0, 0,
				0.1543, 0.8047, 0.041, 0, 0,
				0.1543, 0.3047, 0.541, 0, 0,
				0,      0,      0,     1, 0,
				0,      0,      0,     0, 1 ],
			
			[ 1.2074, -0.1825, -0.0246, 0, 0,
				-0.0925, 1.1171, -0.0246, 0, 0,
				-0.0925, -0.1828, 1.2754, 0, 0,
				0,       0,      0,      1, 0,
				0,       0,      0,      0, 1 ],
			
			[ 0.3086, 0.6094, 0.082, 0, 60,
				0.3086, 0.6094, 0.082, 0, 30,
				0.3086, 0.6094, 0.082, 0, 0,
				0,      0,      0,     1, 0 ],
			
			[  0, -1,  0,
				-1, 10, -1,
				0,  -1,  0 ],
			
			[ 0, 1, 0,
				1, 0.05, 1,
				0, 1, 0 ]
			
		];
		
		public function FilterCollection()
		{
			
		}
		
		public function setGray( b:Bitmap ):void
		{
			applyFilter( b , mat[1] );
		}
		public function setSepia( b:Bitmap ):void
		{
			applyFilter( b , mat[4] );
		}
		
		public function applyFilter(child:DisplayObject , matrix:Array ):void {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters = child.filters;
			filters.push(filter);
			child.filters = filters;
			trace("child.filters : " + filters );
		}
		public function removeFilter( child:DisplayObject , idx:Number ):void
		{
			var filtersOrig:Array = new Array();
			var filters:Array = new Array();
			filtersOrig = child.filters;
			for( var ii:Number = 0 ; ii < filtersOrig.length ; ii++ )
			{
				if( ii != idx )
				{
					filters.push( filtersOrig[ii] );
				}
			}
			child.filters = filters;
		}
		
		// 로모 효과
		public function lomo(picBmd:BitmapData , degree:Number = 1 ): BitmapData
		{
			trace('orig lomo!!!1!!2222223344 ');
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			var shader:Shader = new Shader(new Multiply() as ByteArray);
			var satFilter:ColorMatrixFilter = new ColorMatrixFilter(mat[3]);
			
			var fType:String = GradientType.RADIAL;
			var colors:Array = [ 0xFFFFFF, 0x222222 ];
			var alphas:Array = [ 2, 2 ];
			var ratios:Array = [ 0, 255 ];
			var matr:Matrix = new Matrix();
			matr.createGradientBox( picBmd.width * degree , picBmd.height * degree , 0, ( -picBmd.width * degree + picBmd.width)/2 , ( -picBmd.height * degree + picBmd.height)/2 );
			var sprMethod:String = SpreadMethod.PAD;
			var sprite:Sprite = new Sprite();
			
			var g:Graphics = sprite.graphics;
			g.beginGradientFill( fType, colors, alphas, ratios, matr, sprMethod );
			g.drawRect(0, 0, picBmd.width, picBmd.height);
			
			picBmd.applyFilter(picBmd, rect, new Point(0, 0), satFilter);
			
			var lomoMask:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			lomoMask.draw(sprite);
			
			var lomoMaskBm:Bitmap = new Bitmap(lomoMask);
			var bgBm:Bitmap = new Bitmap(picBmd);
			
			lomoMaskBm.blendShader = shader;
			
			var s:Sprite = new Sprite();
			s.addChild(bgBm);
			s.addChild(lomoMaskBm);
			
			var lomoBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			lomoBmd.draw(s);
			
			return lomoBmd;
		}
		
		// 오래된
		public function backTotheFuture(picBmd:BitmapData): BitmapData
		{
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			var shader:Shader = new Shader(new Interpolation() as ByteArray);
			var shader2:Shader = new Shader(new ColorDodge() as ByteArray);
			var satFilter:ColorMatrixFilter = new ColorMatrixFilter(mat[2]);
			var blurFilter:BlurFilter = new BlurFilter(1.5, 1.5, 2);
			
			var seed:int = int(Math.random() * int.MAX_VALUE);
			var noiseBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			noiseBmd.noise(seed, 0, 200, BitmapDataChannel.ALPHA, true);
			
			var bgBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			bgBmd.draw(picBmd);
			bgBmd.applyFilter(bgBmd, rect, new Point(0, 0), satFilter);
			
			var bgBm:Bitmap = new Bitmap(bgBmd);
			var noiseBm:Bitmap = new Bitmap(noiseBmd);
			
			var s:Sprite = new Sprite();
			s.addChild(bgBm);
			s.addChild(noiseBm);
			
			var noiseLayerData:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			noiseLayerData.draw(s);
			noiseLayerData.applyFilter(noiseLayerData, rect, new Point(0, 0), blurFilter);
			
			var bgLayer:Bitmap = new Bitmap(bgBmd);
			var noiseLayer:Bitmap = new Bitmap(noiseLayerData);
			
			noiseLayer.blendShader = shader;
			
			var s2:Sprite = new Sprite();
			s2.addChild(bgLayer);
			s2.addChild(noiseLayer);
			
			var btfBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			btfBmd.draw(s2);
			
			return btfBmd;
			
		}
		
		// 화사한 효과
		public function luxury(picBmd:BitmapData): BitmapData
		{
			var blurFilter:ConvolutionFilter = new ConvolutionFilter(5, 5, mat[0], 45);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			
			var mergeBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var blendBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			blendBmd.applyFilter(picBmd, rect, new Point(0, 0), blurFilter);
			
			mergeBmd.draw(picBmd);
			mergeBmd.draw(blendBmd, null, null, BlendMode.SCREEN);
			
			return mergeBmd;
		}
		
		// 스케치
		public function sketch(picBmd:BitmapData): BitmapData
		{
			var shader:Shader = new Shader(new ColorDodge() as ByteArray);
			var blurFilter:BlurFilter = new BlurFilter(8, 8, 2);
			var grayFilter:ColorMatrixFilter = new ColorMatrixFilter(mat[1]);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			
			var mergeBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var grayBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var invertBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			
			grayBmd.applyFilter(picBmd, rect, new Point(0, 0), grayFilter);
			invertBmd.draw(grayBmd);
			invertBmd.draw(invertBmd, null, null, BlendMode.INVERT);
			invertBmd.applyFilter(invertBmd, rect, new Point(0, 0), blurFilter);
			
			var bg:Bitmap = new Bitmap(grayBmd);
			var fg:Bitmap = new Bitmap(invertBmd);
			
			fg.blendShader = shader;
			
			var s:Sprite = new Sprite();						
			s.addChild(bg);
			s.addChild(fg);
			//this.addChild(s);
			
			var bmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			bmd.draw(s);
			
			return bmd;
		}
		
		// 흑백톤
		public function grayScale(picBmd:BitmapData): BitmapData
		{
			var grayFilter:ColorMatrixFilter = new ColorMatrixFilter(mat[1]);
			var grayBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			grayBmd.applyFilter(picBmd, rect, new Point(0,0), grayFilter);
			
			return grayBmd;
		}
		
		// 갈색톤
		public function sepia(picBmd:BitmapData): BitmapData
		{
			var grayFilter:ColorMatrixFilter = new ColorMatrixFilter(mat[4]);
			var sepiaBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			sepiaBmd.applyFilter(picBmd, rect, new Point(0,0), grayFilter);
			
			return sepiaBmd;
		}
		
		// 또렷한
		public function sharpen(picBmd:BitmapData): BitmapData
		{
			var sharpenFilter:ConvolutionFilter = new ConvolutionFilter(3, 3, mat[5], 6);
			var sharpenBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			sharpenBmd.applyFilter(picBmd, rect, new Point(0,0), sharpenFilter);
			
			return sharpenBmd;
		}
		
		// 자동 조절
		public function autoLevel(picBmd:BitmapData): BitmapData
		{
			var s:Shader = new Shader(new AutoLevel() as ByteArray);
			var sf:ShaderFilter = new ShaderFilter(s);
			var autoLevelBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			autoLevelBmd.applyFilter(picBmd, rect, new Point(0,0), sf);
			
			return autoLevelBmd;
		}
		
		// 모자이크 효과
		public function mosaic(picBmd:BitmapData, size:Number): BitmapData
		{
			var s:Shader = new Shader(new Mosaic() as ByteArray);
			var sf:ShaderFilter = new ShaderFilter(s);
			var mosaicBmd:BitmapData = new BitmapData(picBmd.width, picBmd.height);
			var rect:Rectangle = new Rectangle(0, 0, picBmd.width, picBmd.height);
			s.data.size.value = [size];
			mosaicBmd.applyFilter(picBmd, rect, new Point(0, 0), sf);
			
			return mosaicBmd;
		}
		
		// blur 효과
		public function blur(): ConvolutionFilter
		{
			var blurFilter:ConvolutionFilter = new ConvolutionFilter(3, 3, mat[6], 4.05);
			return blurFilter;
		}
		
	}
}