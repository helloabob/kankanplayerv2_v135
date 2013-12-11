package com.checkDns
{
	import com.debugTip.DebugTip;
	
	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;
	
	public class CustomSocket extends Socket {
		private var response:String;
		private var host:String
		private var port:uint
		private var tail:String;
		
		public function CustomSocket() {
			super();
			configureListeners();
			
		}
		
		public function startConnect(url:String = null, port:uint = 80):void{
			var endPos:int=url.indexOf("/",7);
			host=url.substring(url.indexOf("http://")+7,endPos);
			tail=url.substr(endPos+1);	
			DebugTip.instance.log("host:"+host+"tail:"+tail);
			DebugTip.instance.log("--------url:"+url+"--------");
			DebugTip.instance.log("--------host:"+host+"--------");
			if (host && port)  {
				this.host=host;
				this.port=port;
				super.connect(host, port);
			}
		}
		
		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function writeln(str:String):void {
			//str += "\r\n";
			//trace(str,"\n -----------------------");
			try {
				writeUTFBytes(str);
				//trace(str)
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		private function sendRequest():void {
			//2013/08/31/h264_450k_mp4_e24439e750f776acbf20bc412d6b7674_ncd.mp4
			trace("sendRequest");
			var header:String = "GET /"+tail+" HTTP/1.1\r\n";
			header += "Host: "+ host+"\r\n";
			header += "Connection: keep-alive\r\n";
			header += "Cache-Control: no-cache\r\n";
			header += "Pragma: no-cache\r\n";
			//header += "Referer: http://domhttp.kksmg.com/2013/09/01/h264_450k_mp4_CCTVNEWS1500000201309013621385054_aac.mp4?start=0\r\n";
			header += "Accept: */*;q=0.8\r\n";
			header += "User-Agent: Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.1 (KHTML, like Gecko) Maxthon/4.1.2.3000 Chrome/26.0.1410.43 Safari/537.1\r\n";
			header += "DNT: 1\r\n";
			header += "Accept-Encoding: gzip,deflate\r\n";
			header += "Accept-Language: zh-CN\r\n";
			header += "Range: bytes=0-\r\n";
			header += "Accept-Charset: GBK,utf-8;q=0.7,*;q=0.3\r\n\r\n";
			
			writeln(header);
			flush();
			
			DebugTip.instance.log("--------sendRequest--------");
		}
		
		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			response = str;
			//trace(response.indexOf("Location"));
			if(response.indexOf("Location")!=-1){
				this.close();
				var urlStartPos:int= response.indexOf("Location");
				var urlEndPos:int= response.indexOf("\r\n",urlStartPos)
				var urlInfo:String=response.substring(urlStartPos,urlEndPos)
				urlInfo=urlInfo.substr(urlInfo.indexOf("http://"));
				var urlHost:String=urlInfo.substring(7,urlInfo.indexOf("/",7));
				DebugTip.instance.log("------|relocation:"+urlHost+"------")	//,"loaction:",urlInfo
					
				startConnect(urlInfo,80);
				
			}else{
				getCdn();
			}
		}
		
		private function getCdn():void{
		
//			trace("==============\n",response,"\n ==============");
			var cdnPos:int=response.indexOf("\r\nVia");
			var cdnInfo:String=response.substr(cdnPos);
			var cdnInfoEndPos:int=cdnInfo.indexOf("\r\n",3);
			//trace("||",cdnInfoEndPos,"||")
			cdnInfo=cdnInfo.substring(6,cdnInfoEndPos);
			DebugTip.instance.log("------Cdn:"+cdnInfo+"---");
			response="";
			Global.videodata.cdn=cdnInfo;
			Global.tracker.trySetTrackAgain();
			this.close();
		}
		
		private function parseLocation(url:String):void{
			
		}
		
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			//trace(response.toString());
		}
		
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			sendRequest();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			trace("socketDataHandler: " + event);
			readResponse();
			//this.close();
		}
	}
}