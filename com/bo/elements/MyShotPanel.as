package com.bo.elements
{
	//import com.adobe.images.JPGEncoder;
	//import com.adobe.images.PNGEncoder;
	//import com.bo.ad.display.CloseButton;
	//import com.bo.events.MyEvent;
	//import com.bo.utils.Constants;
	//import com.adobe.crypto.SHA1;
	import com.bo.Addons.PNGEncoder;
	import com.bo.events.MyEvent;
	import com.debugTip.DebugTip;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class MyShotPanel extends ShotPanel
	{
		public var panel:Sprite;
		public var bmd:BitmapData;
		public var bar:MovieClip;
		public var listpanel:MovieClip;
		private var _mb:MicroBlog;
		private var _IsLogin:Boolean;
		private var alert:Sprite;
		private var t:TextField;
		private var tf:TextFormat;
		private var btnSave:MyRedButton;
		private var btnLogin:MyRedButton;
		private var sina:MyRedButton;
		//private var buffering:BufferMC=new BufferMC();
		private var bufferShape:Shape=new Shape();
		private var bufferTxt:TextField=new TextField();
		private var myLoadingSprite:MyLoadingSprite=new MyLoadingSprite();
		private var txt:TextField=new TextField();
		public function MyShotPanel(){
			tf=new TextFormat();
			tf.color=0xffffff;
			
			try{
				bmd=new BitmapData(Global.appWidth,Global.appHeight-32);			
				bmd.draw(Global.mps);
				var bm:Bitmap=new Bitmap(bmd);
				bm.y=1;
				bm.x=1;
				pic.addChild(bm);
				
				
				btnClose.buttonMode=true;
				
				sina=new MyRedButton();
				sina.Title="分享";
				sina.buttonMode=true;
				sina.visible=false;
				sina.x=width-sina.width-20;
				sina.y=height-sina.height-10;
				
				addChild(sina);
				
				btnLogin=new MyRedButton();
				btnLogin.Title="登录";
				btnLogin.buttonMode=true;
				//btnLogin.visible=false;
				btnLogin.x=width-sina.width-20;
				btnLogin.y=height-sina.height-10;
				
				addChild(btnLogin);
				
				btnSave=new MyRedButton();
				btnSave.Title="保存";
				
				btnSave.buttonMode=true;
				btnSave.x=sina.x-btnSave.width-10;
				btnSave.y=height-btnSave.height-10;
				addChild(btnSave);
				
				//var str:String=ExternalInterface.call("document.title.toString");
				
				//txtContent.text="播放器截图功能测试："+str+"（来自 @看看新闻网 视频截图 "+getDateString()+" 发布）";			
				txtContent.text=Global.videodata.videotitle;
				if(txtContent.text==""){
					txtContent.text="看看新闻网正在直播精彩内容";
				}
				checkLoginSina();
				registerEventListener();
				
			}catch(err:Error){
				//ExternalInterface.call("alert",err.toString()+err.message+err.name);
				//bmd=new BitmapData(100,100);
				DebugTip.instance.log("shotPicture:"+err.message);
				//flash.external.ExternalInterface.call("alert",err.message);
				txt.text="截图功能发生故障，我们会尽快解决。";
				txt.width=260;
				txt.defaultTextFormat=tf;
				txt.setTextFormat(tf);
				txt.x=Global.appWidth/2-txt.width/2;
				txt.y=(Global.appHeight-32)/2-txt.height/2;
				txt.selectable=false;
				this.visible=false;
				if(!Global.main.contains(txt))Global.main.addChild(txt);
				
				setTimeout(onTimeOut,1000);
			}
			
			
			
			
			//myLoadingSprite.show();
			
		}
		private function registerEventListener():void{
			btnClose.addEventListener(MouseEvent.CLICK,onClick);
			sina.addEventListener(MouseEvent.CLICK,onSina);
			btnLogin.addEventListener(MouseEvent.CLICK,onLoginValidate);
			btnSave.addEventListener(MouseEvent.CLICK,onSave);
		}
		private function disposeEventListener():void{
			btnClose.removeEventListener(MouseEvent.CLICK,onClick);
			sina.removeEventListener(MouseEvent.CLICK,onSina);
			btnLogin.removeEventListener(MouseEvent.CLICK,onLoginValidate);
			btnSave.removeEventListener(MouseEvent.CLICK,onSave);	
		}
		private function destroy():void{
			if(_mb){
				//if(_mb.hasEventListener(MicroBlogEvent.ANYWHERE_TOKEN_RESULT))_mb.removeEventListener(MicroBlogEvent.ANYWHERE_TOKEN_RESULT,onAnyWhereResult);
				//if(_mb.hasEventListener(MicroBlogErrorEvent.ANYWHERE_TOKEN_ERROR))_mb.removeEventListener(MicroBlogErrorEvent.ANYWHERE_TOKEN_ERROR,onAnyWhereError);
				if(_mb.hasEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT)){
					_mb.removeEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT,onStatusResult);
				}
				if(_mb.hasEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR)){
					_mb.removeEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR,onStatusError);
				}
				if(_mb.hasEventListener(MicroBlogEvent.LOGIN_RESULT)){
					_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT,onLoginResult);
				}
			}
			disposeEventListener();
		}
		private function checkLoginSina():void{
			if(!_mb){
				_mb=new MicroBlog();
				//_mb.debugMode=true;
				//_mb.isTrustDomain=true;
				_mb.consumerKey="2579900422";
				_mb.consumerSecret="60b81157b9a9f41e32f87328391bb3e2";
				_mb.proxyURI="http://kankanews.sinaapp.com/interface/sina/proxy.php";
				
				//_mb.addEventListener(MicroBlogEvent.ANYWHERE_TOKEN_RESULT,onAnyWhereResult);
				//_mb.addEventListener(MicroBlogErrorEvent.ANYWHERE_TOKEN_ERROR,onAnyWhereError);
				//_mb.source="786817078";   //东方宽频
				//_mb.source=Global._appkey;  //看看新闻网
			}
		}
		private function onAnyWhereResult(evt:MicroBlogEvent):void{
			trace("onAnyWhereResult");
			sina.visible=true;
			btnLogin.visible=false;
			_IsLogin=true;
			//onSina(null);
		}
		private function onAnyWhereError(evt:MicroBlogErrorEvent):void{
			trace("onAndyWhereError");
			//initAlert();
			/*if(!this.contains(alert)){				
				this.addChild(alert);
			}*/
			//t.text="点击登录";
			
			/*alert.buttonMode=true;
			alert.mouseEnabled=true;
			*/
			sina.visible=false;
			btnLogin.visible=true;
			_IsLogin=false;
			onLoginValidate(null);
		}
		private function onSina(evt:MouseEvent):void{
			trace("onSina");
			if(_IsLogin){
				trace("onSina1");
				var byteArray:ByteArray=PNGEncoder.encode(bmd);
				//var title:String=ExternalInterface.call("document.title.toString");
				var title:String=Global.videodata.videotitle;
				//title=encodeURI(title);
				if(!_mb.hasEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT)){
					_mb.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT,onStatusResult);
				}
				if(!_mb.hasEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR)){
					_mb.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR,onStatusError);
				}
				trace("start to update");
				//sina.Title="分享中";
				//showAlert("分享中");
				myLoadingSprite.show();
				this.visible=false;
				//var url5:String=ExternalInterface.call("location.href.toString");
				var sharedContent:String=txtContent.text+" "+Global.videodata.host+"（来自 @看看新闻网 视频截图 "+getDateString()+" 发布）";
				//_mb.updateStatus(sharedContent,"shot.png",byteArray);
				_mb.updateStatus(sharedContent,byteArray,"shot.png");
				
				setTimeout(shareTimeout,3000);
				
			}
		}
		
		private function shareTimeout():void{
			myLoadingSprite.setTitle("分享成功");
			setTimeout(hideAlert,3000);
		}
		
		private function getDateString():String{
			var dt:Date=new Date();
			var yr:String = dt.getFullYear().toString();
			var mth:String = addZero(dt.getMonth()+1);
			var day:String=addZero(dt.getDate());
			var hour:String=addZero(dt.getHours());
			var min:String=addZero(dt.getMinutes());
			var sec:String=addZero(dt.getSeconds());
			return yr+"-"+mth+"-"+day+" "+hour+":"+min+":"+sec+"";
			//return dt.getFullYear().toString()+dt.getMonth().toString()+dt.getDate().toString()+dt.getHours().toString()+dt.getMinutes().toString()+dt.getSeconds().toString();
		}
		private function onTimeOut():void{
			if(Global.main.contains(txt))Global.main.removeChild(txt);
			dispatchEvent(new MyEvent(MyEvent.COMP,"1"));
		}
		private function addZero(_src:int):String{
			if(_src<10){
				return "0"+_src;
			}else{
				return String(_src);
			}
		}
		private function initAlert():void{
			if(alert==null){
				alert=new Sprite();
				alert.graphics.beginFill(0x000000,0.9);
				alert.graphics.drawRoundRect(0,0,100,30,10,10);
				alert.graphics.endFill();
				t=new TextField();
				t.text="分享成功";
				
				t.setTextFormat(tf);
				t.selectable=false;
				t.defaultTextFormat=tf;
				t.x=25;
				t.y=5;
				alert.addChild(t);
				var sp:Sprite=new Sprite();
				sp.graphics.beginFill(0x000000,0);
				sp.graphics.drawRoundRect(0,0,100,30,10,10);
				sp.graphics.endFill();
				sp.addEventListener(MouseEvent.CLICK,onLoginValidate);
				sp.buttonMode=true;
				alert.addChild(sp);
				alert.x=Global.appWidth/2-alert.width/2;
				alert.y=(Global.appHeight-32)/2-alert.height/2;
				//alert.buttonMode=true;
				//alert.x=200;
				//alert.y=130;
			}
		}
		
		private function onLoginResult(evt:MicroBlogEvent):void{
			trace("successfully login");
			//t.text="验证成功";
			sina.visible=true;
			btnLogin.visible=false;
			_IsLogin=true;			
			if(_mb.hasEventListener(MicroBlogEvent.LOGIN_RESULT)){
				_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT,onLoginResult);
			}
			//ExternalInterface.call("alert",evt.result["access_token"]+"::"+evt.result["expires_in"]+"::"+evt.result["refresh_token"]);
			trace(evt.result["access_token"]+"::"+evt.result["expires_in"]+"::"+evt.result["refresh_token"]);
			/*var timer2:Timer=new Timer(1000,1);
			timer2.addEventListener(TimerEvent.TIMER,onTimer);
			timer2.start();*/
			/*if(alert.hasEventListener(MouseEvent.CLICK)){
				alert.removeEventListener(MouseEvent.CLICK,onLoginValidate);
			}*/
			
			//_mb.loadFriendsTimeline();
			//var dd:JPGEncoder
			
			
		}
		private function onLoginValidate(evt:MouseEvent):void{
			trace("start to login");
			_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT,onLoginResult);
			_mb.addEventListener(MicroBlogErrorEvent.LOGIN_ERROR,onLoginError);
			_mb.login();
		}
		private function onLoginError(evt:MicroBlogErrorEvent):void{
			ExternalInterface.call("alert",evt.message);
		}
		private function onStatusResult(evt:MicroBlogEvent):void{
			trace("succeed");
			//flash.external.ExternalInterface.call("alert","share_success");
			myLoadingSprite.setTitle("分享成功");
			//setAlertText("分享成功");
			setTimeout(hideAlert,3000);
			//ExternalInterface.call("show","succeed");
			//t.text="分享成功";
			//this.addChild(alert);
			/*var timer:Timer=new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();*/
			//sina.Title="成功";
			
		}
		private function onStatusError(evt:MicroBlogErrorEvent):void{
			trace("fail");
			flash.external.ExternalInterface.call("alert","share_failed");
			//setAlertText("分享失败");
			myLoadingSprite.setTitle("分享失败");
			setTimeout(hideAlert,3000);
			//sina.Title="失败";
			//ExternalInterface.call("show","fail");
			//	trace(evt.code);
			
		}
		private function onButtonRestore():void{
			sina.Title="发布";
		}		
		private function onSave(evt:MouseEvent):void{
			var file:FileReference=new FileReference();
			var ba:ByteArray=PNGEncoder.encode(bmd);
			file.save(ba,"看看新闻网截图.png");
		}
		private function onBack(evt:MouseEvent):void{
			destroy();
			dispatchEvent(new MyEvent(MyEvent.COMP,"1"));
		}
		private function onClick(evt:MouseEvent):void{
			destroy();
			dispatchEvent(new MyEvent(MyEvent.COMP,"1"));
		}
		
		private function showLoading():void{
			//myLoadingSprite.show();
		}
		
		private function showAlert(src:String):void{
			bufferShape=new Shape();
			bufferShape.graphics.beginFill(0x666666,1);
			bufferShape.graphics.drawRect(0,0,Global.appWidth,Global.appHeight-32);
			bufferShape.graphics.endFill();
			addChild(bufferShape);
			//buffering=new BufferMC();
			//buffering.x=Global.APPWIDTH/2-buffering.width/2;
			//buffering.y=Global.VIDEOHEIGHT/2-buffering.height/2-70;
			//addChild(buffering);
			var bx:int=Global.appWidth/2-32;
			var by:int=(Global.appHeight-32)/2-32;
			
			bufferTxt=new TextField();
			tf=new TextFormat();
			tf.color=0xffffff;
			tf.size=22;
			bufferTxt.defaultTextFormat=tf;
			bufferTxt.setTextFormat(tf);
			bufferTxt.text=src;
			bufferTxt.selectable=false;
			bufferTxt.x=bx-2;
			bufferTxt.y=by+80;
			//bufferTxt.x=buffering.x-2;
			//bufferTxt.y=buffering.y+80;
			addChild(bufferTxt);
		}
		private function setAlertText(src:String):void{
			bufferTxt.text=src;
		}
		private function hideAlert():void{
			/*removeChild(bufferShape);
			bufferShape=null;
			removeChild(buffering);
			buffering=null;
			removeChild(bufferTxt);
			bufferTxt=null;*/
			myLoadingSprite.hide();
			onClick(null);
			//this.visible=;
		}
	}
}