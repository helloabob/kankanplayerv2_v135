package com.bo.events
{
	import flash.events.Event;
	
	public class AdEvent extends Event
	{
		public static const REQUESTCOMPLETE:String="requestComplete";
		public static const PLAYCOMPLETE:String="playComplete";
		public static const ADNOTICE:String="AdNotice";
		
		public var adParam:Object={};
		public function AdEvent(type:String,param:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			adParam=param;
			super(type, bubbles, cancelable);
		}
	}
}