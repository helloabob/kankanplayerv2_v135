package com.bo.elements {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class DarkVolumeSlider extends MovieClip {
		var ff:Boolean=false;
		public var vol:int=100;
		public function DarkVolumeSlider() {
			// constructor code
			init();
		}
		
		function init():void{
			addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			addEventListener(MouseEvent.MOUSE_UP,onUp);
			gotoAndStop(100);
		}

		public function changePosition(val:Number):void{
			gotoAndStop(val);
		}
		
		function onDown(evt:MouseEvent):void{
			calValue();
			gotoAndStop(vol);
			mydispatch();
			ff=true;
		}
		function onMove(evt:MouseEvent):void{
			if(ff){
				calValue()
				gotoAndStop(vol);
				mydispatch();
			}
		}
		function onUp(evt:MouseEvent):void{
			if(ff)ff=false;
		}
		private function calValue():void{
			var ss:Number=0;
			if(mouseX<0)ss=0;
			else if(mouseX>50)ss=50;
			else ss=mouseX;
			//trace(ss);
			vol=ss*2;
			//return ss*2;
		}
		private function mydispatch():void{
			dispatchEvent(new Event("volumeChange"));
		}
	}
	
}
