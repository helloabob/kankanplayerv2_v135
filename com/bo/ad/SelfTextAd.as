package com.bo.ad {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import flash.net.URLLoader;

	
	public class SelfTextAd extends Sprite{
		
		private var cur:int=1;
		private var timer:Timer;
		private var ma:Sprite;
		private var sp:Sprite;
		private var lbl:TextField;
		private var lbl2:TextField;
		
		private var base:Sprite;
		
		public function SelfTextAd() {
			// constructor code
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,200,28);
			this.graphics.endFill();
			
			/*base=new Sprite();
			base.graphics.beginFill(0x000000,0);
			base.graphics.drawRect(0,0,200,28);
			base.graphics.endFill();
			addChild(base);*/

			var ma:Sprite=new Sprite();
			ma.graphics.beginFill(0x000000,1);
			ma.graphics.drawRect(0,0,200,28);
			ma.graphics.endFill();
			addChild(ma);
			this.mask=ma;
			
			var tf:TextFormat=new TextFormat();
			tf.align=TextFormatAlign.CENTER;
			tf.size=13;

			lbl=new TextField();
			lbl.text=Global.adParameter.TextAdArray[cur].text;
			lbl.textColor=0xffffff;
			lbl.width=200;
			lbl.height=28;
			lbl.mouseEnabled=false;
			lbl.setTextFormat(tf);
			lbl.defaultTextFormat=tf;
			lbl.selectable=false;
			
			addChild(lbl);
			
			trace(Global.adParameter.TextAdArray[cur].text+"=="+Global.adParameter.TextAdArray.length);
			
			if(Global.adParameter.TextAdArray.length>2){
				lbl2=new TextField();
				lbl2.text=Global.adParameter.TextAdArray[getNext(cur)].text;
				lbl2.textColor=0xffffff;
				lbl2.width=200;
				lbl2.height=28;
				lbl2.mouseEnabled=false;
				lbl2.defaultTextFormat=tf;
				lbl2.setTextFormat(tf);
				lbl2.selectable=false;
				lbl2.y=28;

				timer=new Timer(40,14);
				timer.addEventListener(TimerEvent.TIMER,ontimer);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,oncomp);
				timer.start();

				addChild(lbl2);
			}
			sp=new Sprite();
			sp.graphics.beginFill(0x000000,0);
			sp.graphics.drawRect(0,0,200,28);
			sp.graphics.endFill();
			sp.buttonMode=true;
			sp.addEventListener(MouseEvent.CLICK,onlink);
			addChild(sp);
			


			
		}
		
		private function onlink(evt:MouseEvent):void{
			flash.net.navigateToURL(new URLRequest(Global.adParameter.TextAdArray[cur].link),"_blank");
			var ld:URLLoader=new URLLoader();
			ld.load(new URLRequest(Global.adParameter.TextAdArray[cur].sta));
		}
		
		private function getNext(now:int):int{
			if(now==Global.adParameter.TextAdArray.length-1){
				return 1;
			}else{
				return now+1;
			}
		}
		private function ontimer(evt:TimerEvent):void{
			//curlbl.y-=2;
			lbl.y-=2;
			if(lbl2)lbl2.y-=2;
		}
		private function oncomp(evt:TimerEvent):void{
			cur=getNext(cur);
			if(lbl.y==0){
				//curlbl=lbl2;
				lbl2.y=28;
				lbl2.text=Global.adParameter.TextAdArray[getNext(cur)].text;
			}else{
				//curlbl=lbl;
				lbl.y=28;
				lbl.text=Global.adParameter.TextAdArray[getNext(cur)].text;
			}
			
			flash.utils.setTimeout(restart,int(Global.adParameter.TextAdArray[0].sec)*100);
		}
		private function restart():void{
			timer.reset();
			timer.start();
		}
	}
	
}



/*

this.graphics.beginFill(0x000000,0.5);
this.graphics.drawRect(0,0,200,28);
this.graphics.endFill();
this.buttonMode=true;

var ma:Sprite=new Sprite();
ma.graphics.beginFill(0x000000,1);
ma.graphics.drawRect(0,0,200,28);
ma.graphics.endFill();
ma.buttonMode=true;
this.mask=ma;


var tf:TextFormat=new TextFormat();
tf.align=TextFormatAlign.CENTER;
tf.size=13;

var lbl:TextField=new TextField();
lbl.text="第二条文字链内容";
lbl.textColor=0xffffff;
lbl.width=200;
lbl.height=28;
lbl.mouseEnabled=false;
lbl.setTextFormat(tf);
lbl.selectable=false;

var lbl2:TextField=new TextField();
lbl2.text="第三条文字链内容";
lbl2.textColor=0xffffff;
lbl2.width=200;
lbl2.height=28;
lbl2.mouseEnabled=false;
lbl2.setTextFormat(tf);
lbl2.selectable=false;
lbl2.y=28;


var timer:Timer=new Timer(40,14);
timer.addEventListener(TimerEvent.TIMER,ontimer);
timer.addEventListener(TimerEvent.TIMER_COMPLETE,oncomp);
timer.start();

addChild(lbl);
addChild(lbl2);

var sp:Sprite=new Sprite();
sp.graphics.beginFill(0x000000,0);
sp.graphics.drawRect(0,0,200,28);
sp.graphics.endFill();
sp.buttonMode=true;

addChild(sp);

var curlbl:TextField;

curlbl=lbl;

function ontimer(evt:TimerEvent):void{
	//curlbl.y-=2;
	lbl.y-=2;
	lbl2.y-=2;
}
function oncomp(evt:TimerEvent):void{
	if(lbl.y==0){
		//curlbl=lbl2;
		lbl2.y=28;
	}else{
		//curlbl=lbl;
		lbl.y=28;
	}
	flash.utils.setTimeout(restart,3000);
}
function restart():void{
	timer.reset();
	timer.start();
}

*/