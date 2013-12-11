package com.bo.tracker
{
	import com.gridsum.VideoTracker.ILiveInfoProvider;
	
	public class LiveInfoProviderImpl implements ILiveInfoProvider
	{
		private var _itemName:String = "";
		private var _bitrate:Number = 450.00;
		private var _bandWidth:Number = 0;
		private var _position:Number=0;
		public function LiveInfoProviderImpl()
		{
		}
		
		public function getItemName():String
		{
			return this._itemName;
		}
		
		public function getBitrate():Number
		{
			return this._bitrate;
		}
		
		public function getFramesPerSecond():Number{
			return 60;
		}
	}
}