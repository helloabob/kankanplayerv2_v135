﻿package com.bo.elements{	import com.bo.net.Address;		import flash.events.MouseEvent;	import flash.net.URLRequest;	import flash.net.navigateToURL;	import flash.system.System;	import com.bo.events.MyEvent;	public class MySharePanel extends sharePanel{		private var _title:String=Global.videodata.videotitle;		//private var _htmlAddress:String=ExternalInterface.call("location.href.toString");		//private var _url:String=ExternalInterface.call("location.href.toString");		//private var _url:String=Address.SHAREHTML+Global._cid+"/"+Global._vid+"/";		//private var _url:String=ExternalInterface.call("location.href.toString");		//private var _url:String=Address.SHAREFLASH+"?id="+Global._id;		private var _url:String=Global.videodata.host;		private var _imgurl:String=Global.videodata.imageurl;		public function MySharePanel(){			init();		}		private function init():void{			if(Global.playerparameter.islive=="true"){				//renren.visible=false;				//kaixin.visible=false;				txtHtml.text='<embed id="player1" name="player1" src="http://video1.kksmg.com/experience/bootstrap.swf?publisherId=88000" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="opaque" width="600" height="482"	flashvars="playerId=84863534562803713&apiDomain=api.video.smgbb.cn"></embed>';				txtFlash.text='http://video1.kksmg.com/experience/bootstrap.swf?publisherId=88000&playerId=84863534562803713&apiDomain=api.video.smgbb.cn';			}else{				txtFlash.text=Address.SHAREFLASH+"?id="+Global.xmlid;				txtHtml.text='<embed src="'+txtFlash.text+'" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="opaque" width="480" height="400"></embed>';			}			btnClose.buttonMode=true;			btnClose.addEventListener(MouseEvent.CLICK,onClose);			btnHtml.buttonMode=true;			btnHtml.addEventListener(MouseEvent.CLICK,onHtml);			btnFlash.buttonMode=true;			btnFlash.addEventListener(MouseEvent.CLICK,onFlash);			sina.buttonMode=true;			sina.addEventListener(MouseEvent.CLICK,onSina);			renren.buttonMode=true;			renren.addEventListener(MouseEvent.CLICK,onRenRen);			kaixin.buttonMode=true;			kaixin.addEventListener(MouseEvent.CLICK,onKaiXin);			qzone.buttonMode=true;			qzone.addEventListener(MouseEvent.CLICK,onQzone);						//douban.buttonMode=true;			//douban.addEventListener(MouseEvent.CLICK,onDouBan);			//txtFlash.text="http://www.kankanews.com/object/wulinplayer.swf?cid="+Global._cid+"&vid="+Global._vid;			//txtFlash.text=Address.SHAREFLASH+"wulinplayer.swf?cid="+Global._cid+"&vid="+Global._vid;			//txtHtml.text='<embed src="http://www.kankanews.com/object/wulinplayer.swf?cid='+Global._cid+'&vid='+Global._vid+' type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="opaque" width="480" height="400"></embed>';			//txtHtml.text='<embed src="'+Address.SHAREFLASH+'wulinplayer.swf?cid='+Global._cid+'&vid='+Global._vid+' type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="opaque" width="480" height="400"></embed>';			//txtFlash.text="http://wulin.smgbb.cn/object/wulinplayer.swf?cid="+Global._cid+"&vid="+Global._vid;		}		private function onQzone(evt:MouseEvent):void{			//var url:String="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url="+_url;			var url:String="http://v.t.qq.com/share/share.php?url="+_url+"&appkey=&site=http://www.smgbb.cn&pic="+Global.videodata.imageurl+"&title="+Global.videodata.videotitle;			navigateToURL(new URLRequest(url),"_blank");		}		/*private function onDouBan(evt:MouseEvent):void{			var url:String="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url="+_url;			navigateToURL(new URLRequest(url),"_blank");		}		*/		private function onKaiXin(evt:MouseEvent):void{			//window.open('http://www.kaixin001.com/repaste/share.php?rtitle='+title+'&rcontent='+title+'&rurl='+url,'_blank');			var appkey:String="2579900422";			var videourl:String=_title;			var rid:String="1168434852";			var title:String=_title;			var img:String=_imgurl;			//var url:String="http://www.kaixin001.com/repaste/share.php?rurl="+videourl+"&rcontent="+videourl+"&rtitle="+title;			var url:String="http://www.kaixin001.com/repaste/share.php?rtitle="+_title+"&rcontent="+_title+"&rurl="+_url;			navigateToURL(new URLRequest(url),"_blank");		}		private function onRenRen(evt:MouseEvent):void{			//window.open('http://www.connect.renren.com/share/sharer?url='+url+'&title='+title,'_blank');			var appkey:String="2579900422";			var videourl:String=_title;			var rid:String="1168434852";			var title:String=_title;			var img:String=_imgurl;			var url:String="http://www.connect.renren.com/share/sharer?url="+_url+'&title='+_title;			//var url:String="http://share.renren.com/share/buttonshare.do?link="+videourl+"&title="+title+"&image_src="+img;			navigateToURL(new URLRequest(url),"_blank");		}		private function onSina(evt:MouseEvent):void{			//window.open("http://v.t.sina.com.cn/share/share.php?url="+url+"&appkey=2776330571&title="+title+"&pic=","_blank","width=615,height=505");			var appkey:String=Global._appkey;			var videourl:String=_title;			var rid:String="1845864154";			var title:String=_title;			var img:String=_imgurl;			var url:String="http://service.t.sina.com.cn/share/share.php?appkey="+appkey+"&url="+_url+"&ralateUid="+rid+"&title="+_title+"&pic="+img+"&retcode=0";			navigateToURL(new URLRequest(url),"_blank");		}		private function onHtml(evt:MouseEvent):void{			System.setClipboard(txtHtml.text);		}		private function onFlash(evt:MouseEvent):void{			System.setClipboard(txtFlash.text);		}		private function onClose(evt:MouseEvent):void{			//if(Global.main.contains(this)){				//Global.main.removeChild(this);			//}			dispatchEvent(new MyEvent(MyEvent.COMP,"1"));		}		public function show():void{			if(!Global.main.contains(this)){				x=Global.appWidth/2-width/2;				y=(Global.appHeight-32)/2-height/2;				Global.main.addChild(this);				}			else Global.main.removeChild(this);			}		public function repostion():void{			x=Global.appWidth/2-width/2;			y=(Global.appHeight-32)/2-height/2;		}	}}