package com.bo.interfaces
{
	import com.sina.events.VideoPlayerEvent;
	import com.sina.interfaces.IVideoPlayer;
	
	import flash.display.BitmapData;

	public class VideoPlayerImpl implements IVideoPlayer
	{
		public function MyDispatchEvent(t:String,obj:Object=null):void{
			Global._smgbbplayer.dispatchEvent(new VideoPlayerEvent(t,obj));
		}
		public function VideoPlayerImpl()
		{
		}
		
		public function play(param:Object=null):void
		{
		}
		
		public function pause():void
		{
			Global._mps.mediaPlayer.pause();
		}
		
		public function resume():void
		{
			Global._mps.mediaPlayer.play();
		}
		
		public function destory():void
		{
			Global._mps.mediaPlayer.stop();
		}
		
		public function get playTime():Number
		{
			return Math.floor(Global._mps.mediaPlayer.currentTime);
		}
		
		public function get totalTime():Number
		{
			return Global._mps.mediaPlayer.duration;
		}
		
		public function setSize(width:Number, height:Number, isFull:Boolean=false):void
		{
			Global.APPWIDTH=width;
			Global.VIDEOHEIGHT=height;
			Global._smgbbplayer.onStageResize(null);
		}
		
		public function get snapshot():Object
		{
			var bmd:BitmapData=new BitmapData(Global.APPWIDTH,Global.VIDEOHEIGHT);
			bmd.draw(Global._mps);
			return bmd;
		}
		
		public function seek(time:Number):void
		{
			Global._mps.mediaPlayer.seek(time);
		}
		
		public function get controlBarHeight():Number
		{
			return 50;
		}
	}
}