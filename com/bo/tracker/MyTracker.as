package com.bo.tracker
{
	import com.ToolUtils.ToolStringUtil;
	import com.debugTip.DebugTip;
	import com.gridsum.VideoTracker.GSVideoState;
	import com.gridsum.VideoTracker.Play;
	import com.gridsum.VideoTracker.VideoInfo;
	import com.gridsum.VideoTracker.VideoTracker;
	import com.gridsum.VideoTracker.VodMetaInfo;
	import com.gridsum.VideoTracker.VodPlay;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import org.osmf.media.MediaPlayerState;

	public class MyTracker extends TrackerBase
	{
		private var isContinueTrack:Boolean=true;
		private var tracker:VideoTracker;
		private var videoInfo:VideoInfo;
		private var vodMetaInfo:VodMetaInfo;
		private var vodPlay:VodPlay;
		private var vodProvider:VodInfoProviderImpl;
		//private var statisticsurl:String="http://interface.kankanews.com/kkapi/kkvclick.php?id=";
		public function MyTracker(prefix:String = "",col:String = "")
		{
			
			tracker=VideoTracker.getInstance("GVD-200015","GSD-200015");
			var tid:String=Global.xmlid;
			tid=tid.substr(tid.lastIndexOf("/") + 1);
			if (Global.playerparameter.needPostPlayCount == "true")
			{
				//小吴
				var s_url:String         =Global.playerparameter.statisticsurl.replace("##",tid) + "&t=" + int(Math.random() * 10000000);
				//var urlrequest:URLRequest=new URLRequest(statisticsurl+tid+"&addclick=1&t="+Math.random());
				var urlrequest:URLRequest=new URLRequest(s_url);
				trace("mytracker's url:",s_url);
				var urlloader:URLLoader  =new URLLoader();
				try
				{
					urlloader.load(urlrequest);
				}
				catch (error:Error)
				{
				}

					//张和胜
				/*
				trace("tracker_omsid:"+Global.omsid);
				if(Global.omsid!=""){
				var b_url="http://oms.kankanews.com/oms/share/video_view_num.php?omsid="+Global.omsid+"&t="+Math.random();
				var urlrequest2:URLRequest=new URLRequest(b_url);
				trace(b_url);
				var urlloader2:URLLoader=new URLLoader();
				urlloader2.load(urlrequest2);
				}*/

			}
			videoInfo=new VideoInfo(tid);
			if (col == "")
			{
				tid=Global.videodata.colname;
				tid=prefix + tid;
				tid=tid.substr(0,tid.length - 1);
			}
			else
			{
				tid=col;
			}
			//videoInfo.videoChannel=tid;
			//videoInfo.videoName=Global.videodata.videotitle;
			//videoInfo.videoOriginalName=Global.videodata.videotitle;
			//videoInfo.videoUrl=Global.videodata.videourl;

			videoInfo.videoID=Global.omsid; //	视频的ID标识以唯一识别一个视频
			videoInfo.videoOriginalName=Global.videodata.videotitle; //和ID对应的视频原始名称
			videoInfo.videoName=Global.videodata.videotitle; //视频别称
//			videoInfo.videoUrl=Global.videodata.videourl; //视频资源的URL
			videoInfo.videoUrl=Global.videodata.host; //视频页面地址
			videoInfo.videoTVChannel="unknown"; //视频所属的电视频道
			videoInfo.videoWebChannel=ToolStringUtil.instance.getChannelNameFromString(Global.videodata.colname); //视频所属的网站栏目，支持最多5级，级与级之间用“/”分隔，例如“体育/球类/NBA”
			videoInfo.videoTag="unknown"; //视频的标签，多个标签之间是并行关系，用“/”分隔
			videoInfo.videoFocus="unknown"; //视频所属的专题名称
			videoInfo.initialEditor="unknown"; //该视频的粗编
			videoInfo.fineEditor="unknown"; //该视频的精编
			videoInfo.voiceActing="unknown"; //该视频的配音
			videoInfo.excutiveEditor="unknown"; //该视频的责任编辑
			videoInfo.chiefEditor="unknown"; //该视频的主编
			videoInfo.chiefInspector="unknown"; //该视频的总监/中心
			videoInfo.cdn=Global.videodata.cdn//"unknown"; //本视频所使用的加速渠道名称

			DebugTip.instance.log("mytracker,channelName:"+ ToolStringUtil.instance.getChannelNameFromString(Global.videodata.colname)+"|tid:"+tid);
			vodProvider=new VodInfoProviderImpl(Global.mps.mediaPlayer);

			vodPlay=tracker.newVodPlay(videoInfo,vodProvider);
			vodPlay.beginLoading();
			
			trace("beginloading~~~~~~~~~~~~~~~~~~")
			
			vodMetaInfo=new VodMetaInfo();
			vodMetaInfo.videoDuration=Global.mps.mediaPlayer.duration;
			vodMetaInfo.bitrateKbps=450;
			if (vodMetaInfo.videoDuration == 0 || isNaN(vodMetaInfo.videoDuration))
			{
				DebugTip.instance.log("traceOnEndloading");
//				setTimeout(onEndLoading,1000);
			}
			
		}
		
		override public function trySetTrackAgain():void{
			if(Global.videodata.cdn!=videoInfo.cdn){
				DebugTip.instance.log("------resend cdnInfo--------");
				videoInfo.cdn=Global.videodata.cdn;
				vodPlay.setVideoInfo(videoInfo);
			}
		
		}

		override public function changeState(src:String):void
		{
			if(!isContinueTrack)return;
			
//			GSVideoState.BUFFERING;
//			GSVideoState.CONNECTION_ERROR;
//			GSVideoState.DISCONNECTED;
//			GSVideoState.LOADING;
//			GSVideoState.NO_PLAYING_BUFFERING;
//			GSVideoState.PAUSED;
//			GSVideoState.PLAYING;
//			GSVideoState.REWINDING;
//			GSVideoState.SEEKING;
//			GSVideoState.STOPPED;
			
			DebugTip.instance.log("gvTrack:"+src);
			switch (src)
			{
				case MediaPlayerState.BUFFERING:
					if(Global.ignoreBuffer==true){
						Global.ignoreBuffer=false;
					}else{
						vodPlay.onStateChanged(GSVideoState.BUFFERING);
					}
					break;	
				case MediaPlayerState.PLAYBACK_ERROR:
					vodPlay.onStateChanged(GSVideoState.CONNECTION_ERROR);
					break;
				case MediaPlayerState.LOADING:
					vodPlay.onStateChanged(GSVideoState.LOADING);
					break;
				case MediaPlayerState.PAUSED:
					vodPlay.onStateChanged(GSVideoState.PAUSED);
					break;
				case MediaPlayerState.PLAYING:
					vodPlay.onStateChanged(GSVideoState.PLAYING);
					break;
				case MediaPlayerState.READY:
					isContinueTrack=false;
					vodPlay.onStateChanged(GSVideoState.STOPPED);
					break;
				case GSVideoState.DISCONNECTED:
					vodPlay.onStateChanged(GSVideoState.DISCONNECTED);
					break;
				case GSVideoState.NO_PLAYING_BUFFERING:
					vodPlay.onStateChanged(GSVideoState.NO_PLAYING_BUFFERING);
					break;
				case GSVideoState.REWINDING:
					vodPlay.onStateChanged(GSVideoState.REWINDING);
					break;
				case GSVideoState.SEEKING:	
					vodPlay.onStateChanged(GSVideoState.SEEKING);
					break;
				case GSVideoState.STOPPED:
					vodPlay.onStateChanged(GSVideoState.STOPPED);
					break;
			}
			
			
		}
		
		public function onEndPlay():void{}
		
		public function postEndLoading():void{
			vodMetaInfo.videoDuration=Global.mps.mediaPlayer.duration;
			if(vodMetaInfo.videoDuration==0||isNaN(vodMetaInfo.videoDuration)){
				setTimeout(postEndLoading,1000);
			}else{
				DebugTip.instance.log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~endLoading~~~~~~~~~~~~~~~~~~~~~~~");
				vodPlay.endLoading(true,vodMetaInfo);
			}
		}

		private function onEndLoading():void
		{
			vodMetaInfo.videoDuration=Global.mps.mediaPlayer.duration;
			//trace("length of the video:" + vodMetaInfo.videoDuration);
			if (vodMetaInfo.videoDuration == 0 || isNaN(vodMetaInfo.videoDuration))
			{
				//trace("retry to load");
				setTimeout(onEndLoading,1000);
			}
			else
			{
				vodPlay.endLoading(true,vodMetaInfo);
				trace("endloading~~~~~~~~~~~~~~~~~~")
			}
		}
	}
}


