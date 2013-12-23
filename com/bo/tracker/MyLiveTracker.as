package com.bo.tracker
{
	import com.debugTip.DebugTip;
	import com.gridsum.VideoTracker.GSVideoState;
	import com.gridsum.VideoTracker.LiveMetaInfo;
	import com.gridsum.VideoTracker.LivePlay;
	import com.gridsum.VideoTracker.VideoInfo;
	import com.gridsum.VideoTracker.VideoTracker;
	
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import org.osmf.media.MediaPlayerState;

	public class MyLiveTracker extends TrackerBase
	{
		private var isContinueTrack:Boolean=true;
		private var liveMetaInfo:LiveMetaInfo;
		private var livePlay:LivePlay
		private var liveProvider:LiveInfoProviderImpl;
		private var tracker:VideoTracker;
		private var videoInfo:VideoInfo;
		private var canStop:Boolean=false;

		public function MyLiveTracker(col:String = "直播")
		{
			tracker=VideoTracker.getInstance("GVD-200015","GSD-200015");
			//var tid:String=Global._id;
			//tid=tid.substr(tid.lastIndexOf("/")+1);
			videoInfo=new VideoInfo("看看新闻直播");

			/*
			videoInfo.videoChannel=col;
			videoInfo.videoName=col;
			videoInfo.videoOriginalName=col;
			*/

			//videoInfo设置
			videoInfo.videoID="unknown"; //视频的ID标识以唯一识别一个视频
			videoInfo.videoOriginalName=Global.videodata.colname; //和ID对应的视频原始名称
			videoInfo.videoName=Global.videodata.colname; //视频别称
//			videoInfo.videoUrl=Global.videodata.videourl; //视频资源的URL
			videoInfo.videoUrl=Global.videodata.host; //视频页面地址
			videoInfo.videoTVChannel=Global.videodata.colname; //视频所属的电视频道
			videoInfo.videoWebChannel="/直播/"+Global.videodata.colname+"/"; //视频所属的网站栏目，支持最多5级，级与级之间用“/”分隔，例如“体育/球类/NBA”
			videoInfo.videoTag="普通直播"; //视频的标签，多个标签之间是并行关系，用“/”分隔
			videoInfo.videoFocus="unknown"; //视频所属的专题名称
			videoInfo.initialEditor="unknown"; //该视频的粗编
			videoInfo.fineEditor="unknown"; //该视频的精编
			videoInfo.voiceActing="unknown"; //该视频的配音
			videoInfo.excutiveEditor="unknown"; //该视频的责任编辑
			videoInfo.chiefEditor="unknown"; //该视频的主编
			videoInfo.chiefInspector="unknown"; //该视频的总监/中心
			videoInfo.cdn="unknown"; //本视频所使用的加速渠道名称

			liveProvider=new LiveInfoProviderImpl();
			livePlay=tracker.newLivePlay(videoInfo,liveProvider);
			livePlay.beginLoading();
			DebugTip.instance.log("gvLiveTrack:beginLiveloading~~~~~~~~"+videoInfo.videoName+"~~~~~~~~~~")
			//liveMetaInfo 设置
			liveMetaInfo=new LiveMetaInfo();
			//vodMetaInfo.videoDuration=Global._mps.mediaPlayer.duration;
			liveMetaInfo.bitrateKbps=450;
			liveMetaInfo.framesPerSecond=60;
			//直播没有结束，应该没有结束统计
			//livePlay.endLoading(true,liveMetaInfo);
			
			setTimeout(onEndLoading,1000);
		}
		
		public function onEndPlay():void{
			livePlay.endPlay();
		}

		public function postEndLoading():void{}
		
		private function onEndLoading(isForce:Boolean=false):void
		{
			if(isForce==true){
				if(canStop==true)return;
				livePlay.endLoading(true,liveMetaInfo);
				DebugTip.instance.log("gvLiveTrack:endLiveloading~~~~~~~~~~~~~~~~~");
				canStop=true;
				return;
			}else{
				if(canStop==true)return;
				if (Global.mps.mediaPlayer.bytesLoaded>0)
				{
					livePlay.endLoading(true,liveMetaInfo);
					DebugTip.instance.log("gvLiveTrack:endLiveloading~~~~~~~~~~~~~~~~~~"+Global.mps.mediaPlayer.bytesLoaded);
					canStop=true;
				}
				else
				{
					setTimeout(onEndLoading,1000);
				}
			}
		}		

		override public function changeState(src:String):void
		{
			
//			GSVideoState.BUFFERING
//			GSVideoState.CONNECTION_ERROR;
//			GSVideoState.DISCONNECTED;
//			GSVideoState.LOADING;
//			GSVideoState.NO_PLAYING_BUFFERING;
//			GSVideoState.PAUSED;
//			GSVideoState.PLAYING;
//			GSVideoState.REWINDING;
//			GSVideoState.SEEKING;
//			GSVideoState.STOPPED;
			
			
			DebugTip.instance.log("gvLiveTrack:"+src);
			
			switch (src)
			{
				case MediaPlayerState.BUFFERING:
					livePlay.onStateChanged(GSVideoState.BUFFERING);
					break;	
				case MediaPlayerState.PLAYBACK_ERROR:
					livePlay.onStateChanged(GSVideoState.CONNECTION_ERROR);
					break;
				case MediaPlayerState.LOADING:
					livePlay.onStateChanged(GSVideoState.LOADING);
					break;
				case MediaPlayerState.PAUSED:
					livePlay.onStateChanged(GSVideoState.PAUSED);
					break;
				case MediaPlayerState.PLAYING:
					livePlay.onStateChanged(GSVideoState.PLAYING);
					onEndLoading(true);
					break;
				//case MediaPlayerState.READY:
				//	isContinueTrack=false;
				//	livePlay.onStateChanged(GSVideoState.STOPPED);
				//	break;
				case GSVideoState.DISCONNECTED:
					livePlay.onStateChanged(GSVideoState.DISCONNECTED);
					break;
				case GSVideoState.NO_PLAYING_BUFFERING:
					livePlay.onStateChanged(GSVideoState.NO_PLAYING_BUFFERING);
					break;
				case GSVideoState.REWINDING:
					livePlay.onStateChanged(GSVideoState.REWINDING);
					break;
				case GSVideoState.SEEKING:	
					livePlay.onStateChanged(GSVideoState.SEEKING);
					break;
				case GSVideoState.STOPPED:
					livePlay.onStateChanged(GSVideoState.STOPPED);
					break;
				
			}
			
			DebugTip.instance.log("|myLiveTrack event|:" + src);
		}
		
		
	}
}
