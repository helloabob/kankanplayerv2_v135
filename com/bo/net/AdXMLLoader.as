package com.bo.net {
	import com.bo.events.MyEvent;
	import com.bo.utils.XMLParser;
	import com.debugTip.DebugTip;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AdXMLLoader{
		private var url:String;
		private var urlloader:URLLoader;
		public function AdXMLLoader() {
		}
		public function loadxml():void{
			//var url0:String="http://kknimedia.allyes.com/main/s?user=||kankantiepian&db=kknimedia&border=0&local=list";
			var tmp:String=Global.videodata.host;
			tmp=tmp.substring(tmp.indexOf("//")+2,tmp.indexOf("."));
			var tmp2:String="";
			if(tmp=="world"){
				tmp2="world";
			}else if(tmp=="finance"){
				tmp2="finance";
			}else if(tmp=="sports"){
				tmp2="sports";
			}else if(tmp=="society"){
				tmp2="society";
			}else if(tmp=="ent"){
				tmp2="ent";
			}else if(tmp=="shanghai"){
				tmp2="shanghai";
			}else{
				tmp2="domestic";
			}
			//http://video6.smgbb.cn/experience/player_xml/75233569613545473.xml
			//var url0:String="";
			/*if(Global.videodata.videotitle.indexOf("声动亚洲完整")>=0){
				url0="http://114.80.151.73/main/s?user=||"+tmp2+"&db=kknimedia&border=0&local=list&kv=key|shengdong";
			}else{
				url0="http://114.80.151.73/main/s?user=||"+tmp2+"&db=kknimedia&border=0&local=list";
			}*/
			var url0:String="http://kknimedia.kankanews.com/main/s?user=||"+tmp2+"&db=kknimedia&border=0&local=list&kv=key|"+Global.videodata.videotitle+";random|"+ int(Math.random() * 100000000);
			//Global.videodata.videotitle="12声动亚洲12";
			//var url0:String="http://114.80.151.73/main/s?user=||kktestzhuanyong&db=kknimedia&border=0&local=list&kv=name|"+Global.videodata.videotitle+";time|30";
			
			//var url0:String="http://114.80.151.73/main/s?user=||test&db=kknimedia&border=0&local=list&kv=key|"+Global.videodata.videotitle;
			url="http://interface.kankanews.com/kkapi/adxmlconverter3.php?url="+encodeURI(url0);
			trace("============ad_load_xml==="+url);
			//url="http://kknimedia.allyes.com/main/s?user=||kankantiepian&db=kknimedia&border=0&local=list";
			urlloader=new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,onxmlcomplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
			urlloader.load(new URLRequest(url));
			DebugTip.instance.log("url"+url);
			
			/*Global.adParameter.hasPreAd=true;
			Global.adParameter.hasEndAd=true;
			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.ADXMLCOMPLETE));*/
		}
		private function onxmlcomplete(evt:Event):void{
			trace("ad_load_xml_complete");
			//trace(evt.target.data);
			urlloader.removeEventListener(Event.COMPLETE,onxmlcomplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
			//trace(urlloader.data);
			
			XMLParser.parseAdXML(new XML(urlloader.data));
			//trace('bbb');
			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.ADXMLCOMPLETE));
		}
		private function onIOError(evt:Event):void{
			urlloader.removeEventListener(Event.COMPLETE,onxmlcomplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOError);
			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.ADXMLERROR));
		}
	}
}
