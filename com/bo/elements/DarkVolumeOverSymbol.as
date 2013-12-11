package com.bo.elements {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class DarkVolumeOverSymbol extends MovieClip {
		
		
		public function DarkVolumeOverSymbol() {
			// constructor code
			this.addEventListener(MouseEvent.CLICK,onclick);
		}
		private function onclick(evt:MouseEvent):void{
			dispatchEvent(new Event("volumeMuteChange"));
			
		}
	}
	
}
