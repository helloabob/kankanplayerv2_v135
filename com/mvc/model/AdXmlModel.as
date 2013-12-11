package com.mvc.model
{
	import com.bo.events.MyEvent;
	import com.bo.utils.AdXMLParser;
	import com.debugTip.DebugTip;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AdXmlModel
	{



		private var xmlLoader:URLLoader;
		private var xmlData:XML;
		private var adTypeArr:Array=["qiantiepian","dadiguanggao","dibufuceng","zanting","wanzilian","jiaobiao"];
		private var adNodes:Object ={};

		private static var _instance:AdXmlModel;

		public function AdXmlModel(pClass:pvt)
		{

		}

		public static function get instance():AdXmlModel
		{
			if (!_instance)
			{

				_instance=new AdXmlModel(new pvt());
			}

			return _instance
		}

		public function init():void
		{
			loadXml();
		}

		private function loadXml():void
		{
			//load adxml
			//var ts:String="梦之声";
			var url:String="http://kanknim.allyes.com/main/s?user=||kkn_videoplayer&db=kanknim&border=0&local=list&t=124&kv=key|"+encodeURI(Global.videodata.videotitle);
			
			xmlLoader=new URLLoader(new URLRequest(url));
			xmlLoader.addEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader.addEventListener(ErrorEvent.ERROR,xmlLoadError);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,xmlLoadError);
		}

		protected function xmlLoadError(event:Event):void
		{
			xmlLoader.removeEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader.removeEventListener(ErrorEvent.ERROR,xmlLoadError);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,xmlLoadError);

			//senderror
			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.ADXMLERROR));
		}

		protected function xmlLoadComplete(event:Event):void
		{
			xmlLoader.removeEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader.removeEventListener(ErrorEvent.ERROR,xmlLoadError);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,xmlLoadError);

			xmlData=new XML(xmlLoader.data);
			parserData(xmlData);
			AdXMLParser.parseAdXML(xmlData);
			//sendcomplete
			Global.notificationCenter.postEvent(new MyEvent(MyEvent.POSTEVENT,MyEvent.ADXMLCOMPLETE));
		}


		private function parserData(xml:XML):void
		{
			var adName:String;
			//解析5种类型的广告
			for (var i:int=0;i < xml.children().length();i++)
			{
				adName=getTypeByNodeName(xml.children()[i].@name);
				DebugTip.instance.log("have ad!:"+adName)
				switch (adName)
				{
					case adTypeArr[0]:
					{
						adNodes[adTypeArr[0]]=xml.children()[i];
						DebugTip.instance.log("THE QIAN TIEAD THIS TIME:"+adNodes[adTypeArr[0]].custom.t.toString());
						break;
					}
					case adTypeArr[1]:
					{
						adNodes[adTypeArr[1]]=xml.children()[i];
						break;
					}
					case adTypeArr[2]:
					{
						adNodes[adTypeArr[2]]=xml.children()[i];
						break;
					}
					case adTypeArr[3]:
					{
						adNodes[adTypeArr[3]]=xml.children()[i];
						break;
					}
					case adTypeArr[4]:
					{
						adNodes[adTypeArr[4]]=xml.children()[i];
						break;
					}
					case adTypeArr[5]:
					{
						adNodes[adTypeArr[5]]=xml.children()[i];
						break;
					}
					default:
					{
						break;
					}
				}
			}
		}

		private function getTypeByNodeName(name:String):String
		{
			var str:String="";
			for (var i:int=0;i < adTypeArr.length;i++)
			{
				if (name.indexOf(adTypeArr[i]) > 0)
				{
					//trace(name,adTypeArr[i]);
					str=adTypeArr[i];
					break;
				}

			}
			return str;
		}

		public function get getFrontAdList():XMLList
		{
			var list:XMLList=new XMLList(adNodes["qiantiepian"]);
			return list;
		}

		public function get getFrontButtomList():XMLList
		{
			var list:XMLList=new XMLList(adNodes["dadiguanggao"]);
			return list;
		}

		public function get getButtomFloatAdlist():XMLList
		{
			var list:XMLList=new XMLList(adNodes["dibufuceng"]);
			return list;
		}

		public function get getPauseAdList():XMLList
		{
			var list:XMLList=new XMLList(adNodes["zanting"]);
			return list;
		}

		public function get getTextAdList():XMLList
		{
			var list:XMLList=new XMLList(adNodes["wanzilian"]);
			return list;
		}

		public function get getCornerAdList():XMLList
		{
			var list:XMLList=new XMLList(adNodes["jiaobiao"]);
			return list;
		}

		public function dispose():void
		{
			xmlLoader.close();
			xmlLoader.removeEventListener(Event.COMPLETE,xmlLoadComplete);
			xmlLoader=null;
			xmlData=null;
		}
	}
}

class pvt
{
}
