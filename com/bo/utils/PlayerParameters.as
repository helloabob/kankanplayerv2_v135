package com.bo.utils {
	
	public class PlayerParameters {

		public function PlayerParameters() {
			// constructor code
		}
		public var autoPlay:String="true";   //自动播放参数
		public var playerLogoURL:String="";
		//public var playerLogoURL:String="http://www.kankanews.com/skin/kkv3/images/sy_0906_150x53.png";
		//public var playerLogoURL:String="http://skin.kankanews.com/kkv3/images/kkbo_logo.png";   //LOGO 图片地址 
		public var preimageurl:String="";  //首帧图片地址
		public var isAd:String="true";    //是否播放广告
		public var isGoogleAd:String="false";	//是否播放google广告
		public var isRelation:String="true";   //是否加载相关视频
		//public var ifJumpToNextVideo:String="false";   //是否跳转下一个视频
		public var pausebehavior:String="0";  //暂停行为 0无任何操作  1显示相关视频  2显示广告  
		public var endbehavior:String="0";  //播放结束后的行为 0无任何操作  1显示相关视频  2跳转下一视频  3显示首帧图  4第二版相关视频
		public var isShot:String="false";
		public var isShare:String="false";
		public var needPostPlayCount:String="false";
		public var statisticsurl:String="http://interface.kankanews.com/kkapi/vclick.php?id=##&skey=player";
		public var logowidth:int=162;
		public var logoheight:int=80;
		public var logox:int=50;
		public var logoy:int=50;
		public var adduration:int=15;
		public var width:int=600;
		public var height:int=482;
		public var islive:String="false";
		public var liveurl:String="rtmp://live.kksmg.com/live/mp4:Stream_1";
		public var isembed:String="false";
		public var ishls:String="false";
		public var issizechangable:String="false";		
		public var preadloaderurl:String="http://www.kankanews.com/flash/Preload/PreAdLoaderAD.swf";	
		//public var preadloaderurl:String="http://www.kankanews.com/flash/PreAdLoaderTest.swf";
		//public var preadloaderurl:String="PreAdLoaderAD.swf";
		//public var preadloaderurl:String="http://test.smgbb.cn/~wangbo/pread/PreAdLoader.swf";
	}
	
}

