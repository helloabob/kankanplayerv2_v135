package com.bo.utils {
	
	public class AdParameter {
		public var hasPreAd:Boolean=false;
		public var preAdLink:String="";  //前贴广告统计代码地址
		public var hasPauseAd:Boolean=false;
		public var pauseAdType:int=0;  //暂停广告类型 0好耶  1google 2易传媒
		public var pauseAdLink:String="";  //广告显示统计代码地址
		public var hasOverlayAd:Boolean=false;
		public var overlayAdType:int=0;  //浮层广告类型 0好耶  1google  2易传媒
		public var overlayAdLink:String="";
		public var hasEndAd:Boolean=false;
		public var bottomAdCount:int=0;
		
		public var hasTextAd:Boolean=false;
		public var TextAdArray:Array;
		
		public var adxml:XML;
		public var adstarttime:int=10;
		//public var adchinaid:String="71026";
		public var adchinaid:String="71174";
		
		public function AdParameter() {
			// constructor code
		}
	}
}
