﻿package com.bo.ad {	import flash.events.IOErrorEvent;	import flash.events.Event;	import flash.system.Security;	import flash.display.Loader;	import flash.net.URLRequest;	import com.bo.events.MyEvent;	import flash.display.Sprite;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.text.TextField;	import flash.net.URLLoader;	import flash.events.MouseEvent;	public class FVAds{		private var loader:Loader;		private var msInstance:*;		public function FVAds() {			//loadAd("mtest.mediashare.cn","http://mtest.mediashare.cn/m/msp/ms3.swf?wid=1000&cid=1000&pid=1000&hj=3");			loadAd("m.mediashare.cn","http://m.mediashare.cn/m/msp/ms3.swf?wid=2020&cid=1041&pid=2049");		}		public function rearrange(isFull:Boolean){			if(Global.playtype==1){				if(isFull)msInstance.setSize(Global.appWidth,Global.appHeight,isFull);				else msInstance.setSize(Global.appWidth,Global.appHeight-32,isFull);			}		}		private function loadAd(hostName:String,url:String):void{			Security.allowDomain(hostName);			loader=new Loader();			loader.load(new URLRequest(url));			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAdInit);			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onAdError);		}		private function onAdError(evt:IOErrorEvent):void{			//Global.main.loadplayer();			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAdInit);			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAdError);			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.PREADCOMPLETE));		}		private function onAdInit(evt:Event):void{			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAdInit);			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAdError);						try{				Global.main.addChild(loader);				Global.main.showLoading();								msInstance = (loader.content as Object);				var json:Object = new Object();				json.wid = 2020;				json.cid = 1041;				json.pid = 2049;				json.keys = "";					json.filters = "";				json.bgc=1;				json.w=Global.appWidth;				json.h=Global.appHeight-32;				//json.w = playerW;//stage.stageWidth;				//json.h = playerH-30;// stage.stageHeight - 30;				// "no" 不使用分享广告坐标定位				json.adAlign = "yes";				// 1:标清 2:高清				json.quality="1";				// 投放类型				json.deliveryType = 1;				// 广告展示最大宽和高区域限制,对前贴和尾贴无效.				json.adMaxW=Global.appWidth;				json.adMaxH=Global.appHeight;				//json.adMaxW = adMaxW;// stage.stageWidth;				//json.adMaxH = adMaxH;// stage.stageHeight;				json.mtIssc = 'n';								json.shows=",close,down,";				//json.shows = jsonTemp.shows;				json.stageM = Global._stage;				// 发送贴片请求--调用容器提供的对外接口并传递相关参数				// 参数1: 指定被回调的函数对象				// 参数2: 指定参数对象				// e.target.content.remoteImp( this.msCallback , json ) ;				msInstance.remoteImp(msCallback , json ) ;			}catch (e:Error) {				msInstance.destroy();				Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.PREADCOMPLETE));			}		}		private function msCallback(obj:Object):void{			trace(obj.flag);			if(obj.flag=="over"){				msInstance.destroy();				Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.PREADCOMPLETE));			}else if(obj.flag=="playing"){				Global.main.hideLoading();			}		}		/*private function onTimer(evt:TimerEvent):void{			_timer_txt.text="广告还剩："+int((con.duration-con.time)).toString()+"秒";			if(_timer.currentCount==5){				btnclose.x=Global.appWidth-btnclose.width-20;				btnclose.y=30;				btnclose.addEventListener(MouseEvent.CLICK,onclose);				sp.addChild(btnclose);			}		}*/		/*private function onTimerComplete(evt:TimerEvent):void{		}		private function onAdStart(evt:Event):void{			//此处调用统计代码			var urlloader:URLLoader=new URLLoader();			urlloader.load(new URLRequest(Global.adParameter.preAdLink));			Global.main.hideLoading();			_timer=new Timer(1000,int(con.duration));			_timer.addEventListener(TimerEvent.TIMER,onTimer);			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);			_timer.start();			_timer_txt.width=100;			_timer_txt.textColor=0xffffff;			_timer_txt.x=Global.appWidth-_timer_txt.width-10;			_timer_txt.y=10;			sp.addChild(_timer_txt);		}		public function myunload():void{		}		private function onclose(evt:MouseEvent):void{			onAdComplete(evt);		}		private function onAdComplete(evt:Event):void{			if(_timer){				_timer.reset();				_timer=null;				sp.removeChild(_timer_txt);				sp.removeChild(btnclose);			}			sp.removeChild(ld);			Global.main.removeChild(sp);			//Global.main.removeChild(ld);			ld.removeEventListener("show_end",onAdComplete);			ld.removeEventListener("ad_none",onAdComplete);			ld.removeEventListener("load_failed",onAdComplete);			ld.removeEventListener("show_start",onAdStart);			ld.unloadAndStop();			Global.main.loadplayer();			//Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.PREADCOMPLETE));			//Global.main.loadplayer();		}*/	}	}