package com.bo.elements {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	
	public class Volumebar extends MovieClip {
		private var volOver:MovieClip=new DarkVolumeOverSymbol();
		private var volUp:MovieClip=new DarkVolumeUpSymbol();
		private var divider:MovieClip=new DarkButtonDivider();
		private var txttime:TextField=new TextField();
		private var slider:MovieClip=new DarkVolumeSlider();
		private var volmask:Sprite=new Sprite();
		private var volback:Sprite=new Sprite();
		private var movedistance:int=60;
		private var movespeed:int=10;
		private var isOver:Boolean=false;
		private var movetimer:Timer=new Timer(40,movedistance/movespeed);
		private var sp2:Sprite=new Sprite();
		
		private var cur_vol_pos:Number=0;
		
		public function Volumebar() {
			// constructor code
			volback.graphics.beginFill(0x00ff00,0);
			volback.graphics.drawRect(0,0,40,30);
			volback.graphics.endFill();
			volback.buttonMode=true;
			addChild(volback);
			//volUp.gotoAndStop(4);
			volUp.x=5;
			volUp.y=3;
			//volOver.gotoAndStop(4);
			volOver.x=5;
			volOver.y=3;
			volOver.visible=false;
			volOver.addEventListener("volumeMuteChange",onMuteChange);
			movevolicon(3);
			volback.addChild(volUp);
			volback.addChild(volOver);
			slider.x=40;
			slider.y=7.5;
			slider.addEventListener("volumeChange",onVolumeChange);
			volback.addChild(slider);
			volmask.graphics.beginFill(0x000000,0.5);
			volmask.graphics.drawRect(0,0,40,30);
			volmask.graphics.endFill();
			volback.addEventListener(MouseEvent.ROLL_OVER,onOver);
			volback.addEventListener(MouseEvent.ROLL_OUT,onOut);
			addChild(volmask);
			volback.mask=volmask;
			
			sp2.x=40;
			addChild(sp2);
			//divider.x=40;
			sp2.addChild(divider);
			
			Global.txttime=txttime;
			txttime.text="0:00/0:00";
			txttime.textColor=0x666666;
			txttime.selectable=false;
			txttime.x=7;
			txttime.y=6;
			sp2.addChild(txttime);
			
			movetimer.addEventListener(TimerEvent.TIMER,onTimerMove);
			
		}
		private function movevolicon(kf:int):void{
			volUp.gotoAndStop(kf);
			volOver.gotoAndStop(kf);
		}
		private function onMuteChange(evt:Event):void{
			trace('vv:'+Global.mps.mediaPlayer.volume+"__pos:"+cur_vol_pos);
			if(Global.mps.mediaPlayer.volume==0){
				Global.mps.mediaPlayer.volume=cur_vol_pos/100;
				if(cur_vol_pos>70){
					movevolicon(4);
				}else if(slider.vol>30){
					movevolicon(3);
				}else if(slider.vol>2){
					movevolicon(2);
				}else{
					movevolicon(1);
					Global.mps.mediaPlayer.volume=0;
				}
				slider.changePosition(cur_vol_pos);
			}else{
				cur_vol_pos=slider.vol;
				Global.mps.mediaPlayer.volume=0;
				movevolicon(1);
				slider.changePosition(0);
			}
		}
		private function onVolumeChange(evt:Event):void{
			trace(slider.vol);
			cur_vol_pos=slider.vol;
			Global.mps.mediaPlayer.volume=cur_vol_pos/100;
			if(cur_vol_pos>70){
				movevolicon(4);
			}else if(slider.vol>30){
				movevolicon(3);
			}else if(slider.vol>2){
				movevolicon(2);
			}else{
				movevolicon(1);
				Global.mps.mediaPlayer.volume=0;
			}
			
		}
		private function onTimerMove(evt:TimerEvent):void{
			if(!isOver){
				sp2.x-=(movespeed);
				volmask.width-=(movespeed);
			}
		}
		private function onOut(evt:MouseEvent):void{
			if(isOver){
				isOver=false;
				volOver.visible=false;
				volback.graphics.clear();
				volback.graphics.beginFill(0x00ff00,0);
				volback.graphics.drawRect(0,0,40,30);
				volback.graphics.endFill();
				movetimer.reset();
				movetimer.start();
				//sp2.x-=movedistance;
				//volmask.width-=movedistance;
				trace(volback.width);
				Global._toolTip.hide();
			}
		}
		private function onOver(evt:MouseEvent):void{
			//if(!isOver){
				isOver=true;
				volOver.visible=true;
				volback.graphics.clear();
				volback.graphics.beginFill(0x00ff00,0);
				volback.graphics.drawRect(0,0,40+movedistance,30);
				volback.graphics.endFill();
				sp2.x=40+movedistance;
				volmask.width=40+movedistance;
				movetimer.reset();
				trace(volback.width);
				Global._toolTip.show("音量",this.x);
			//}
		}
	}
	
}
