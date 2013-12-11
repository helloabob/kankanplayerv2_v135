package com.bo.net
{
	public class Address
	{
		public function Address()
		{
		}
		public static const SINAAPIPATH:String="http://api.t.sina.com.cn/flash/crossdomain.xml";
		public static const LIVEPATH:String="rtmp://live.kksmg.com:80/live/";
		public static const LIVEFILE:String="mp4:Stream_1";
		
		//临时直播URL地址
		//public static const LIVEPATH:String="rtmp://live.kksmg.com:80/drslive/";
		//public static const LIVEFILE:String="drslive1";
		
		public static const XMLBASEPATH:String="http://www.kankanews.com/";
		//public static const XMLBASEPATH:String="http://localhost/";
		public static const XMLLIVEFILE:String="vxml/live";
		public static const PHPBASEPATH:String="/get_video_url.php?id=";
		public static const IMAGESERVERADDRSS:String="http://static.statickksmg.com/image";
		public static const SHAREHTML:String="http://www.kankanews.com/vods/";
		public static const SHAREFLASH:String="http://www.kankanews.com/flash/kkduiwplayer.swf";
	}
}