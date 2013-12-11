package com.bo.ad
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AdCount extends Sprite
	{
		private var txt:String="广告剩余  秒";
		private var textField:TextField;
		private var tf:TextFormat=new TextFormat();
		public function AdCount(){
			tf.color=0xffffff;
			textField=new TextField();
			textField.defaultTextFormat=tf;
			textField.setTextFormat(tf);
			textField.selectable=false;
			//textField.text=txt;
			addChild(textField);
		}
		public function set Txt(val:String):void{
			textField.text="广告剩余"+val+"秒";
		}
		public function dispose():void{
			textField=null;
			tf=null;
		}
	}
}