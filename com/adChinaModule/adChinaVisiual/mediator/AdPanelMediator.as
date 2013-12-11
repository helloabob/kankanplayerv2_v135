package com.adChinaModule.adChinaVisiual.mediator
{
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.adChinaModule.adChinaModel.AdChinaModel;
	import com.adChinaModule.adChinaModel.proxy.AdDataProxy;
	import com.adChinaModule.adChinaVisiual.AdChinaVisiual;
	import com.adChinaModule.adChinaVisiual.view.AdPanelView;
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	public class AdPanelMediator extends Sprite
	{
		
		public var view:AdPanelView=new AdPanelView();
		private var adDataProxy:AdDataProxy=AdChinaModel.instance.adDataProxy;
		
		public function AdPanelMediator()
		{
		}
		
		public function init():void{
			trace("------------------add_event_listener_adcomplete-----------------");
			AdChinaMoudle.instance.addEventListener(AdChinaEvent.ADLOADCOMPLETE,showAd);
		}
		
		private function showAd(evt:Event):void{
			var adContent:*=view.addChild(adDataProxy.data.adContent);
			var width:Number=AdChinaVisiual.instance.st.stageWidth;
			var height:Number=AdChinaVisiual.instance.st.stageHeight;
			DebugTip.instance.log("---------plugin_prepare_ad------------"+width+","+height);
			adContent.initAdData({playerId:"4203",keyWords:Global.videodata.videotitle,wh:width+","+height,kw:Global.videodata.videotitle});
//			adContent.initAdData({playerId:"4203",wh:width+","+height});
			adContent.initPlayerData({allowAd:[1,1,1,1,1,1]});
			adContent.addEventListener("load_complete",adLdComplete);
			adContent.addEventListener("play",adPlayEnd);
			adContent.addEventListener("pause",adPlayStart);
			
		}
		
		private function adPlayEnd(evt:Event):void{
			/*
			if(!AdChinaModel.instance.adDataProxy.data.isPreAdPlayed){
				DebugTip.instance.log("-------------------get play adChina first ad end--------------------")
				AdChinaModel.instance.adDataProxy.data.isPreAdPlayed=true;
				AdChinaMoudle.instance.dispatchEvent(new Event("preadcomplete"));
			}else{
				
			}*/
			
			if(!AdChinaModel.instance.adDataProxy.data.isPreAdPlayed){
				DebugTip.instance.log("-------------------get play adChina first ad end--------------------")
				AdChinaModel.instance.adDataProxy.data.isPreAdPlayed=true;
				AdChinaMoudle.instance.dispatchEvent(new Event("preadcomplete"));
			}
			DebugTip.instance.log("-------------------get play adChina ad end--------------------")
			AdChinaMoudle.instance.dispatchEvent(new Event("adstop"));
		}
		
		private function adPlayStart(evt:Event):void{
			/*
			DebugTip.instance.log("--------------------get pause adChina ad start--------------------")
			if(AdChinaModel.instance.adDataProxy.data.isPreAdPlayed){
				AdChinaMoudle.instance.dispatchEvent(new Event("adstart"));
			}*/
			
			DebugTip.instance.log("--------------------get pause adChina ad start--------------------")
			AdChinaMoudle.instance.dispatchEvent(new Event("adstart"));
		}
		
		private function adLdComplete(evt:Event):void{
			DebugTip.instance.log("--------------------ad load--------------------")
			/*
			DebugTip.instance.log("--------------------get load_complete adChina loadComplete--------------------")
			if(!AdChinaModel.instance.adDataProxy.data.isPreAdLded){
				AdChinaModel.instance.adDataProxy.data.isPreAdLded=true;
			}*/
			AdChinaModel.instance.adDataProxy.data.isPreAdLded=true;
		}
		
		
	}
}