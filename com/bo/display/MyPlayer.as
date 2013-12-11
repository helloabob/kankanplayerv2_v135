package com.bo.display
{
	import com.ToolUtils.ToolStringUtil;
	import com.bestv.HLS.HTTPStreamingM3U8NetLoader;
	import com.bo.utils.Statistics;
	import com.bo.utils.StatisticsType;
	import com.debugTip.DebugTip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.osmf.elements.AudioElement;
	import org.osmf.elements.SoundLoader;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.layout.ScaleMode;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetStreamLoadTrait;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;

	public class MyPlayer extends Sprite
	{
		var mps:MediaPlayerSprite;
		private var livecheck:Timer=new Timer(15000,1);
		private var fp:Boolean     =true;
		private var bmpCache:Bitmap;

		public function MyPlayer()
		{
			//this.addEventListener("addCache",addCacheBitmap);
			//this.addEventListener("removeCache",removeCacheBitmap);
		}
		
		protected function removeCacheBitmap(event:Event=null):void
		{
			if(!bmpCache||!bmpCache.bitmapData){
				DebugTip.instance.log("removeCachePictureFail")
				return;
			}
			
			
			Global.mps.mediaPlayer.play();
			
			DebugTip.instance.log("removeCachePictureSuccess")
			this.removeChild(bmpCache);
			bmpCache.bitmapData.dispose();
			bmpCache.bitmapData=null;
			bmpCache=null;
		}
		
		protected function addCacheBitmap(event:Event):void
		{
			DebugTip.instance.log("addCachePicture");
			
			Global.mps.mediaPlayer.pause();
			
			var bmd:BitmapData=new BitmapData(Global.appWidth,Global.appHeight,false,0xcccccc);
			bmpCache=new Bitmap(bmd);
			bmd.draw(Global.mps);
			this.addChild(bmpCache);
		}
		
		public function rearrange():void
		{
			try
			{
				mps.width=Global.appWidth;
				if (Global._stage.displayState == StageDisplayState.FULL_SCREEN)
					mps.height=Global.appHeight;
				else
					mps.height=Global.appHeight - 32;
			}
			catch (err:Error)
			{
				trace(err.message);
			}
		}

		public function changeChannel():void
		{
			/*var ve:*=loadm3u8url();
			mps.media=ve;*/
			setup();
		}

		private function loadm3u8url():*
		{
			var m3u8url:String                   =Global.videodata.videourl;
			var baseUrl:String                   =m3u8url.substr(0,m3u8url.lastIndexOf("/") + 1);
			var resource:URLResource             =new URLResource(m3u8url);
			var loader:HTTPStreamingM3U8NetLoader=new HTTPStreamingM3U8NetLoader(baseUrl); // haven't yet got a plugin for the factory, so we need to explictly specify the loader
			var videoElement:VideoElement        =new VideoElement(resource,loader);
			videoElement.smoothing=true;
			return videoElement;
		}

		private function analysisLiveUrl(ve:*):*
		{
			if (Global.videodata.videourl == "")
			{
//				Global.videodata.videourl="http://live-cdn.kksmg.com/channels/tvie/dycj/m3u8:sd";
//				Global.videodata.videourl="http://172.16.10.152/iphone/downloads/ch1/index.m3u8";
//				Global.videodata.videourl="http://live.bestvcdn.com/gslb/url/Bestv/live/live/kknews/live.m3u8?se=mobile&ct=2";
//				Global.videodata.videourl="http://hls.kksmg.com/iphone/downloads/ch1/index.m3u8";
				Global.videodata.videourl=Global.videodata.channelListXML.video_clip[0].titleurl;
				Global.videodata.colname=Global.videodata.channelListXML.video_clip[0].title;
			}
			//Global.videodata.videourl="rtmp://ocj1.smgbb.cn/live/ocj1";
			//Global.videodata.videourl="rtmp://live.kksmg.com/live/young";
			if (Global.videodata.videourl.indexOf("m3u8") > 0)
			{
				ve=loadm3u8url();
			}
			else
			{
				trace("live_url:" + Global.videodata.videourl);
				ve=new VideoElement(new StreamingURLResource(Global.videodata.videourl,StreamType.LIVE));
				ve.smoothing=true;
			}
			return ve;
		}

		private function oncheck(evt:TimerEvent):void
		{
			trace("error in live");

			this.processErrorInLive();
		}

		public function setup():void
		{
			//何胜test
			//Global.videodata.videourl="http://domhttp.kksmg.com/2013/06/03/h264_450k_mp4_b6e33e30abd969ce4492363fb046bec7_166.mp4?start=0"
			//Global.videodata.videourl="http://video1.kksmg.com/rendition/201208/88000/94/86516329246359554/86516331125408770/r86516331125408770-800k-720x404.mp4";
			//Global.videodata.videourl="http://domhttp.kksmg.com/2012/06/22/h264_450k_mp4_CCTVNEWS2012062206005602078443876000_aac.mp4"
			//Global.videodata.videourl="http://domhttp.kksmg.com/2013/05/20/h264_450k_mp4_39b9bae0edc86e2f59365f064c9a8758_166.mp4"			
			//Global.videodata.videourl="http://video1.kksmg.com/rendition/201304/88000/59/107661915680931841/107661917828415489/r107661917828415489.m3u8";//stage.loaderInfo.parameters["src"];
			//Global.videodata.videourl="http://domhttp.kksmg.com/2013/05/01/h264_450k_mp4_f9076cd367494359f079fc1ea078dc46_ncd.mp4";
			//Global.videodata.videourl="http://video1.kksmg.com/rendition/201208/88000/94/86516329246359554/86516331125408770/r86516331125408770-800k-720x404.mp4";
			//Global.videodata.videourl="http://live-cdn1.smgbb.tv/channels/bbtv/xwzh/flv:sd/live"
			//Global.videodata.videourl="http://domhttp.kksmg.com/2013/01/31/h264_800k_mp4_d67b2cb5025e42c6abb2a3983af2ba94_2441692.mp4";
			//Global.videodata.videourl="http://domhttp.kksmg.com/2012/07/09/h264_450k_mp4_SHNews20120709074844514792634176996_aac.mp4";
			//Global.videodata.videourl="http://video1.kksmg.com/rendition/201304/88000/59/107661915680931841/107661917828415489/r107661917828415489.m3u8" ;//"http://gslb.bestvcdn.com/gslb/url/Bestv/live/live/wypd/workflow1.m3u8";
			
			DebugTip.instance.log("setupplayer--------"+Global.videodata.videourl);
			var ve:*;
			if (Global.playerparameter.islive == "true")
			{
				ve=this.analysisLiveUrl(ve);
			}
			else
			{
				if (Global.videodata.videourl.indexOf(".mp3") > 0)
				{
					//Global.videodata.videourl="http://test.abcd.com/mp3.mp3";
					//ve=new DefaultMediaFactory().createMediaElement(new URLResource(Global.videodata.videourl));
					//flash.system.Security.loadPolicyFile("http://video6.smgbb.cn/crossdomain.xml");
					//flash.system.Security.loadPolicyFile("http://122.227.209.29/video6.smgbb.cn/crossdomain.xml");
					var soundLoader:SoundLoader=new SoundLoader(true);
					ve=new AudioElement(new URLResource(Global.videodata.videourl),soundLoader);
					Global._isVideo=false;
				}
				else
				{
					if (Global.videodata.videourl.indexOf(".m3u8") > 0)
					{
						ve=loadm3u8url();
					}
					else
					{
						var holeName:String=ToolStringUtil.instance.getHoleNameWithHttpString(Global.videodata.videourl);
						ve=new VideoElement(new URLResource(holeName+"?start=0"));//ve=new VideoElement(new URLResource(holeName+ "?start=1"));
						ve.smoothing=true;
						
						Global.crtMediaInfo["seekTime"]=0;
						Global.crtMediaInfo["seekX"]=0;
					}
				}
			}
			//var ve:VideoElement=new VideoElement(new URLResource("http://msnms.allyes.com.cn/msnms/imediatest/20120216/14_39_31_1E0E7B1C.flv"));
			//ve.smoothing=true;
			if (!mps)
			{
				DebugTip.instance.log("check step222222222");
				mps=new MediaPlayerSprite();
				mps.width=Global.appWidth;
				mps.height=Global.appHeight - 32;
				mps.scaleMode=ScaleMode.LETTERBOX;
				mps.mediaPlayer.volume=1;
				mps.mediaPlayer.autoRewind=false;
				//mps.mediaPlayer.switchDynamicStreamIndex(mps.mediaPlayer.d);
				mps.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,onStateChange);
				Global.mps=mps;
				addChild(mps);
			}
			if (Global.playerparameter.autoPlay != "false"){
				DebugTip.instance.log("autoPlay is true");
				mps.media=ve;
			}	
		}

		public function initAndPlayVideo():void
		{
			var ve:*;
			if (Global.playerparameter.islive == "true")
			{
				ve=this.analysisLiveUrl(ve);
			}
			else
			{
				if (Global.videodata.videourl.indexOf(".mp3") > 0)
				{
					ve=new DefaultMediaFactory().createMediaElement(new URLResource(Global.videodata.videourl));
				}
				else
				{
					var holeName:String=ToolStringUtil.instance.getHoleNameWithHttpString(Global.videodata.videourl);
					trace("myplayer initAndPlayVideo:",holeName)
					ve=new VideoElement(new URLResource(holeName));//ve=new VideoElement(new URLResource(holeName+ "?start=1"));
					ve.smoothing=true;
					
					Global.crtMediaInfo["seekTime"]=0;
					Global.crtMediaInfo["seekX"]=0;
				}
			}
			mps.media=ve;
		}

		private function onStateChange(evt:MediaPlayerStateChangeEvent):void
		{
			//DebugTip.instance.log("------myplayer state-------"+evt.state+"----------------");
			//flash.external.ExternalInterface.call("alert",evt.state);
			switch (evt.state)
			{
				case MediaPlayerState.PLAYING:
				{
					this.livecheck.reset();

					if (fp && Global.videodata.videourl.indexOf(".mp4") > 0)
					{
						fp=false;
						var ve:VideoElement             =this.mps.media as VideoElement;
						var loadTrait:NetStreamLoadTrait=ve.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
						var ns:NetStream                =loadTrait.netStream;
						ns.checkPolicyFile=true;

						try
						{
							var tmp:String =Global.videodata.host;
							tmp=tmp.substring(tmp.indexOf("//") + 2,tmp.indexOf("."));
							var tmp2:String="";
							if (tmp == "world")
							{
								tmp2="world";
							}
							else if (tmp == "finance")
							{
								tmp2="fin";
							}
							else if (tmp == "sports")
							{
								tmp2="sport";
							}
							else if (tmp == "society")
							{
								tmp2="soc";
							}
							else if (tmp == "ent")
							{
								tmp2="ent";
							}
							else if (tmp == "ipai")
							{
								tmp2="ipai";
							}
							else
							{
								tmp2="dom";
							}
							var url:String ="http://" + tmp2 + "http.kksmg.com/crossdomain.xml";
							flash.system.Security.loadPolicyFile(url);
						}
						catch (err:Error)
						{
						}
						flash.system.Security.loadPolicyFile("http://video6.smgbb.cn/crossdomain.xml");


					}

					break;
				}
				case MediaPlayerState.READY:
				{
					break;
				}
				case MediaPlayerState.LOADING:
				{
					break;
				}
				case MediaPlayerState.BUFFERING:
				{
					break;
				}
				case MediaPlayerState.PLAYBACK_ERROR:
				{
					if (Global.playerparameter.islive == "true")
					{
						this.processErrorInLive();
					}
					break;
				}
			}
			dispatchEvent(evt);
		}

		private function processErrorInLive():void
		{
			this.livecheck.reset();
			var str:String=Global.videodata.videourl;
			Statistics.callJsStatisticsInfo(str);
			var url:String="";
			if (str.indexOf("rtmp") >= 0)
			{
				Statistics.postStatisticsInfo(StatisticsType.ccrtmp,"error");
				url="http://live-cdn1.smgbb.tv/channels/bbtv/kkxww/flv:sd/live";
			}
			else if (str.indexOf("smgbb.tv") >= 0)
			{
				Statistics.postStatisticsInfo(StatisticsType.tvie,"error");
				url="http://live.bestvcdn.com/tvodlive/dfws/workflow1.m3u8";
			}
			else if (str.indexOf("bestvcdn") >= 0)
			{
				Statistics.postStatisticsInfo(StatisticsType.bestv,"error");
				url="rtmp://live.kksmg.com/live/mp4:Stream_1";
			}
			trace("new_live_url:" + url);
			var ve:*;
			Global.videodata.videourl=url;
			if (Global.videodata.videourl.indexOf("m3u8") > 0)
			{
				ve=loadm3u8url();
			}
			else
			{
				ve=new VideoElement(new StreamingURLResource(Global.videodata.videourl,StreamType.LIVE));
				ve.smoothing=true;
			}
			mps.media=ve;
		}

		public function seekMp4(str:String):void
		{
			Global.videodata.videourl=str;
			var fileName:String=ToolStringUtil.instance.getFileNameWithHttpString(Global.videodata.videourl);
			if (Global.crtMediaInfo["fileName"] == fileName && fileName.indexOf(".mp4") > 0)
			{
				mps.media=new VideoElement(new URLResource(Global.videodata.videourl));
			}
		}

	}

}
