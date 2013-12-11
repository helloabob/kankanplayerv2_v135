package com.bo.elements {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class DarkFullScreenSymbol extends MovieClip {
		var sp:Sprite=new Sprite();
		
		public function DarkFullScreenSymbol() {
			// constructor code
			sp.graphics.beginFill(0x000000,0);
			sp.x=-3;
			sp.y=-6;
			sp.graphics.drawRect(0,0,width+6,height+12);
			sp.graphics.endFill();
			addChild(sp);
			gotoAndStop(1);
			buttonMode=true;
		}
		public function registerEventListener():void{
			addEventListener(MouseEvent.MOUSE_OVER,onOver);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			addEventListener(MouseEvent.CLICK,onFull);
		}
		private function onFull(evt:MouseEvent):void{
			Global._stage.displayState=StageDisplayState.FULL_SCREEN;
			//dispatchEvent(new Event("hideSizeBtn"));
		}
		private function onOver(evt:MouseEvent):void{
			gotoAndStop(2);
			Global._toolTip.show("全屏",this.x);
		}
		private function onOut(evt:MouseEvent):void{
			Global._toolTip.hide();
			gotoAndStop(1);
		}
	}
	
}
