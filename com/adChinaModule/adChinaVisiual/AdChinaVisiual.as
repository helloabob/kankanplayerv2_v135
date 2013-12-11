package com.adChinaModule.adChinaVisiual
{
	import com.adChinaModule.adChinaVisiual.mediator.AdPanelMediator;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class AdChinaVisiual extends Sprite
	{
		private static var _instance:AdChinaVisiual;
		
		public var st:Stage;
		public var adPanel:AdPanelMediator=new AdPanelMediator();
		
		public function AdChinaVisiual(pClass:pvt)
		{
			
		}
		
		public static function get instance():AdChinaVisiual
		{
			if (!_instance)
			{
				_instance=new AdChinaVisiual(new pvt());
			}
			
			return _instance
		}
		
		public function init(st:Stage):void{
			this.st=st;
			st.addChild(adPanel.view);
		}
		
		
		
	}
}

class pvt
{
}
