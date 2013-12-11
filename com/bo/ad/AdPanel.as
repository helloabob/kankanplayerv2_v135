package com.bo.ad
{
	import com.adobe.serialization.json.*;
	import com.bo.events.AdEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class AdPanel extends Sprite{
		private var _hasAd:Boolean=false;
		private var _urlLoader:URLLoader;
		private var _methodName:String="GetAdPosition";
		private var _methodName1:String="GetVodCurrentAds";
		private var _adServer:String="http://ad.kankanews.com/entry.php";
		private var _status:String="request";
		private var _loader:Loader;
		private var _link:String="";
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _video:Video;
		private var _isStop:Boolean=false;
		private var _count:int=0;
		private var _cPanel:AdCount;
		private var timer:Timer;
		private var qiantie:String="";
		public var houtie:String="";
		public var zanting:String="";
		private var state:uint=1;
		private var zantingpic:String="";
		public function AdPanel(){
			//http://ad.kankanews.com/entry.php
			//parameter=%7B%22ChannelId%22%3A%22ff808081280bd62f01281a5fc56400c2%22%2C%22Type%22%3A0%7D&method=GetAdPosition
			//[{"id":"308","interval":"60","x":"0.00000","y":"0.00000","height":"1.00000","width":"1.00000","cushion":"1","CanClose":"2"}]
			
			//parameter=%7B%22AdPosType%22%3A0%2C%22AdPos%22%3A%22308%22%7D&method=GetVodCurrentAds
			//{AdPosType:}
			//null			
		}

		public function get hasAd():Boolean{
			return _hasAd;
		}

		public function requestAdServer():void{
			//hasAd=false;
			trace('start');
			var ttt:String=Global._xml.advid;
			var parameter:Object={ChannelId :ttt, Type:1 };
			var p:Object = JSON.encode(parameter);
			var variables:URLVariables = new URLVariables();
			variables.method = _methodName;
			variables.parameter = p;
			
			var urlRequest:URLRequest=new URLRequest(_adServer);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data=variables;
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, onRequestComplete);
			_urlLoader.load(urlRequest);
			
		}
		private function onRequestComplete(evt:Event):void{
			_urlLoader.removeEventListener(Event.COMPLETE, onRequestComplete);
			trace(evt.target.data);
			if(evt.target.data==null)
			{		
				trace("1null");
				dispatchEvent(new AdEvent(AdEvent.PLAYCOMPLETE));
			}else{
				trace('aaa');
				var t:Object = JSON.decode(evt.target.data);
				trace(t);
				trace(t.length);
				for(var k:int=0;k<t.length;k++){
					if(t[k]["cushion"]=="1")qiantie=t[k]["id"];
					else if(t[k]["cushion"]=="2")zanting=t[k]["id"];
					else if(t[k]["cushion"]=="3")houtie=t[k]["id"];
				}
				//trace(t[0]["id"]);
				if(qiantie!="")playAd(qiantie);
				else dispatchEvent(new AdEvent(AdEvent.PLAYCOMPLETE));
				//playAd(t[0]["id"]);
				//playAd("388");
			}
		}
		private function onPlayComplete(evt:Event):void{
			_urlLoader.removeEventListener(Event.COMPLETE, onPlayComplete);
			trace(evt.target.data);
			if (evt.target.data!=null)
			{		
				trace('bb');
				try{
					var t:Object = JSON.decode(evt.target.data);
					//var ss:int=int(t["duration"]*1000);
					var ss:int=int(t["duration"]);
					trace(ss);
					_count=ss;
					if(t["adtype"]=="1"){
						_loader=new Loader();
						_loader.load(new URLRequest(t["src"]));
						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete);
						_loader.addEventListener(MouseEvent.CLICK,onLink);
						_link=t['href'];
					}else if(t["adtype"]=="2"){
						_nc=new NetConnection();
						_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAdAsyError);
						_nc.connect(null);
						_ns=new NetStream(_nc);
						var cc:Object=new Object();
						cc.onMetaData=metaDataHandler;
						_ns.client=cc;
						_ns.addEventListener(NetStatusEvent.NET_STATUS,onAdNetStreamStatus);
						//_video=new Video(Global.APPWIDTH,Global.VIDEOHEIGHT);
						var nh:Number=Global.APPWIDTH/16*9;
						_video=new Video(Global.APPWIDTH,nh);
						//_video=new Video(Global.APPWIDTH,338);
						//_video.y=76;
						//_video.y=(Global.VIDEOHEIGHT+40-nh)/2;
						_video.y=(Global.VIDEOHEIGHT-nh)/2;
						_video.attachNetStream(_ns);
						_video.smoothing=true;
						_video.addEventListener(MouseEvent.CLICK,onLink);
						_link=t['href'];
						_ns.play(t["src"]);
						Global._smgbbplayer.addChild(_video);
					}
				}catch(err:Error){
					dispatchEvent(new AdEvent(AdEvent.PLAYCOMPLETE));
				}
			}else{
				trace("null");
				dispatchEvent(new AdEvent(AdEvent.PLAYCOMPLETE));
				
			}
		}
		private function onAdAsyError(evt:AsyncErrorEvent):void{			
		}
		private function onAdNetStreamStatus(evt:NetStatusEvent):void{
			if(evt.info.code=="NetStream.Play.Start"||evt.info.code=="NetStream.Buffer.Full"){
				StartToCount();
				//dispatchEvent(new MediaStateChangeEvent(MediaStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,"playing"));
			}else if(evt.info.code=="NetStream.Pause.Notify"){
				//dispatchEvent(new MediaStateChangeEvent(MediaStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,"paused"));
			}else if(evt.info.code=="NetStream.Unpause.Notify"){
				//dispatchEvent(new MediaStateChangeEvent(MediaStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,"playing"));
			}else if(evt.info.code=="NetStream.Play.Stop"){				
				_isStop=true;
			}else if(evt.info.code=="NetStream.Buffer.Empty"){
				
				if(_isStop){
					trace('over');
					adOver();
				}
				//if(_isStop)dispatchEvent(new MediaStateChangeEvent(MediaStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,"ready"));
			}else if(evt.info.code=="NetStream.Play.StreamNotFound"){
				//dispatchEvent(new MediaStateChangeEvent(MediaStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,"playbackError"));
			}

		}
		private function onLink(evt:MouseEvent):void{
			navigateToURL(new URLRequest(_link),"_blank");
		}
		private function onLoaderComplete(evt:Event):void{			
			_loader.width=Global.APPWIDTH;
			//_loader.height=Global.VIDEOHEIGHT+40;
			_loader.height=Global.VIDEOHEIGHT;
			if(!Global._smgbbplayer.contains(_loader))Global._smgbbplayer.addChild(_loader);
			if(state==2){
				trace("add pause ads----");
				_loader.scaleX=0.7;
				_loader.scaleY=0.7;
				_loader.x=Global.APPWIDTH/2-_loader.width/2;
				_loader.y=Global.VIDEOHEIGHT/2-_loader.height/2;
			}else{
				StartToCount();
			}
			
			
		}
		public function stopPauseAd():void{
			if(_loader&&Global._smgbbplayer.contains(_loader)){
				Global._smgbbplayer.removeChild(_loader);
				trace('removed from the pause ads');
			}
		}
		private function StartToCount():void{
			if(timer==null){
				timer=new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER,onTimerComplete);
				timer.start();
				_cPanel=new AdCount();
				_cPanel.y=10;
				_cPanel.x=Global.APPWIDTH-150;
				Global._smgbbplayer.addChild(_cPanel);
			}
		}
		private function onTimerComplete(evt:TimerEvent):void{
			if(_count>=0){
				_cPanel.Txt=_count.toString();
				_count=_count-1;		
			}else{
				adOver();
			}
		}
		private function adOver():void{
			if(timer){
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER,onTimerComplete);
				timer=null;
			}
			if(_loader){
				Global._smgbbplayer.removeChild(_loader);
				_loader.unloadAndStop();
				_loader=null;
				
			}
			if(_video){
				try{
					_ns.close();
					_nc.close();
				}catch(err:Error){					
				}
				_ns=null;
				_nc=null;
				Global._smgbbplayer.removeChild(_video);
				_video=null;
			}
			if(_cPanel&&Global._smgbbplayer.contains(_cPanel))Global._smgbbplayer.removeChild(_cPanel);
			dispatchEvent(new AdEvent(AdEvent.PLAYCOMPLETE));
		}
		public function playAd(adId:String,sta:uint=1):void{
			_status=="play";
			state=sta;
			if(state==2){
				if(_loader){
					if(!Global._smgbbplayer.contains(_loader)){
						onLoaderComplete(null);
						return;
					}else{
						return;
					}
				}
			}
			var parameter:Object = {AdPos :adId, AdPosType:1 };
			//var parameter:Object={ChannelId :"smgbbshishi001", Type:1 };
			var p:Object = JSON.encode(parameter);
			var variables:URLVariables = new URLVariables();
			variables.method = _methodName1;
			variables.parameter = p;
			
			var urlRequest:URLRequest=new URLRequest(_adServer);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data=variables;
			_urlLoader=null;
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, onPlayComplete);
			_urlLoader.load(urlRequest);
			
		}
		private function metaDataHandler(item:Object):void{
			trace("get metaDataInfo");
		}
	}
}