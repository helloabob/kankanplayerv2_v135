package com.adChinaModule.adChinaModel.util.loadUtil
{
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.adChinaModule.adChinaModel.AdChinaModel;
	import com.adChinaModule.adChinaModel.data.AdData;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class LoadUtil
	{
		public function LoadUtil()
		{
		}
		
		public function init():void{
			
			var loader:Loader=new Loader();
//			loader.load(new URLRequest("http://s.acs86.com/FrameWork/AFP/ASP_v523.swf"), new LoaderContext(true));
			loader.load(new URLRequest("http://s.acs86.com/FrameWork/AFP/ASP410.swf"), new LoaderContext(true));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,ldComplete);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,error);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
		}
		
		public function initData():void{
			//AdChinaModel.instance.adContent=adContent;
		}
		
		protected function adPlayEnd(evt:Event):void{
			trace("----------- adPlayEnd()-----------");
			//AdChinaMoudle.instance.dispatchEvent(new Event("preadcomplete"));
		}
		
		protected function error(evt:Event):void
		{
			trace("-----------error()----------------");
			var loaderInfo:LoaderInfo=evt.currentTarget as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE,ldComplete);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,error);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,error);
			
			AdChinaMoudle.instance.dispatchEvent(new Event("preadcomplete"));
			
		}
		
		protected function ldComplete(evt:Event):void
		{
			
			trace("-----------ldcomplete----------------");
			var loaderInfo:LoaderInfo=evt.currentTarget as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE,ldComplete);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,error);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,error);
			
			AdChinaModel.instance.adDataProxy.data.adContent=loaderInfo.loader.content;
			
			//initData();
		}
	}
}