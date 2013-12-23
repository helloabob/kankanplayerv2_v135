package
{
	import com.ToolUtils.ToolStringUtil;
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.bo.ad.GoogleAds;
	import com.bo.ad.PauseAdBase;
	import com.bo.ad.PreAdBase;
	import com.bo.display.MyLogo;
	import com.bo.display.MyPlayer;
	import com.bo.display.PreImage;
	import com.bo.elements.EndPanel;
	import com.bo.elements.Mycontrolbar;
	import com.bo.elements.PreloaderAsset;
	import com.bo.elements.v2.EndPanel2;
	import com.bo.events.MyEvent;
	import com.bo.net.OMSLoader;
	import com.bo.net.VXMLloader;
	import com.bo.tracker.MyLiveTracker;
	import com.bo.tracker.MyTracker;
	import com.debugTip.DebugTip;
	import com.mvc.model.AdXmlModel;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaPlayerState;

	//import com.bo.utils.StatisticsType;

	public class kankanplayer extends MovieClip
	{
		private var bar:Mycontrolbar;
		private var back:Sprite        =new Sprite();
		private var myPlayer:MyPlayer  =new MyPlayer();
		private var endpanel:EndPanel  =new EndPanel();
		private var endpanel2:EndPanel2=new EndPanel2();
		private var tracker:*;
		private var preload:MovieClip  =new PreloaderAsset();
		private var reload:Boolean     =true;
		private var adpanel:PreAdBase;
		private var preimage:Sprite;
		private var otherads:*;
		private var pausegoogleads:GoogleAds;
		private var preadloader:Loader;
		private var pauseads:PauseAdBase;
		private var volSprite:Sprite   =new Sprite();
		private var sfx:RonSoundFX;

		private function onPreAdLoadError(evt:IOErrorEvent):void
		{
			DebugTip.instance.log("ERROR: PRELOADAD ERROR")

			preadloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onPreAdLoadComplete);
			preadloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onPreAdLoadError);
			preadloader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onPreAdLoadError);
			
			DebugTip.instance.log("bar 1");
			initBar();
			Global.preAdPlayComplete=true;
			this.loadplayer();
		}

		private function onPreAdLoadComplete(evt:Event):void
		{
			trace("loadAdSwfComplete")
			var con:*     =preadloader.content;
			var obj:Object=new Object();
			preadloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onPreAdLoadComplete);
			preadloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onPreAdLoadError);
			preadloader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onPreAdLoadError);
			this.addChild(preadloader);
			this.setChildIndex(preload,this.numChildren - 1);
			obj.width=Global.appWidth;
			obj.height=Global.appHeight - 32;
			obj.count=1;
			obj.baiduid="425807";
			//adsystem

			obj.selfadparam=AdXmlModel.instance.getFrontAdList; //Global.adParameter.adxml.chan[0];
			obj.baseadparam=AdXmlModel.instance.getFrontButtomList;
			obj.adchinaid=Global.adParameter.adchinaid;
			con.configureParameters(obj);
			con.addEventListener("preadcomplete",onadcc);
			con.addEventListener("preAdSkip",onAdSkip);
			con.addEventListener("hideLoading",onHideLoding);
			con.addEventListener("preadstart",onPreAdPlay);

			//hideLoading();
		}
		
		private function onPreAdPlay(e:Event):void
		{
			DebugTip.instance.log("EVT:PreAdPlay");
			this.dispatchEvent(new Event("showMedia"));
			hideLoading();
		}

		private function onHideLoding(evt:Event):void
		{
			hideLoading();
		}
		
		private function onAdSkip(evt:Event):void
		{
			this.removeChild(preadloader);
			preadloader.unloadAndStop();
			//this.loadplayer();
			Global.preAdPlayComplete=true;
			DebugTip.instance.log("bar 2");
			initBar();
			DebugTip.instance.log("skipAd");
			this.dispatchEvent(new Event("showMedia"));
			
			if (!Global.getVideoInfo)
			{
				if(Global.playerparameter.autoPlay!="false"){
					DebugTip.instance.log("showLoading1");
					showLoading();
				}
				else{
					hideLoading();
				};
			}
			else
			{
				hideLoading();
			}
			
			if(Global.playerparameter.autoPlay!="false"){
				Global.mps.mediaPlayer.play();	
			}
			else{
				//Global.mps.mediaPlayer.pause();	
			}
		}

		private function onadcc(evt:Event):void
		{
			DebugTip.instance.log("preadcomplete!");
			this.removeChild(preadloader);
			DebugTip.instance.log("EVT:PreAdPlayEnd");
			this.dispatchEvent(new Event("showMedia"));
			preadloader.unloadAndStop();
			//this.loadplayer(); 
			Global.preAdPlayComplete=true;
			
			DebugTip.instance.log("bar 3");
			initBar();

			if (!Global.getVideoInfo)
			{
				if(Global.playerparameter.autoPlay!="false"){
					DebugTip.instance.log("showLoading2");
					showLoading()
				}else{
					hideLoading()
				};
			}
			else
			{
				hideLoading();
			}
			
			if(Global.playerparameter.autoPlay!="false"){
				Global.mps.mediaPlayer.play();	
			}
			else{
				//Global.mps.mediaPlayer.pause();	
			}
		}

		private function initBar():void
		{
			DebugTip.instance.log("------kankanplayer_initBar---------");
			//register event
			Global.mps.visible=true;
			Global.playtype=0;
			bar.registerEventListener();
			//
		}

		public function kankanplayer()
		{
			//Security.allowDomain("*.video-tx.com");
			Security.allowDomain("*");
			//debug面版，传入舞台

			addEventListener(Event.ADDED_TO_STAGE,onStageAdded);
			
		}
		
		private function onStageAdded(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onStageAdded);

			DebugTip.instance.init(this.stage,false);
			///模拟播放类型，
//			Global.playerparameter.isAd="true";
//			Global.playerparameter.islive="true";
//			Global.playerparameter.ishls="true";
			//Global.playerparameter.issizechangable="true";
			//Global.omsid="336876";
//			Global.xmlid="vxml/2013-09-30/0013578732";
//			Global.playerparameter.autoPlay="true";
			//Global.playerparameter.preimageurl="http://adv.smg.cn/d/file/videoset/2012-11-05/e0ae837da37033adc0e63119664f7c53.jpg";
			//add init 
			//line 395,rem

//			init();
			
//			flash.utils.setTimeout(testForLive,5000);
			
		}
//		var array:Array=new Array("105849","105838","105854");
//		var ccc:int=0;
//		private function testForLive():void{
//			this.onChangeChannel(array[ccc]);
//			ccc++;
//			if(ccc==array.length)ccc=0;
//			flash.utils.setTimeout(testForLive,5000);
//		}

		public function showVol():void
		{
			if (!sfx)
			{
				DebugTip.instance.log("show Mp3 wave shape init");
				sfx=new RonSoundFX(this.volSprite,Global.appWidth,Global.appHeight - 35,4);
				sfx.start();
				addChild(this.volSprite);
			}
			this.setChildIndex(this.volSprite,this.numChildren - 1);
		}

		private function init():void
		{

			//add preload
			this.addChild(preload);

			Global.appWidth=stage.stageWidth;
			Global.appHeight=stage.stageHeight;
			Global.initAppWidth=Global.appWidth;
			if (Global.playerparameter.isembed == "true")
			{
				Global.appWidth=600;
				Global.appHeight=482;
			}

			//Global.appWidth=Global.playerparameter.width;
			//Global.appHeight=Global.playerparameter.height;
			Global._stage=stage;
			// stage setup
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onStageResize);
			//back setup
			back.graphics.beginFill(0x000000,1);
			back.graphics.drawRect(0,0,Global.appWidth,Global.appHeight);
			back.graphics.endFill();

			bar=new Mycontrolbar();
			bar.addEventListener(MyEvent.SEEKMEDIA,onSeekHandler);
			myPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,mediaPlayerStateChange);
			Global.myPlayer=myPlayer;

			Global.notificationCenter.addEventListener(MyEvent.POSTEVENT,onReceiveEvent);

			//addchild setup
			addChild(back);
			addChild(myPlayer);

			if (Global.playerparameter.playerLogoURL != "")
			{
				var mylogo:MyLogo=new MyLogo(Global.playerparameter.playerLogoURL);
				addChild(mylogo);
			}
			if (Global.playerparameter.preimageurl != "")
			{
				preimage=new PreImage(Global.playerparameter.preimageurl);
			}
			if (Global.playerparameter.autoPlay == "false" && Global.playerparameter.preimageurl != "")
			{
				addChild(preimage);
			}
			addChild(bar);

			preload.width=30;
			preload.height=30;

			Global.main=this;

			configureplayerinfo();
		}

		public function removepreimage():void
		{
			if (preimage && contains(preimage))
				removeChild(preimage);
		}

		public function onChangeChannel(channelid:String):void
		{
			for each (var xml:XML in Global.videodata.channelListXML.video_clip)
			{
				if (xml.id == channelid)
				{
					Global.videodata.colname=xml.title;
					Global.videodata.videourl=xml.titleurl;
					tracker.onEndPlay();
					tracker = new MyLiveTracker();
					myPlayer.changeChannel();
					return;
				}
			}
		}

		private function onlistcomp(evt:Event):void
		{
			Global.videodata.channelListXML=new XML(evt.target.data);
			trace(Global.videodata.channelListXML);
			ExternalInterface.addCallback("changeChannel",onChangeChannel);
			ExternalInterface.call("playerComplete");
			loadplayer();
			//register controlbar event.
			trace("register controlbar event for live.");
			initBar();
		}

		private function configureplayerinfo():void
		{
			/*
			发布时,
			1 init清除 line 118,137
			2 随机数加入 Line403;
			3 PlayerParameters.as中的preadloaderurl记得修改 line35;
			4 myplayer.as修改中的url修改line 97，
			5 debugtip版本号version,有三个，debugtip.as,preadloader.as,kankanplayer.as
			*/

			//播放类型分派
			if (Global.playerparameter.islive == "true")
			{

				if (Global.playerparameter.ishls == "true")
				{
					DebugTip.instance.log("come here 1")
					var listloader:URLLoader=new URLLoader();
					listloader.addEventListener(Event.COMPLETE,onlistcomp);
					listloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,listSError);
					listloader.addEventListener(IOErrorEvent.IO_ERROR,listIoError);
					listloader.load(new URLRequest("http://interface.kankanews.com/kkapi/v/get_lives.php?api_key=live&access_token=5d8c8b071c08fce87a32ccac75f87d05&t=" + int(Math.random() * 100000000)));
				
					function listSError(evt:SecurityErrorEvent):void{
						DebugTip.instance.log("-----list s error-----");
					}
					
					function listIoError(evt:IOErrorEvent):void{
						DebugTip.instance.log("-----list io error-----");
					}
				}
				else
				{
					DebugTip.instance.log("come here 2");
					loadplayer();
				}
			}
			else
			{
				if (Global.omsid != "")
				{
					DebugTip.instance.log("come here 3")
					var ol:OMSLoader=new OMSLoader();
					ol.loadxml();
				}
				else if (Global.xmlid != "")
				{
					DebugTip.instance.log("come here 4")
					var xl:VXMLloader=new VXMLloader();
					xl.loadxml();
				}
				else
				{
					DebugTip.instance.log("come here 5")
					loadplayer();
				}
			}
		}

		private function loadad():void
		{
			DebugTip.instance.log("loadad!!!!!")
			//adsystem
//			AdXmlModel.instance.init();

			//adsystem
			trace("stage_w_h:"+stage.stageWidth+stage);
			AdChinaMoudle.instance.init(stage);
			AdChinaMoudle.instance.addEventListener("preadcomplete",onAdChinacc);
			AdChinaMoudle.instance.addEventListener("adstart",adStartHandle);
			AdChinaMoudle.instance.addEventListener("adstop",adStopHandle);	
				
			//var al:AdXMLLoader=new AdXMLLoader();
			//al.loadxml();
		}
		
		protected function adStopHandle(event:Event):void
		{
			DebugTip.instance.log("-------------adStopHandle()------------");
			if(Global.mps.mediaPlayer.currentTime<Global.mps.mediaPlayer.duration)
				Global.mps.mediaPlayer.play();
		}
		
		protected function adStartHandle(event:Event):void
		{
			DebugTip.instance.log("-------------adStartHandle()------------");
			this.dispatchEvent(new Event("showMedia"));
			if(Global.mps.mediaPlayer.duration)
				Global.mps.mediaPlayer.pause();
		}
		
		private function onAdChinacc(evt:Event):void
		{
			DebugTip.instance.log("-------------onAdChinacc()------------");
			this.dispatchEvent(new Event("showMedia"));
			//this.loadplayer();
			Global.mps.mediaPlayer.play();
			Global.preAdPlayComplete=true;
			
			initBar();
			
			if (!Global.getVideoInfo)
			{
				showLoading();
			}
			else
			{
				hideLoading();
			}
			if(!Global.crtMediaInfo["totalTime"]){
				this.initAndPlayVideo();
			}
		}

		public function loadplayer():void
		{
			if (Global.playerparameter.islive == "true")
			{
				Global.videodata.host="http://live.kankanews.com";
				//Global.videodata.videotitle="新闻直播频道_突发新闻直播_视频直播在线观看_看看新闻网";
				Global.videodata.videotitle="";
				Global.videodata.imageurl="";
			}
			DebugTip.instance.log("========================loadplayer================================");
			myPlayer.setup();
			//init rem
			//Global.mps.visible=false;
		}

		public function initAndPlayVideo():void
		{
			myPlayer.initAndPlayVideo();
		}

		private function onReceiveEvent(evt:MyEvent):void
		{
			switch (evt.obj)
			{
				case MyEvent.ADXMLERROR:
				{
					DebugTip.instance.log("ERROR: ADXMLLOADERROR");
					Global.preAdPlayComplete=true;
					loadplayer();
					break;
				}
				case MyEvent.OMSXMLCOMPLETE:
				{
					if (Global.playerparameter.isAd == "true")
					{
						DebugTip.instance.log("cd 5");
						loadad();
						loadplayer();
					}
					else
					{
						DebugTip.instance.log("cd 6");
						loadplayer();
						if(Global.playerparameter.autoPlay=="false"){
							DebugTip.instance.log("bar 4");
							this.dispatchEvent(new Event("showMedia"));
							initBar();
						}
					}
					break;
				}
				case MyEvent.VXMLCOMPLETE:
				{
					trace("vxml_complete");
					if (Global.omsid != "")
					{
						trace("pre_oms_load_xml");
						var omsld:OMSLoader=new OMSLoader();
						omsld.loadxml();
					}
					else
					{
						if (Global.playerparameter.isAd == "true")
						{
							DebugTip.instance.log("cd 1");
							loadad();
							loadplayer();

						}
						else
						{
							DebugTip.instance.log("cd 2");
							loadplayer();
						}
					}
					break;
				}
				case MyEvent.ADXMLCOMPLETE:
				{
					if (Global.adParameter.hasPreAd)
					{
						DebugTip.instance.log("cd 3");
						playAd();
					}
					else
					{
						DebugTip.instance.log("cd 4");
						loadplayer();
					}
					break;
				}

			}
		}

		private function playEndAd():void
		{
			//Global.playtype=1;
			//otherads=new GoogleAds();
		}

		private function playAd():void
		{
			/*Global.playtype=1;
			otherads=new GoogleAds(1);*/

			Global.playtype=1;
			//otherads=new AdChinaAds();
			DebugTip.instance.log("showLoading3");
			showLoading();
			preadloader=new Loader();
			preadloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPreAdLoadComplete);
			preadloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onPreAdLoadError);
			preadloader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onPreAdLoadError);
			//随机机数在发布时可以加上
			var tStr:String=Global.playerparameter.preadloaderurl + "?t=" + int(Math.random() * 1000000000); //"PreAdLoaderAD.swf";
			preadloader.load(new URLRequest(tStr));
			//"PreAdLoader.swf"Global.playerparameter.preadloaderurl+"?t="+Math.random()));
			DebugTip.instance.log("playAd:" + tStr);

		}

		private function onSeekHandler(evt:MyEvent):void
		{
			//myplayer show cachePoster
			Global.myPlayer.dispatchEvent(new Event("addCache"));
			DebugTip.instance.log("showLoading4");
			showLoading();
			cacheTimer.stop();
			var seekTime:int=evt.obj["seekTime"];
			var seekX:Number=evt.obj["seekX"];
//			if (tracker)
//				tracker.changeState("No_Playing_Buffering");
			//2013419
			if (Global.videodata.videourl.indexOf("mp4") > 0)
			{
				Global.ignoreBuffer=true;
				//return;
				Global.crtMediaInfo["seekX"]=seekX;
				Global.crtMediaInfo["seekTime"]=seekTime;
				var holeName:String=ToolStringUtil.instance.getHoleNameWithHttpString(Global.videodata.videourl);

				myPlayer.seekMp4(holeName + "?start=" + seekTime);
				DebugTip.instance.log("seekTime:" + seekTime);
			}
		}

		private function onPlayVideo(evt:Event):void
		{
			//if(isRelation=="true")endpanel=new EndPanel();
			myPlayer.setup();
		}

		private function onStageResize(evt:Event = null):void
		{
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.FULLSCREEN));
				Global.appWidth=stage.fullScreenWidth;
				Global.appHeight=stage.fullScreenHeight;
				if (otherads)
					otherads.rearrange(true);
			}
			else
			{
				AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.NORMALSCREEN));
				if (Global.playerparameter.isembed == "true")
				{
					Global.appWidth=600;
					Global.appHeight=482;
				}
				else
				{
					Global.appWidth=stage.stageWidth;
					Global.appHeight=stage.stageHeight;
					//Global.appWidth=580;
					//Global.appHeight=377;
				}
				if (otherads)
					otherads.rearrange(false);
			}
			
			
			back.graphics.clear();
			back.graphics.beginFill(0x000000,1);
			back.graphics.drawRect(0,0,Global.appWidth,Global.appHeight);
			back.graphics.endFill();
			
			if (sfx)
			{
				sfx.tw=Global.appWidth;
				sfx.th=Global.appHeight - 35;
			}
			if (pausegoogleads){
				pausegoogleads.rearrange();
			}	
			
			myPlayer.rearrange();
			bar.rearrange();
			
			endpanel.width=Global.appWidth;
			endpanel.height=Global.appHeight - 32;
			endpanel2.width=Global.appWidth;
			endpanel2.height=Global.appHeight - 32;
			DebugTip.instance.log("pauseStep0:"+endpanel.width+endpanel.height);
		}

		private function callStatistics():void
		{
			var url:String           =Global.playerparameter.statisticsurl; //"http://www.kankanews.com/phpapp/vclick.php?player=2&id="+Global.videodata.cmsid;
			var urlrequest:URLRequest=new URLRequest(url);
			var urlloader:URLLoader  =new URLLoader();
			trace("callStatistics:",url);
			//urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			if (Global.playerparameter.statisticsurl)
			{
				urlloader.load(urlrequest);
			}
		}

		//播放结束时跳转
		public function processendstatus():void
		{
			Global.playtype=0;
			//调试片尾行为
			//Global.playerparameter.endbehavior="1";
			DebugTip.instance.log("endbehavior:" + Global.playerparameter.endbehavior);
			
			if (Global.playerparameter.endbehavior == "1")
			{
				endpanel.show();
			}
			else if (Global.playerparameter.endbehavior == "2")
			{
				navigateToURL(new URLRequest(Global.videodata.relation[0].link),"_top");
			}
			else if (Global.playerparameter.endbehavior == "3")
			{
				if (preimage)
					addChild(preimage);
			}
			else if (Global.playerparameter.endbehavior == "4")
			{
				endpanel2.show();
				endpanel2.width=Global.appWidth;
				endpanel2.height=Global.appHeight - 32;
			}
			DebugTip.instance.log("hideload-----1")
			hideLoading();
		}

		public function showLoading():void
		{
			
			this.setChildIndex(preload,this.numChildren-1);
			preload.visible=true;
			preload.x=Global.appWidth / 2 - preload.width / 2;
			preload.y=Global.appHeight / 2 - preload.height / 2;

			DebugTip.instance.log("show loading" + contains(preload) + "|" + preload.x + "|" + preload.y + "|" + preload.width);
		}
		
		public function checkIsZVer():void{
			
		}

		public function hideLoading():void
		{

			DebugTip.instance.log("hide loading");
			preload.visible=false;

		}

		private function mediaPlayerStateChange(evt:MediaPlayerStateChangeEvent):void
		{
			bar.mediaPlayerStateChange(evt);
			trace(evt.state);
			if (tracker)
				tracker.changeState(evt.state);

			if (Global.playtype == 0 && !tracker)
			{
				if (Global.playerparameter.islive == "true")
				{
					DebugTip.instance.log("here start livetrack~~")
					tracker=new MyLiveTracker();
				}
				else
				{
					DebugTip.instance.log("here start mytrack~~")
					tracker=new MyTracker();
				}
				Global.tracker=tracker;
			}
			switch (evt.state)
			{
				case MediaPlayerState.PLAYBACK_ERROR:
				{
					break;
				}
				case MediaPlayerState.PLAYING:
				{
					//因为media length并不一定会在第一时间获得所以用记时器10次请求
					DebugTip.instance.log("--start_timer_set_cache----");
					cacheTimer=new Timer(100,10);
					cacheTimer.start();
					cacheTimer.addEventListener(TimerEvent.TIMER,setCache);

					if (reload)
					{
						trace("state:1")
						callStatistics();
					}
					else
					{
						trace("state:2")
						if(Global.preAdPlayComplete){
							DebugTip.instance.log("EVT:PlayContent");
							this.dispatchEvent(new Event("showMedia"));
							hideLoading();
						}
						bar.showyellowdot();
						endpanel.hide();
						endpanel2.hide();
						Global.myPlayer.dispatchEvent(new Event("removeCache"));
					}
					if (Global._isVideo == false)
					{
						trace("state:3")
						this.dispatchEvent(new Event("showMedia"));
						hideLoading();
					}
					if (Global.playerparameter.islive == "true")
					{
						trace("state:4")
						this.dispatchEvent(new Event("showMedia"));
						hideLoading();
					}
					removepreimage();
					reload=false;
					hidepausead();
					break;
				}
				case MediaPlayerState.PAUSED:
				{
					
					if (Global.preAdPlayComplete)
					{
						hideLoading();
					}

					//何胜test
					//首次播放暂停不要广告，用时间控制
					if (Global.mps.mediaPlayer.currentTime > 1)
					{
						DebugTip.instance.log("pauseStep1"+stage.stageWidth+stage.stageHeight);
						endpanel.show();
						playPauseAd();
					}
					
					break;
				}
				case MediaPlayerState.READY:
				{
					
					//Global.mps.mediaPlayer.pause(); 这里注释后结束时不放相关。
					if (Global.playerparameter.islive == "false")
					{
						var holeName:String=ToolStringUtil.instance.getHoleNameWithHttpString(Global.videodata.videourl);
						if (Global.playerparameter.isAd == "true" && Global.adParameter.hasEndAd)
						{
							playEndAd();
						}
						else
						{
							processendstatus();
						}
					}
					DebugTip.instance.log("hideload-----2")
					hideLoading();

					AdChinaMoudle.instance.dispatchEvent(new Event(AdChinaEvent.SHOWENDAD));
					
					break;
				}
				case MediaPlayerState.BUFFERING:
				{
					
					if (Global.preAdPlayComplete)
					{
						DebugTip.instance.log("showLoading5");
						if(Global.mps.mediaPlayer.currentTime != Global.mps.mediaPlayer.duration)
						showLoading();
					}
					break;
				}
				case MediaPlayerState.LOADING:
				{
					if (Global.preAdPlayComplete)
					{
						DebugTip.instance.log("showLoading6");
						showLoading();
					}	
					reload=true;
					break;
				}

			}
			
		}

		private function playPauseAd():void
		{
			AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.SHOWPAUSEAD));
			if (Global.adParameter.hasPauseAd)
			{
				//allyes adsystem
				DebugTip.instance.log("ALLYES :REQUEST PAUSEAD:" + AdXmlModel.instance.getPauseAdList.sc.toString())
				var urlLoader:URLLoader=new URLLoader(new URLRequest(AdXmlModel.instance.getPauseAdList.sc.toString()));

				if (Global.adParameter.pauseAdType == 1)
				{
					if (pausegoogleads)
					{
						pausegoogleads.showpauseads();
					}
					else
					{
						pausegoogleads=new GoogleAds(2);
					}
				}
				else if (Global.adParameter.pauseAdType == 0)
				{
					if (!pauseads)
					{
						pauseads=new PauseAdBase();
					}
					pauseads.show();
				}
			}
		}

		private function hidepausead():void
		{
			AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.HIDEPAUSEAD));
			return;
			if (Global.adParameter.hasPauseAd && pauseads)
			{
				pauseads.hide();
			}
			if (pausegoogleads)
			{
				pausegoogleads.myunload();
					//pausegoogleads=null;
			}
		}

		private function setCache(evt:Event = null):void
		{
			var fileName:String=ToolStringUtil.instance.getFileNameWithHttpString(Global.videodata.videourl);
			if (Global.crtMediaInfo["fileName"] != fileName && Global.mps.mediaPlayer.duration > 0)
			{
				Global.crtMediaInfo["fileName"]=fileName;
				Global.crtMediaInfo["totalTime"]=Global.mps.mediaPlayer.duration;
				Global.crtMediaInfo["seekTime"]=0;
				Global.crtMediaInfo["seekX"]=0;
				DebugTip.instance.log("cache success");

				Global.getVideoInfo=true;

				//获取到视频信息后，播放逻辑
				if (Global.playerparameter.isAd == "false")
				{
					if(Global.playerparameter.autoPlay=="true"){
						DebugTip.instance.log("------kankanplayer_setCache_isAd=false_autoPlay=true--------");
						initBar();
					}
					Global.preAdPlayComplete=true;
					this.dispatchEvent(new Event("showMedia"));
				}

				if(tracker&&Global.playerparameter.islive=="false"){
					tracker.postEndLoading();
				}
				if (Global.preAdPlayComplete||Global.playerparameter.isAd=="false")
				{
					Global.mps.mediaPlayer.play();
				}
				else
				{
					DebugTip.instance.log("-------kankanplayer_setCache_try_pause_video--------");
					Global.mps.mediaPlayer.pause();
				}
			}
			else if (Global.crtMediaInfo["fileName"] == fileName && Global.mps.mediaPlayer.duration > 0)
			{
				Global.crtMediaInfo["seekTime"]=Global.crtMediaInfo["totalTime"] - Global.mps.mediaPlayer.duration;
				//Global.crtMediaInfo["seekX"]=0;
				//DebugTip.instance.log("修正seektime"+Global.crtMediaInfo["totalTime"]+"|"+Global.mps.mediaPlayer.duration);
			}

		}
		private var cacheTimer:Timer

		//***********************************VMS call interface*********************************//
		public function set configurationParameters(value:Object):void
		{
			Global.playerparameter.width=value.width;
			Global.playerparameter.height=value.height;
			Global.playerparameter.autoPlay=value.autoPlay;
			Global.playerparameter.isAd=value.isAd;
			Global.playerparameter.isRelation=value.isRelation;
			Global.playerparameter.playerLogoURL=value.playerLogoURL;
			Global.playerparameter.endbehavior=value.endbehavior;
			Global.playerparameter.isShare=value.isShare;
			Global.playerparameter.isShot=value.isShot;
			Global.playerparameter.logowidth=value.logowidth;
			Global.playerparameter.logoheight=value.logoheight;
			Global.playerparameter.logox=value.logox;
			Global.playerparameter.logoy=value.logoy;
			Global.playerparameter.preimageurl=value.preimageurl;
			Global.playerparameter.needPostPlayCount=value.needPostPlayCount;
			if (value.statisticsurl)
				Global.playerparameter.statisticsurl=value.statisticsurl;
			if (value.adstarttime)
				Global.adParameter.adstarttime=value.adstarttime;
			if (value.adduration)
				Global.playerparameter.adduration=value.adduration;
			if (value.adchinaid)
				Global.adParameter.adchinaid=value.adchinaid;
			if (value.xmlid)
				Global.xmlid=value.xmlid;
			if (value.omsid)
				Global.omsid=value.omsid;
			if (value.islive)
				Global.playerparameter.islive=value.islive;
			if (value.liveurl)
				Global.playerparameter.liveurl=value.liveurl;
			if (value.isembed)
				Global.playerparameter.isembed=value.isembed;
			if (value.ishls)
				Global.playerparameter.ishls=value.ishls;
			if (value.issizechangable)
				Global.playerparameter.issizechangable=value.issizechangable;
			if (value.preadloaderurl)
				Global.playerparameter.preadloaderurl=value.preadloaderurl;
			//Global.xmlid=value.xmlid;
			init();

		}
	}

}


