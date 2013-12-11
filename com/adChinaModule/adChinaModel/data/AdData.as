package com.adChinaModule.adChinaModel.data
{
	import com.adChinaModule.AdChinaMoudle;
	import com.adChinaModule.adChinaEvent.AdChinaEvent;

	public class AdData
	{
		public var isPreAdPlayed:Boolean=false;	
		public var isPreAdLded:Boolean=false;
		
		private static var _instance:AdData;
		
		public function AdData()
		{
		}
		
		private var _adContent:*;
		
		public function set adContent(value:*):void
		{
			_adContent = value;
			AdChinaMoudle.instance.dispatchEvent(new AdChinaEvent(AdChinaEvent.ADLOADCOMPLETE));
		}

		public function get adContent():*
		{
			return _adContent;
		}
		
		
		
	}
}
class pvt{}