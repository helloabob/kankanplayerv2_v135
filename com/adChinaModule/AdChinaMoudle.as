package com.adChinaModule
{
	import com.adChinaModule.adChinaContorl.AdChinaController;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;
	import com.adChinaModule.adChinaModel.AdChinaModel;
	import com.adChinaModule.adChinaVisiual.AdChinaVisiual;
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AdChinaMoudle extends Sprite
	{
		private static var _instance:AdChinaMoudle;
		
		public function AdChinaMoudle(pClass:pvt)
		{
			
		}
		
		public static function get instance():AdChinaMoudle
		{
			if (!_instance)
			{
				_instance=new AdChinaMoudle(new pvt());
			}
			
			return _instance
		}
		
		public function init(st:Stage):void{
			AdChinaModel.instance.init();
			AdChinaVisiual.instance.init(st);
			AdChinaController.instance.init();
			
			addListener();
		}
		
		private function addListener():void
		{
			this.addEventListener(AdChinaEvent.SHOWENDAD,showEndAdAction);
			this.addEventListener(AdChinaEvent.TIMEACTION,sendTimeAction);
			this.addEventListener(AdChinaEvent.SHOWPAUSEAD,showPauseAdAction);
			this.addEventListener(AdChinaEvent.HIDEPAUSEAD,hidePauseAdAction);
			this.addEventListener(AdChinaEvent.FULLSCREEN,fullScreen);
			this.addEventListener(AdChinaEvent.NORMALSCREEN,normalScreen);
//			var tt:Timer=new Timer(500);
//			tt.addEventListener(TimerEvent.TIMER,ontt);
//			tt.start();
		}		
		
		private function ontt(evt:TimerEvent):void{
			trace("ontt");
			this.dispatchEvent(new AdChinaEvent(AdChinaEvent.NORMALSCREEN));
		}
		
		protected function showEndAdAction(event:Event):void
		{
			AdChinaController.instance.showEndAd();
		}
		
		protected function fullScreen(event:Event):void
		{
			
			AdChinaController.instance.fullScreen();
			
		}
		
		protected function normalScreen(event:Event):void
		{
			AdChinaController.instance.normalScreen();
		}
		
		protected function hidePauseAdAction(event:Event):void
		{
			AdChinaController.instance.hidePauseAd();
		}
		
		protected function showPauseAdAction(event:Event):void
		{
			AdChinaController.instance.showPauseAd();
		}
		
		protected function sendTimeAction(event:Event):void
		{
			AdChinaController.instance.sendTimeAction();
		}	
		
		
		
	}
}

class pvt
{
}
