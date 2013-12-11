package com.bo.elements {
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.debugTip.DebugTip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
	
	public class DarkNormalScreenSymbol extends MovieClip {
		var sp:Sprite=new Sprite();
		
		public function DarkNormalScreenSymbol() {
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
			//this.stage.addEventListener(KeyboardEvent.KEY_UP,keyUpCheck);
		}
		
		protected function keyUpCheck(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.ESCAPE){
				DebugTip.instance.log("normalbtn or ese click1")
				//dispatchEvent(new Event("showSizeBtn"));
				if(Global._stage.displayState!=StageDisplayState.FULL_SCREEN){
					DebugTip.instance.log("normalbtn or ese click1")
					AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.NORMALSCREEN));
				}	
			}
			
		}
		private function onFull(evt:MouseEvent):void{
			Global._stage.displayState=StageDisplayState.NORMAL;
			//dispatchEvent(new Event("showSizeBtn"));
		}
		private function onOver(evt:MouseEvent):void{
			gotoAndStop(2);
			Global._toolTip.show("普通",this.x);
		}
		private function onOut(evt:MouseEvent):void{
			Global._toolTip.hide();
			gotoAndStop(1);
		}
	}
	
}
