package com.bo.elements {
	
	import flash.display.MovieClip;
	
	
	public class Tooltip extends MovieClip {
		
		
		public function Tooltip() {
			// constructor code
			this.y=-25;
		}
		public function show(tt:String,__x:Number):void{
			this.txt.text=tt;
			this.x=__x+5;
			this.visible=true;
		}
		public function hide():void{
			this.visible=false;
		}
	}
	
}
