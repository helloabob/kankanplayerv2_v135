package com.adChinaModule.adChinaModel
{
	import com.adChinaModule.adChinaModel.proxy.AdDataProxy;
	
	import flash.display.Sprite;
	
	public class AdChinaModel extends Sprite
	{
		private static var _instance:AdChinaModel;
		
		public var adDataProxy:AdDataProxy=new AdDataProxy();
		
		public function AdChinaModel(pClass:pvt)
		{
			
		}
		
		public static function get instance():AdChinaModel
		{
			if (!_instance)
			{
				_instance=new AdChinaModel(new pvt());
			}
			
			return _instance
		}
		
		public function init():void{
			adDataProxy.init();
		}
		
		public function sendTimeAction():void{
			
		}
		
	}
}

class pvt
{
}
