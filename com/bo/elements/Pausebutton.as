package com.bo.elements {
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	
	public class Pausebutton extends SimpleButton {
		
		
		public function Pausebutton() {
			// constructor code
			addEventListener(MouseEvent.MOUSE_OVER,onOver);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		private function onOver(evt:MouseEvent):void{
			trace('pause_button_over');
			Global._toolTip.show("暂停",this.x);
		}
		private function onOut(evt:MouseEvent):void{
			Global._toolTip.hide();
		}
	}
	
}
