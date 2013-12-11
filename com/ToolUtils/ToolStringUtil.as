package com.ToolUtils
{
	
	public class ToolStringUtil
	{
		
		private static var _instance:ToolStringUtil;
		
		public function ToolStringUtil(pClass:pvt)
		{
			
		}
		
		public static function get instance():ToolStringUtil
		{
			if (!_instance)
			{
				
				_instance=new ToolStringUtil(new pvt());
			}
			
			return _instance
		}
		
		public function getFileNameWithHttpString(str:String):String
		{
			
			var fileName:String=str;
			var index1:int=fileName.lastIndexOf("/");
			var index2:int=fileName.lastIndexOf("?");
			var index3:int=index2==-1?fileName.length:index2 ;
			
			fileName=fileName.substring(index1+1,index3);
			
			return fileName;
		}
		
		public function getHoleNameWithHttpString(str:String):String{
			var fileName:String=str;
			
			var index2:int=fileName.lastIndexOf("?");
			var index3:int=index2==-1?fileName.length:index2 ;
			fileName=fileName.substring(0,index3);
			return fileName;
		}
		
		public function getChannelNameFromString(str:String):String{
			var fileName:String=str;
			var index1:int=fileName.indexOf("/");
			var index2:int=fileName.lastIndexOf("/");
			
			fileName=fileName.substring(index1+1,index2);
			
			return fileName;
		}
	}
}

class pvt
{
}
