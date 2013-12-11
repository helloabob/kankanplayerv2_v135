package com.bo.tracker
{
	import com.gridsum.VideoTracker.MetaInfo;
	import com.gridsum.VideoTracker.VideoInfo;
	import com.gridsum.VideoTracker.VodMetaInfo;
	
	import org.osmf.media.MediaElement;

	public class TrackerBase
	{
		public function TrackerBase()
		{
		}
		
		public function changeState(src:String):void{}
		
		public function trySetTrackAgain():void{
			
		}
		/*
		public function getMetaDataInfo():void{

			videoInfo.cdn
			videoInfo.chiefEditor
			videoInfo.chiefInspector
			videoInfo.excutiveEditor
			videoInfo.fineEditor
			videoInfo.initialEditor
			videoInfo.videoFocus
			videoInfo.videoID
			videoInfo.videoName
			videoInfo.videoOriginalName
			videoInfo.videoTag
			videoInfo.videoTVChannel
			videoInfo.videoUrl
			videoInfo.videoWebChannel
			videoInfo.voiceActing
		}*/
	}
}