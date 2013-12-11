package com.bo.utils
{
	import com.checkDns.CustomSocket;
	import com.debugTip.DebugTip;
	import com.mvc.model.AdXmlModel;

	public class XMLParser
	{
		public function XMLParser()
		{
			// constructor code
		}

		public static function parseAdXML(xml:XML):void
		{
			Global.adParameter.adxml=xml;
			//trace(xml);
			
			if (AdXmlModel.instance.getFrontAdList.t.toString() != "non")
			{
				
				Global.adParameter.hasPreAd=true;
				Global.adParameter.preAdLink=AdXmlModel.instance.getFrontAdList.sc.toString();
			}
			if (AdXmlModel.instance.getPauseAdList.t.toString() != "non")
			{
				Global.adParameter.hasPauseAd=true;
				Global.adParameter.pauseAdLink=AdXmlModel.instance.getPauseAdList.sc.toString();
				if (AdXmlModel.instance.getPauseAdList.t.toString() == "google")
				{
					Global.adParameter.pauseAdType=1;
				}
			}
			
			/*end ad
			if (xml.chan[9].t.toString() != "non")
			{
				Global.adParameter.hasEndAd=true;
			}
			*/
			
			DebugTip.instance.log(AdXmlModel.instance.getTextAdList.t + "||||adxml wzl||||" + AdXmlModel.instance.getTextAdList.texttitle.toString())
			try
			{
				if (AdXmlModel.instance.getTextAdList.t && AdXmlModel.instance.getTextAdList.t.toString() == "wenzilian")
				{

					Global.adParameter.hasTextAd=true;
					var tmp:XMLList   =AdXmlModel.instance.getTextAdList;
					var txt:String=tmp.texttitle;
					var cc:String =tmp.cc;
					var sc:String =tmp.sc;
					var c:String  =tmp.parts.part.c;
					
					if (txt != "")
					{
						Global.adParameter.TextAdArray=new Array();
						var obj1:Object=new Object();
						obj1.sc=sc;
						obj1.sec=tmp.parts.part.sec;
						Global.adParameter.TextAdArray[0]=obj1;
						var count:int  =txt.split("||").length;
						for (var k:int=0;k < count;k++)
						{
							var obj:Object=new Object();
							obj.text=txt.split("||")[k];
							obj.link=c.split("||")[k];
							obj.sta=cc + c.split("||")[k];
							Global.adParameter.TextAdArray.push(obj);
						}
					}

				}
			}
			catch (err:Error)
			{

			}
			
			//计算底部广告数量
			Global.adParameter.bottomAdCount=0;
			for (var i:int=0;i < 3;i++)
			{
				if (xml.chan[i + 1].t != "non")
				{
					if (xml.chan[i + 1].t == "google")
					{
						Global.adParameter.overlayAdType=1;
						Global.adParameter.overlayAdLink=xml.chan[i + 1].sc;
					}
					Global.adParameter.hasOverlayAd=true;
					Global.adParameter.bottomAdCount++;
				}
			}
			//Global.adParameter.adstarttime=7;
		}

		public static function parseOMSXML(xml:XML):void
		{
			
			if (Global.playerparameter.islive == "false")
			{
				trace("socket to:"+xml.video.videourl);
				var ts:String=xml.video.videourl;
				var cs:CustomSocket=new CustomSocket();
				DebugTip.instance.log("--------xml cs-"+ts+"-------------");
				cs.startConnect(ts);
				Global.videodata.videourl=xml.video.videourl;
			}
			//Global.videodata.videourl="http://video6.smgbb.cn/rendition/201205/88000/ef/77947493144331265/77947496097136129/r77947496097136129-800k-640x360.mp4";
		}

		public static function parseXML(xml:XML):void
		{
			//trace("parseXML:"+xml);
			if (Global.playerparameter.islive == "true")
			{
				Global.videodata.videourl="rtmp://live.kksmg.com/live/mp4:Stream_1";
				Global.videodata.colname=xml.column;
				Global.videodata.relation=new Array();
				/*for each(var node:XML in xml.videolist.video){
					var obj:Object=new Object();
					obj.title=node.title;
					obj.link=node.link;
					obj.imageurl=node.imgurl;
					Global.videodata.relation.push(obj);
				}*/
			}
			else
			{
				//if(Global.videodata.videourl=="")Global.videodata.videourl=getVideoUrl(xml.filename);
				if (Global.playerparameter.islive != "true")
					Global.videodata.videourl=getVideoUrl(xml.filename);
				if (xml.omsid == undefined || xml.omsid.toString() == "" || xml.omsid.toString() == "0")
				{
				}
				else
					Global.omsid=xml.omsid.toString();
				trace("xmlparser_omsid:" + Global.omsid);
				Global.videodata.host=xml.host;
				Global.videodata.relation=new Array();
				Global.videodata.colname=xml.column;
				Global.videodata.videotitle=xml.title;
				Global.videodata.imageurl=xml.imgurl;
				var tid:String=Global.xmlid;
				Global.videodata.cmsid=tid.substr(tid.lastIndexOf("/") + 1);
				for each (var node:XML in xml.videolist.video)
				{
					var obj:Object=new Object();
					obj.title=node.title;
					obj.link=node.link;
					obj.imageurl=node.imgurl;
					Global.videodata.relation.push(obj);
				}
			}
			trace('vxml_parse_xml');
		}

		public static function getVideoUrl(url_temp:String):String
		{
			var url:String="";
			if (url_temp.indexOf("http://") >= 0)
			{
				url=url_temp;
			}
			else
			{
				if (Global.protocolType == "rtmp")
				{
					url="rtmp://sports.kksmg.com:80/vod/mp4:" + url_temp; //RTMP路线
				}
				else
				{
					var tmp:String =Global.videodata.host;
					tmp=tmp.substring(tmp.indexOf("//") + 2,tmp.indexOf("."));
					var tmp2:String="";
					if (tmp == "world")
					{
						tmp2="world";
					}
					else if (tmp == "finance")
					{
						tmp2="fin";
					}
					else if (tmp == "sports")
					{
						tmp2="sport";
					}
					else if (tmp == "society")
					{
						tmp2="soc";
					}
					else if (tmp == "ent")
					{
						tmp2="ent";
					}
					else if (tmp == "ipai")
					{
						tmp2="ipai";
					}
					else
					{
						tmp2="dom";
					}
					url="http://" + tmp2 + "http.kksmg.com" + url_temp;
						//Security.loadPolicyFile("http://"+tmp2+"http.kksmg.com/crossdomain.xml");
				}
			}
			trace(url);
			return url;
		}

	}

}
