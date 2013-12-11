package com.adChinaModule.adChinaModel.proxy
{
	import com.adChinaModule.adChinaModel.data.AdData;
	import com.adChinaModule.adChinaModel.util.loadUtil.LoadUtil;
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;

	public class AdDataProxy extends Sprite
	{
		public var data:AdData=new AdData();
		
		public function AdDataProxy()
		{
		}
		
		public function init():void{
			DebugTip.instance.log("-----------start load...-------------")
			var lu:LoadUtil=new LoadUtil();
			lu.init();
		}
		
		
	}
}