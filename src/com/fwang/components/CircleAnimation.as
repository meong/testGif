package com.fwang.components
{
	/**
	 * 
	 * CIRCLE ANIMATION
	 * 
	 * @date 07/2008
	 * @author Kay
	 * @hompage http://improgrammer.com
	 * @e-mail mr_chun@naver.com 
	 */		
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class CircleAnimation extends Sprite
	{
		public var timer:Timer;
		private var tailNumber:int;
		private var r:int;
		private var delay:int;

		//작은원 속성
		private var circleNumber:int;
		private var circleR:int;
		private var circleColor:uint;

		//작은원 좌표 
		private var radPoints:Array;

		//지금 돌고있는 위치
		private var currentPoint:int;
		
		//원들
		private var circle:Shape;
		private var circleTail:Shape;
		
		/**
		* @param r  : 큰원의 반지름
		* @param circleNumber : 작은원의 갯수
		* @param circleR : 작은원의 반지름
		* @param delay : 딜레이
		* @param circleColor : 작은원의 색상
		* @param tailNumber : 꼬리의 길이
		 * */		 
		public function CircleAnimation(r:int=20, circleNumber:int=12, circleR:int=8, tailNumber:int=4, circleColor:uint=0x00, delay:Number=.1)
		{
			super();
			this.tailNumber = tailNumber;
			this.r = r;
			this.delay = delay*1000;
			this.circleNumber = circleNumber;
			this.circleR = circleR;
			this.circleColor = circleColor;
			this.currentPoint = tailNumber; // 현재 돌고있는 위치의 초기값은 꼬리 값으로
			this.radPoints = new Array;
			init();
		}
		
		private function init() : void
		{
			makeTimer();
			getRadPoints();
			drawCircle();
			drawActivityCircle();
		}
		
		
		/** 타이머 **/
		private function makeTimer() : void
		{
			timer = new Timer(delay,0);	
			timer.addEventListener(TimerEvent.TIMER, onLoop);		
		}
		private function onLoop( e:TimerEvent ) : void
		{
			circleTail.rotation += 360/circleNumber; 			
		}		
		
		
		/** 작은원들의 위치를 구함 **/
		private function getRadPoints() : void
		{
			var seg:int = Math.floor(360/circleNumber);
			for(var i:int; i<circleNumber; ++i) {
				radPoints.push(getRadPoint(r, seg*i));
			}
		}


		/** 작은원 그리기 **/
		private function drawCircle() : void
		{
			circle = new Shape;
			var g:Graphics = circle.graphics;
			for(var i:int=0; i<circleNumber; ++i) {
				g.beginFill(circleColor,.2);
				g.drawCircle(radPoints[i].x,radPoints[i].y,circleR*.5);
				g.endFill();
			}
			addChild(circle);
		}		
		/** 움직이는원 그리기 **/
		private function drawActivityCircle() : void
		{
			circleTail = new Shape;
			for(var i:int=0; i<tailNumber; ++i) {
				circleTail.graphics.beginFill(circleColor,1/tailNumber*i);
				circleTail.graphics.drawCircle(radPoints[i].x,radPoints[i].y,circleR*.5);
				circleTail.graphics.endFill();
			}
			addChild(circleTail);
		}


		/** 외부 제어 **/
		public function onStart() : void
		{
			timer.start();	
		}		
		public function onRemove() : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onLoop);
			removeChild(circle);
			removeChild(circleTail);
			timer = null;
			circle = null;
			circleTail = null;
		}


		/** 호도법을 이용해 원주를 도는 점들을 구함 **/
		private function getRadPoint(r:Number, degree:Number) : Point
		{
			var rad:Number = degree*Math.PI/180;
			var point:Point = new Point;
			point.x = r*Math.cos(rad);
			point.y = r*Math.sin(rad);
			return point;
		}		
	}

}