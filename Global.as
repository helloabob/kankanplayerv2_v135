package  {
	import com.bo.display.MyPlayer;
	import com.bo.elements.Tooltip;
	import com.bo.tracker.TrackerBase;
	import com.bo.utils.AdParameter;
	import com.bo.utils.PlayerParameters;
	import com.bo.utils.VideoData;
	
	import flash.display.Stage;
	import flash.text.TextField;
	
	import org.osmf.media.MediaPlayerSprite;

	public class Global {

		public function Global() {
			// constructor code
		}
		public static var initAppWidth:Number;
		public static var appWidth:Number;
		public static var appHeight:Number;
		public static var _stage:Stage;
		public static var videodata:VideoData=new VideoData();
		public static var playerparameter:PlayerParameters=new PlayerParameters();
		//public static var xmlid:String="vxml/2011-11-13/571197";
		//public static var xmlid:String="vxml/2012-07-11/1304360";
		public static var xmlid:String="vxml/2011-11-13/571197";
		//vxml/2012-11-15/1821423
		//public static var xmlid:String="";
		//public static var xmlid:String="http://www.dragontv.cn/masterchief/xml.php?id=111744";
		//public static var xmlid:String="http://www.bestv.cn/ajax/xml/xml.php?id=6616";
		//public static var isAd:String="false";
		public static var myPlayer:MyPlayer;
		public static var mps:MediaPlayerSprite;
		public static var main:kankanplayer;
		public static var txttime:TextField;
		public static var duration:Number;
		public static var paramType:int=0;
		public static var setupPlayer:Function;
		public static var protocolType:String="http";
		public static var playtype:int=0;  //0:video   1:ad
		public static var omsid:String="";
		public static var adParameter:AdParameter=new AdParameter();
		public static var notificationCenter:NotificationCenter=new NotificationCenter();
		public static var crtMediaInfo:Object={};//={"fileName":string,"totalTime":number,"seekTime":number,"seekX":number}
		//public static var _appkey:String="2579900422";  //sina appkey
		public static var _appkey:String="2579900422";  //sina appkey
		
		public static var _isVideo:Boolean=true;
		
		public static var _toolTip:Tooltip;
		public static var tracker:TrackerBase;
		public static var preAdPlayComplete:Boolean=false;
		public static var getVideoInfo:Boolean=false;
		public static var ignoreBuffer:Boolean=false;
	}
	
}
