package com.bo.elements {
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	
	public class Playbutton extends SimpleButton {
		
		
		public function Playbutton() {
			// constructor code
			addEventListener(MouseEvent.MOUSE_OVER,onOver);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		private function onOver(evt:MouseEvent):void{
			trace('play_button_over');
			Global._toolTip.show("播放",this.x);
		}
		private function onOut(evt:MouseEvent):void{
			Global._toolTip.hide();
		}
	}
	
}
