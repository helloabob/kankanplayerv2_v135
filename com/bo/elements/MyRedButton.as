package com.bo.elements
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MyRedButton extends ButtonBack
	{
		private var txt:TextField;
		private var tf:TextFormat=new TextFormat();
		public function MyRedButton(){
			width=100;
			height=25;
			tf.color=0xffffff;
			tf.align=TextFormatAlign.CENTER;
			tf.size=21;
			txt=new TextField();
			txt.width=50;
			txt.x=55;
			txt.y=7;
			txt.height=25;
			txt.defaultTextFormat=tf;
			txt.setTextFormat(tf);
			txt.selectable=false;
			txt.mouseEnabled=false;
			//txt.x=width/2-txt.width/2;
			//txt.y=height/2-txt.height/2;
			addChild(txt);
		}
		public function set Title(val:String):void{
			txt.text=val;
		}
	}
}