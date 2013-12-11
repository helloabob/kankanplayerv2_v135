package com.bo.net
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	public class MyMjURLLoader
	{
		//private var initPlayerURL:String=Address.XMLBASEPATH+"vxml/live.xml";
		private var initPlayerURL:String="http://www.kankanews.com/yaoming/mj.xml?t"+Math.random() ;
		//private var initPlayerURL:String="http://test.smgbb.cn/mj.xml";
		//private var initPlayerURL:String=Address.XMLBASEPATH+Global._id+".xml";
		public function MyMjURLLoader(){
		}
		public function initPlayer():void{
			var urlloader:URLLoader=new URLLoader();
			var req:URLRequest=new URLRequest(initPlayerURL);
			urlloader.addEventListener(Event.COMPLETE,onLoaderComplete);
			urlloader.load(req);
		}
		private function onLoaderComplete(evt:Event):void{
			//拼地址
			Global._xml=new XML(evt.target.data);
			//var url:String="rtmp://sports.kksmg.com:80/vod/mp4:"+Global._xml.filename;
			//Global._title=Global._xml.title;
			//trace(url);
			var url:String=Address.LIVEPATH+Address.LIVEFILE;
			trace(url);
			Global._smgbbplayer.initOSMF(url);
		}
	}
}
