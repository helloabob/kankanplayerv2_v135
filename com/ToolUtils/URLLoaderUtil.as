package com.ToolUtils
{
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLoaderUtil extends Sprite
	{
		private static var _instence:URLLoaderUtil;
		private var _UrlLoader:URLLoader;
		private var _urlString:String;
		private var _completeFun:Function
		private var _errorFun:Function
		private var _completeParam:Array=[]
		private var _errorParam:Array=[]
		
		public function URLLoaderUtil(pvt:PvtCls)
		{
		}
		
		public static function get instence():URLLoaderUtil{
			if(!_instence){_instence=new URLLoaderUtil(new PvtCls())};
			
			return _instence;
		}
		
		public function loadURL(str:String,fun1:Function=null,args1:Array=null,fun2:Function=null,args2:Array=null):void{
			
			if(fun1){
				_completeFun=fun1;
				_completeParam=args1;
			}
			if(fun2){
				_errorFun=fun2;
				_errorParam=args2;
			}
			
			
			try
			{
				trace("url start loader!!!")
				_UrlLoader=new URLLoader(new URLRequest(str));
			} 
			catch(error:SecurityError) 
			{
				trace("url load err!!!")
				_urlError(null);
			}
			
			_UrlLoader.addEventListener(Event.COMPLETE,_urlComplete);
			_UrlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_urlError);
			
		}
		
		protected function _urlComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			_completeFun.apply(this,_completeParam);
			trace("file loaded")
			DebugTip.instance.log("file loaded !!");
			
		}
		
		protected function _urlError(event:SecurityErrorEvent):void
		{
			// TODO Auto-generated method stub
			_errorFun.apply(this,_errorParam);
			trace("no file")
			DebugTip.instance.log("no file ,secruity error");
		}		
		
		
	}
}
class PvtCls{}