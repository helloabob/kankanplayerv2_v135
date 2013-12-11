package com.adChinaModule.adChinaEvent
{
	import flash.events.Event;
	
	public class AdChinaEvent extends Event
	{
		public static const TIMEACTION:String="adChinaEvent.timeAction";
		public static const ADLOADCOMPLETE:String="adChinaEvent.adLoadComplete";
		public static const HIDEPAUSEAD:String="adChinaEvent.hidePauseAd";
		public static const SHOWPAUSEAD:String="adChinaEvent.showPauseAd";
		public static const FULLSCREEN:String="adChinaEvent.fullScreen";
		public static const NORMALSCREEN:String="adChnaEvent.NormalScreen";
		public static const SHOWENDAD:String="adChinaEvent.ShowEndAd"; 
		
		public var params:Object={};
		
		
		
		public function AdChinaEvent(type:String,params:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.params=params;
			super(type, bubbles, cancelable);
		}
	}
}