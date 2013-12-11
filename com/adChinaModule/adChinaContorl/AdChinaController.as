package com.adChinaModule.adChinaContorl
{
	import com.adChinaModule.adChinaModel.AdChinaModel;
	import com.adChinaModule.adChinaVisiual.AdChinaVisiual;
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;

	public class AdChinaController extends Sprite
	{
		private static var _instance:AdChinaController;
		
		
		public function AdChinaController(pClass:pvt)
		{
			
		}
		
		public static function get instance():AdChinaController
		{
			if (!_instance)
			{
				_instance=new AdChinaController(new pvt());
			}
			
			return _instance
		}
		
		public function init():void{
			
			AdChinaVisiual.instance.adPanel.init();
			
		}
		
		public function sendTimeAction():void{
			//trace("AdChinaTime",Global.mps.mediaPlayer.currentTime)
			AdChinaModel.instance.adDataProxy.data.adContent.playLine(Global.mps.mediaPlayer.currentTime);
		};
		
		public function showEndAd():void{
			trace("adChinaMoudle showEndAd");
			if(AdChinaModel.instance.adDataProxy.data.isPreAdPlayed)
			AdChinaModel.instance.adDataProxy.data.adContent.playAction("stop");
		}
		
		public function showPauseAd():void{
			if(AdChinaModel.instance.adDataProxy.data.isPreAdPlayed)
			trace("adChinaMoudle showPauseAd");
			AdChinaModel.instance.adDataProxy.data.adContent.playAction("pauseBtn");
		}
		
		public function hidePauseAd():void{
			trace("adChinaMoudle hidePauseAd");
			if(AdChinaModel.instance.adDataProxy.data.isPreAdPlayed)
			AdChinaModel.instance.adDataProxy.data.adContent.playAction("playBtn");
		}
		
		public function fullScreen():void{
			
			if(!AdChinaModel.instance.adDataProxy.data.adContent)return;
			
			var w:Number=AdChinaVisiual.instance.st.stageWidth;
			var h:Number=AdChinaVisiual.instance.st.stageHeight;
			//AdChinaModel.instance.adDataProxy.data.adContent.setAreaSize(w,h);
			AdChinaModel.instance.adDataProxy.data.adContent.playAction("fullScreen",{"adAreaWidth":w,"adAreaHeight":h});
			DebugTip.instance.log("adChinaMoudle fullScreen"+w+"|"+h);
		}
		
		public function normalScreen():void{
			if(!AdChinaModel.instance.adDataProxy.data.adContent)return;
			trace("adChinaMoudle normalScreen");
			var w:Number=AdChinaVisiual.instance.st.stageWidth;
			var h:Number=AdChinaVisiual.instance.st.stageHeight;
			//AdChinaModel.instance.adDataProxy.data.adContent.setAreaSize(w,h);
			AdChinaModel.instance.adDataProxy.data.adContent.playAction("normal");
			DebugTip.instance.log("adChinaMoudle normalScreen"+w+"|"+h);
		}
		
	}
}

class pvt
{
}
