package com.bo.elements
{
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.bo.ad.BottomAd;
	import com.bo.ad.GoogleAds;
	import com.bo.ad.SelfTextAd;
	import com.bo.events.MyEvent;
	import com.debugTip.DebugTip;
	import com.gridsum.VideoTracker.GSVideoState;
	import com.mvc.model.AdXmlModel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerState;

	public class Mycontrolbar extends Sprite
	{
		var playSymbol:SimpleButton;
		var pauseSymbol:SimpleButton;
		var back:Sprite;
		var red0:Sprite                =new Sprite();
		var yellow0:Sprite             =new Sprite();
		var grey0:Sprite               =new Sprite();
		var greyBack:Sprite            =new Sprite();
		var black0:Sprite              =new Sprite();
		var pgrbtn:DarkProgressButton  =new DarkProgressButton();
		var xx:Number                  =10;
		var isOver:Boolean             =true;
		var volbar:MovieClip           =new Volumebar();
		var full:MovieClip             =new DarkFullScreenSymbol();
		var normal:MovieClip           =new DarkNormalScreenSymbol();
		var redcolor:Object            =0xdcb627;
		var barheight:int              =3;
		var bottomad:Sprite;
		
		public var currentMediaType:int=1; //0:prefix ad  1:video  2:suffix ad
		
		private var hasShowAd:Boolean  =false;
		private var hasPaused:Boolean  =false;
		private var overlayads:*;
		private var adpanel:Sprite     =new Sprite();
		private var msb:MyShotButton;
		private var mysharebutton:MyShareButton;
		private var timer:Timer;
		private var tabBarSmallerItem:TabBarItemBase;
		private var tabBarLargerItem:TabBarItemBase;
		private var bufferLengh:int;
		private var pgrBtnState:String="";

		private var toolTip:Tooltip    =new Tooltip();

		private var sta:SelfTextAd;
		
		private var canRegister:Boolean = true;

		public function Mycontrolbar()
		{
			// constructor code
			init();
		}

		public function registerEventListener():void
		{
			if(canRegister==false)return;
			canRegister=true;
			DebugTip.instance.log("bar_registerEventListener");
			if (Global.playerparameter.islive == "false")
			{
				grey0.addEventListener(MouseEvent.MOUSE_DOWN,onGreyDown);
			}

			playSymbol.addEventListener(MouseEvent.CLICK,onPlay);
			
			pauseSymbol.addEventListener(MouseEvent.CLICK,onPause);
			
			pgrbtn.addEventListener(MouseEvent.MOUSE_DOWN,onPgrMouseDn);
			pgrbtn.addEventListener(MouseEvent.MOUSE_UP,onPgrMouseUp);
			pgrbtn.addEventListener("onMouseUpOutSide",onPgrMouseUp);
			
			if (!timer)
			{
				timer=new Timer(100);
				timer.addEventListener(TimerEvent.TIMER,onTimer);
				timer.start();
			}
			Global._stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
			full.registerEventListener();
			normal.registerEventListener();
			if (mysharebutton)
				mysharebutton.registerEventListener();
			if (msb)
				msb.registerEventListener();
			if (this.tabBarLargerItem)
				this.tabBarLargerItem.initComplete=true;
			if (this.tabBarSmallerItem)
				this.tabBarSmallerItem.initComplete=true;

			trace("===============" + Global.adParameter.hasTextAd + "==========");
			if (Global.adParameter.hasTextAd && !sta)
			{
				sta=new SelfTextAd();
				sta.x=Global.txttime.x + Global.txttime.width + 100;
				sta.y=5;
				addChild(sta);

				//allyes adsystem
				DebugTip.instance.log("ALLYES :REQUEST TEXTAD:"+AdXmlModel.instance.getTextAdList.sc.toString())
				var urlLoader1:URLLoader=new URLLoader(new URLRequest(AdXmlModel.instance.getTextAdList.sc.toString()));
				
			}
		}
		
		
		protected function onPgrMouseUp(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			// TODO Auto-generated method stub
			if(pgrBtnState!="onMouseUpOutSide")
			onGreyDown();
			
			pgrBtnState="onMouseUp";
			pgrbtn.removeEventListener(Event.ENTER_FRAME,asynWithX);
		}
		
		protected function asynWithX(event:Event):void
		{
			// TODO Auto-generated method stub
			pgrbtn.x=stage.mouseX;
		}
		
		protected function onPgrMouseDn(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			pgrBtnState="onMouseDn";
			pgrbtn.buttonMode=true;
			pgrbtn.addEventListener(Event.ENTER_FRAME,asynWithX)
			stage.addEventListener(MouseEvent.MOUSE_UP,checkUpOutSide);	
		}
		
		protected function checkUpOutSide(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			pgrBtnState="onMouseUpOutSide";
			stage.removeEventListener(MouseEvent.MOUSE_UP,checkUpOutSide);	
			pgrbtn.dispatchEvent(new MouseEvent("onMouseUpOutSide"));
		}
		
		private function init():void
		{

			y=Global.appHeight - 29;

			black0.y=-3;
			//black1.y=-7;
			addChild(black0);


			grey0.y=-3;
			grey0.buttonMode=true;
			//grey1.y=-7;
			addChild(grey0);

			greyBack.graphics.beginFill(0x00cc00,1);
			greyBack.graphics.drawRect(0,0,Global.appWidth,7);
			greyBack.graphics.endFill();
			grey0.addChild(greyBack);
			greyBack.alpha=0;

			red0.y=-3;
			//red1.y=-7;
			red0.mouseEnabled=false;
			addChild(red0);
			pgrbtn.y=-12;

			yellow0.y=-3;
			trytoshow();


			//addChild(yellow0);

			back=new DarkControlBarBg();
			back.width=Global.appWidth;
			addChild(back);

			pauseSymbol=new Pausebutton();
			pauseSymbol.visible=false;
			addChild(pauseSymbol);
			playSymbol=new Playbutton();
			//overout(playSymbol);
			addChild(playSymbol);

			var line1:Sprite        =new DarkButtonDivider();
			line1.x=playSymbol.width;
			addChild(line1);
			addChild(pgrbtn);
			pgrbtn.x+=pgrbtn.width/2;
			pgrbtn.y+=pgrbtn.height/2;
			pgrbtn.visible=false;

			volbar.x=line1.x;
			addChild(volbar);

			full.x=Global.appWidth - full.width - 5;
			full.y=6;
			normal.x=Global.appWidth - normal.width - 5;
			normal.y=6;
			normal.visible=false;
			//full.gotoAndStop(1);
			addChild(full);
			addChild(normal);

			var elementPositionX:int=full.x - 10;
			if (Global.playerparameter.issizechangable == "true")
			{
				this.tabBarLargerItem=new TabBarItemBase(TabBarItemBaseType.LargerSymbol,30,30);
				this.tabBarLargerItem.x=elementPositionX - this.tabBarLargerItem.width;
				this.tabBarLargerItem.addEventListener("onItemDown",onTabBarChange);
				this.tabBarLargerItem.mouseEnabled=false;
				this.tabBarLargerItem.changeState(true);
				addChild(this.tabBarLargerItem);
				elementPositionX-=this.tabBarLargerItem.width;

				this.tabBarSmallerItem=new TabBarItemBase(TabBarItemBaseType.SmallerSymbol,30,30);
				this.tabBarSmallerItem.x=elementPositionX - this.tabBarSmallerItem.width;
				this.tabBarSmallerItem.addEventListener("onItemDown",onTabBarChange);
				this.tabBarSmallerItem.mouseEnabled=false;
				//this.tabBarSmallerItem.changeState(true);
				addChild(this.tabBarSmallerItem);
				elementPositionX-=this.tabBarSmallerItem.width;
				
			}
			if (Global.playerparameter.isShare == "true")
			{
				mysharebutton=new MyShareButton();
				//mysharebutton.x=full.x-40;
				mysharebutton.x=elementPositionX - this.mysharebutton.width;
				mysharebutton.mouseEnabled=false;
				addChild(mysharebutton);
				elementPositionX-=this.mysharebutton.width;
			}
			if (Global.playerparameter.isShot == "true")
			{
				msb=new MyShotButton();
				//msb.x=full.x-71;
				msb.x=elementPositionX - this.msb.width;
				msb.mouseEnabled=false;
				addChild(msb);
				elementPositionX-=this.msb.width;
			}
			
			trace("mycontrolbar islive:",Global.playerparameter.islive)
			if (Global.playerparameter.islive == "true")
			{
				//return;
				black0.visible=false;
				grey0.visible=false;
				red0.visible=false;
				pgrbtn.visible=false;
				yellow0.visible=false;
				Global.txttime.visible=false;
			}

			addChild(this.toolTip);
			toolTip.hide();
			Global._toolTip=this.toolTip;

		}

		private function onTabBarChange(evt:Event):void
		{
			if (evt.target == this.tabBarLargerItem)
			{
				this.tabBarSmallerItem.changeState(false);
			}
			else
			{
				this.tabBarLargerItem.changeState(false);
			}
		}

		public function showyellowdot():void
		{
			if (Global.playerparameter.isAd == "true" && Global.adParameter.overlayAdType == 1 && Global.mps)
			{

				yellow0.x=Global.appWidth * Global.adParameter.adstarttime / Global.mps.mediaPlayer.duration;
				addChildAt(yellow0,getChildIndex(red0 as DisplayObject) + 1);
			}
		}

		private function trytoshow():void
		{
			if (Global.mps)
			{
				yellow0.x=Global.appWidth * Global.adParameter.adstarttime / Global.mps.mediaPlayer.duration;
			}
			else
			{
				setTimeout(trytoshow,1000);
			}
		}

		public function rearrange():void
		{
			
			DebugTip.instance.log("bar resize");
			y=Global.appHeight - 29;
			adpanel.width=Global.appWidth;
			adpanel.height=Global.appHeight - 29;
			back.width=Global.appWidth;
			greyBack.width=Global.appWidth;
			full.x=Global.appWidth - full.width - 5;
			normal.x=Global.appWidth - normal.width - 5;

			var elementPositionX:int=full.x - 10;
			if (Global.playerparameter.issizechangable == "true")
			{
				this.tabBarLargerItem.x=elementPositionX - this.tabBarLargerItem.width;
				elementPositionX-=this.tabBarLargerItem.width;
				this.tabBarSmallerItem.x=elementPositionX - this.tabBarSmallerItem.width;
				elementPositionX-=this.tabBarSmallerItem.width;
				
				if(stage.displayState==StageDisplayState.NORMAL){
					DebugTip.instance.log("normalbtn or ese click2")
					tabBarLargerItem.visible=true;
					tabBarSmallerItem.visible=true;
				}
				else if(stage.displayState==StageDisplayState.FULL_SCREEN){
					tabBarLargerItem.visible=false;
					tabBarSmallerItem.visible=false;
				
				}
				
			}
			if (Global.playerparameter.isShare == "true")
			{
				mysharebutton.x=elementPositionX - this.mysharebutton.width;
				elementPositionX-=this.mysharebutton.width;
			}
			if (Global.playerparameter.isShot == "true")
			{
				msb.x=elementPositionX - this.msb.width;
				elementPositionX-=this.msb.width;
			}

			if (bottomad)
				bottomad.x=Global.appWidth / 2 - bottomad.width / 2;
			if (Global._stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				normal.visible=true;
				full.visible=false;
				if (Global.playerparameter.isShare == "true")
					mysharebutton.visible=false;
				if (Global.playerparameter.isShot == "true")
					msb.visible=false;
			}
			else
			{
				normal.visible=false;
				full.visible=true;
				if (Global.playerparameter.isShare == "true")
					mysharebutton.visible=true;
				if (Global.playerparameter.isShot == "true")
					msb.visible=true;
			}
			if (overlayads)
				overlayads.rearrange();
			if (Global.playtype == 0)
				showyellowdot();
			//trytoshow();
		}

		private function onGreyDown(evt:MouseEvent=null):void
		{
			if(evt){
				evt.stopImmediatePropagation();
			}
			
			/*
			如果名字一样的mp4,duration 用cacheTotalTime,
			pgrbtn的x坐标
			*/
			//mp4
			var mySeekTime:Number=mouseX / Global.appWidth * (Global.crtMediaInfo["totalTime"]);
			DebugTip.instance.log("缓冲条长度"+bufferLengh+",点击x坐标："+mouseX);
			//国双分析
			Global.tracker.changeState(GSVideoState.SEEKING);
			Global.ignoreBuffer=true;
			if (Global.playtype == 0)
			{
				//duration>0才可进行跳播；
				if (!Global.mps.mediaPlayer.duration)
					return;

				//读缓存or跳播
				if (mouseX > Global.crtMediaInfo["seekX"] && mouseX < bufferLengh)
				{
					if (Global.videodata.videourl.indexOf(".mp4") > 0)
					{
						mySeekTime=(mouseX - Global.crtMediaInfo["seekX"]) / (Global.appWidth - Global.crtMediaInfo["seekX"]) * (Global.mps.mediaPlayer.duration);
					}
					Global.mps.mediaPlayer.seek(mySeekTime);
				}
				else
				{
					//跳播
					if (Global.videodata.videourl.indexOf(".mp4") > 0)
					{
						//影片长度大于0秒才进行跳播
						if (Global.crtMediaInfo["totalTime"] > 0)
						{
							dispatchEvent(new MyEvent(MyEvent.SEEKMEDIA,{seekTime: mySeekTime,seekX: mouseX}));
						}
						else
						{
							Global.mps.mediaPlayer.seek(mySeekTime);
						}
					}
					else
					{
						Global.mps.mediaPlayer.seek(mySeekTime);
					}
				}

				//有缓存数据时按钮才能移动
				if (Global.mps.mediaPlayer.duration > 0)
				{
					pgrbtn.x=mouseX;
				}
			}
		}

		private function onPlay(evt:MouseEvent):void
		{
			DebugTip.instance.log("mycontroller currentTime:"+int(Global.mps.mediaPlayer.currentTime) +"||duration:"+ int(Global.mps.mediaPlayer.duration));
			if (int(Global.mps.mediaPlayer.currentTime)==int(Global.mps.mediaPlayer.duration)
				||Global.playerparameter.autoPlay == "false" 
				&& (!Global.mps.mediaPlayer.playing) 
				&& (!hasPaused) )
			{
				DebugTip.instance.log("mycontroller play init");
				hasPaused=true;
				Global.main.initAndPlayVideo();
			}
			else
			{
				DebugTip.instance.log("mycontroller play from url");
				if(Global.videodata.videourl=="rtmp://live.kksmg.com:80/live/mp4:Stream_1"){
					Global.main.initAndPlayVideo();
				}else{
					Global.mps.mediaPlayer.play();
				}
			}
		}

		private function onPause(evt:MouseEvent):void
		{
			Global.mps.mediaPlayer.pause();
		}

		private function onStageMove(evt:MouseEvent):void
		{
			//evt.stopImmediatePropagation();
			if (Global.playtype == 0)
			{
				y=Global.appHeight - 29;
				trace('over');
				isOver=true;
				red0.y=-7;
				grey0.y=-7;
				black0.y=-7;
				yellow0.y=-7;

				if (Global.playerparameter.islive == "false")
				{
					pgrbtn.visible=true;
				}

				Global._stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
				setTimeout(myTimeout,3000);
			}
		}

		public function mediaPlayerStateChange(evt:MediaPlayerStateChangeEvent):void
		{
			switch (evt.state)
			{
				case MediaPlayerState.PLAYING:
				{
					playSymbol.visible=false;
					pauseSymbol.visible=true;
					break;
				}
				case MediaPlayerState.PAUSED:
				{
					playSymbol.visible=true;
					pauseSymbol.visible=false;
					break;
				}
				case MediaPlayerState.READY:
				{
					playSymbol.visible=true;
					pauseSymbol.visible=false;
					break;
				}
			}
			//trace(evt.state);
		}

		private function myTimeout():void
		{
			isOver=false;
			red0.y=-3;
			grey0.y=-3;
			black0.y=-3;
			yellow0.y=-3;
		
			pgrbtn.visible=false;
			if (Global._stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				y=Global.appHeight;
			}
			Global._stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
		}

		private function onStageOver(evt:MouseEvent):void
		{
			//evt.stopImmediatePropagation();
			trace('over');
			isOver=true;
			red0.y=-7;
			grey0.y=-7;
			black0.y=-7;

			if (!contains(pgrbtn))
				addChild(pgrbtn);
		}

		private function onStageOut(evt:MouseEvent):void
		{
			//evt.stopImmediatePropagation();
			trace('out');
			isOver=false;
			red0.y=-3;
			grey0.y=-3;
			black0.y=-3;

			if (contains(pgrbtn))
				removeChild(pgrbtn);
		}

		private function onTimer(evt:TimerEvent):void
		{
			//2013419
			//Global.crtMediaInfo["crtTime"]=Global.mps.mediaPlayer.currentTime;
			//DebugTip.instance.log(Global.mps.mediaPlayer.currentTime+"|CacheTotalTime"+Global.crtMediaInfo["totalTime"]);
			if (Global.mps && Global.crtMediaInfo["totalTime"]) //if (Global.mps && Global.mps.mediaPlayer.duration)
			{
				var tr:Number=(Global.mps.mediaPlayer.currentTime + Global.crtMediaInfo["seekTime"]) / Global.crtMediaInfo["totalTime"]; //(Global.mps.mediaPlayer.currentTime+int(Global.crtMediaInfo["crtTime"]) )/ Global.mps.mediaPlayer.duration;
				var br:Number=Global.mps.mediaPlayer.bytesLoaded / Global.mps.mediaPlayer.bytesTotal;

				bufferLengh=Global.crtMediaInfo["seekX"] + br * (Global.appWidth - Global.crtMediaInfo["seekX"]);
				updateState(tr * Global.appWidth,bufferLengh);
				//Global.mps.mediaPlayer.currentTime+Global.crtMediaInfo["crtTime"]
				Global.txttime.text=ShowTime(Global.mps.mediaPlayer.currentTime + Global.crtMediaInfo["seekTime"]) + " / " + ShowTime(Global.crtMediaInfo["totalTime"]); //ShowTime(Global.mps.mediaPlayer.duration);
				if ((Global.mps.mediaPlayer.currentTime + Global.crtMediaInfo["seekTime"]) >= Global.adParameter.adstarttime && hasShowAd == false)
				{
					hasShowAd=true;
					if(AdXmlModel.instance.getButtomFloatAdlist.toString()!=""){
						showad();
					}
				}
			}
			
			//adchina second notifytion
			AdChinaMoudle.instance.dispatchEvent(new Event(AdChinaEvent.TIMEACTION));

			if (Global._isVideo == false)
			{
				Global.main.showVol();
			}

			//最后播完时读连播JS
			var endbehaviorFromJS:String="";
			if (Global.mps.mediaPlayer.currentTime == Global.mps.mediaPlayer.duration && Global.mps.mediaPlayer.duration > 0)
			{
				
				
				try
				{
					endbehaviorFromJS=ExternalInterface.call("mediaPlayEnd");
				}
				catch (error:Error)
				{
				}

				if (endbehaviorFromJS == "stop")
				{
					Global.playerparameter.endbehavior="0";
				}
				
				//DebugTip.instance.log("lanbotest:"+endbehaviorFromJS);
			}

		}

		private function showad():void
		{
			
			if (Global.playerparameter.isAd == "true" && Global.adParameter.hasOverlayAd)
			{
				
				if (Global.adParameter.overlayAdType == 0)
				{
					Global.main.addChildAt(adpanel,Global.main.numChildren - 1);
					if (Global.adParameter.bottomAdCount > 0)
					{
						bottomad=new BottomAd();
						bottomad.y=-this.height;
						bottomad.x=Global.appWidth / 2 - bottomad.width / 2;
						addChild(bottomad);
					}
				}
				else if (Global.adParameter.overlayAdType == 1)
				{
					overlayads=new GoogleAds(3);
				}
				
				//allyes adsystem
				DebugTip.instance.log("ALLYES :REQUEST LAYAD:"+AdXmlModel.instance.getButtomFloatAdlist.sc.toString())
				var urlLoader:URLLoader=new URLLoader(new URLRequest(AdXmlModel.instance.getButtomFloatAdlist.sc.toString()));
			}
		}

		private function updateState(rx:Number,gx:Number):void
		{
			red0.graphics.clear();
			if (Global.playtype == 1)
				red0.graphics.beginFill(0xdcb627,1);
			else
				red0.graphics.beginFill(0xb30608,1);
			if (isOver && Global.playtype == 0)
				red0.graphics.drawRect(0,0,rx,7);
			else
				red0.graphics.drawRect(0,0,rx,3);
			red0.graphics.endFill();
			grey0.graphics.clear();
			grey0.graphics.beginFill(0x656565,1);
			if (isOver && Global.playtype == 0)
			{
				grey0.graphics.drawRect(0,0,gx,7);
			}
			else
			{
				grey0.graphics.drawRect(0,0,gx,3);
			}
			grey0.graphics.endFill();
			black0.graphics.clear();
			black0.graphics.beginFill(0x2d2d2d,1);
			if (isOver && Global.playtype == 0)
				black0.graphics.drawRect(0,0,Global.appWidth,7);
			else
				black0.graphics.drawRect(0,0,Global.appWidth,3);
			black0.graphics.endFill();

			yellow0.graphics.beginFill(0xffff00,1);
			if (isOver && Global.playtype == 0)
				yellow0.graphics.drawRect(0,0,4,7);
			else
				yellow0.graphics.drawRect(0,0,4,3);
			yellow0.graphics.endFill();
			
			if(pgrBtnState!="onMouseDn")
			pgrbtn.x=rx - 5;
		}

		private function overout(mc:MovieClip):void
		{
			mc.gotoAndStop(1);
			mc.addEventListener(MouseEvent.ROLL_OVER,onOver);
			mc.addEventListener(MouseEvent.ROLL_OUT,onOut);
		}

		function onOver(evt:MouseEvent):void
		{
			var mc:MovieClip=evt.target as MovieClip;
			mc.gotoAndStop(2);
		}

		function onOut(evt:MouseEvent):void
		{
			var mc:MovieClip=evt.target as MovieClip;
			mc.gotoAndStop(1);
		}

		public function ShowTime(num1:Number):String
		{
			var num:int      =uint(num1);
			var min:int      =GetMinute(num);
			var sec:int      =GetSecond(num);
			var hr:int       =GetHour(num);
			var strMin:String="";
			var strSec:String="";
			var strHr:String ="";
			if (min < 10)
			{
				strMin="0" + min.toString();
			}
			else
			{
				strMin=min.toString();
			}
			if (sec < 10)
			{
				strSec="0" + sec.toString();
			}
			else
			{
				strSec=sec.toString();
			}
			strHr=hr.toString();
			if (num < 3600)
			{
				return strMin + ":" + strSec;
			}
			else
			{
				return strHr + ":" + strMin + ":" + strSec;
			}
		}

		public function GetHour(num:int):int
		{
			if (num < 3600)
			{
				return 0;
			}
			else
			{
				return uint(num / 3600);
			}
		}

		public function GetMinute(num:int):int
		{
			//less than 1 hour.
			if (num < 3600)
			{
				return num / 60;
			}
			else if (num < 7200)
			{
				return (num - 3600) / 60;
			}
			else if (num < 10800)
			{
				return (num - 7200) / 60;
			}
			else
			{
				return (num - 10800) / 60;
			}
		}

		public function GetSecond(num:int):int
		{
			return num % 60;
		}
	}

}
