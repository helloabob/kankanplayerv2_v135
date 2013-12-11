﻿package com.bo.elements.v2 {	import flash.display.Sprite;	import flash.net.URLLoader;	import flash.events.Event;	import flash.net.URLRequest;	import flash.display.Loader;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.display.SimpleButton;	import flash.events.MouseEvent;	import flash.net.navigateToURL;	public class EndPanel2 extends Sprite{		private var urlld:URLLoader;		private var xml:XML;		private var ld:Loader;		private var tf:TextFormat=new TextFormat();		private var cur:int=0;		private var arr:Array=new Array();		public function EndPanel2(){			// constructor code					}		public function init():void{			graphics.clear();			graphics.beginFill(0x000000,1);			graphics.drawRect(0,0,600,450);			graphics.endFill();						urlld=new URLLoader();			urlld.addEventListener(Event.COMPLETE,onxmlcomp);			urlld.load(new URLRequest("http://interface.kankanews.com/kkapi/baidu/app_recommendVideo.php"));		}		private function onxmlcomp(evt:Event):void{			xml=new XML(evt.target.data);			urlld.removeEventListener(Event.COMPLETE,onxmlcomp);			urlld=null;						ld=new Loader();			ld.load(new URLRequest(xml.video[0].titlepic));			ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onpiccomp);			addChild(ld);						tf.size=16;			var txt:TextField=new TextField();			txt.setTextFormat(tf);			txt.defaultTextFormat=tf;			txt.multiline=true;			txt.wordWrap=true;			txt.textColor=0xffffff;			txt.selectable=false;			txt.text=xml.video[0].title;			txt.width=210;			txt.height=50;			txt.x=28;			txt.y=206;			addChild(txt);						tf.size=14;			var txt1:TextField=new TextField();			txt1.setTextFormat(tf);			txt1.defaultTextFormat=tf;			txt1.multiline=true;			txt1.wordWrap=true;			txt1.textColor=0x565656;			txt1.selectable=false;			txt1.text="更新时间:"+xml.video[0].pubtime;			txt1.width=210;			txt1.height=20;			txt1.x=28;			txt1.y=265;			addChild(txt1);						var logo:Sprite=new EndPanelLogoSprite();			logo.x=10;			logo.y=450-86-30;			addChild(logo);						var replay:Sprite=new Sprite();			replay.graphics.beginFill(0xffffff,0);			replay.graphics.drawRect(0,0,275,450-86-30-25);			replay.graphics.endFill();			replay.buttonMode=true;			replay.y=25;			replay.addEventListener(MouseEvent.CLICK,onlink);						addChild(replay);						for(var i:int=1;i<10;i++){				var obj:Object=new Object();				obj.title=xml.video[i].title;				obj.titlepic=xml.video[i].titlepic;				obj.pubtime=xml.video[i].pubtime;				obj.titleurl=xml.video[i].titleurl;				var epi:Sprite=new EndPanelItem2(obj);				epi.x=290;				epi.y=(i-1)%3*(epi.height+25)+25;				addChild(epi);				arr.push(epi);				epi.visible=false;						}			tidy();						var down:SimpleButton=new EndPanelButtonDown();			down.x=3+290;			down.y=450-down.height-40;			down.addEventListener(MouseEvent.CLICK,ondown);			addChild(down);						var up:SimpleButton=new EndPanelButtonUp();			up.x=down.x+down.width+20;			up.y=450-up.height-40;			up.addEventListener(MouseEvent.CLICK,onup);			addChild(up);					}		private function onlink(evt:MouseEvent):void{			flash.net.navigateToURL(new URLRequest(xml.video[0].titleurl),"_blank");		}		private function ondown(evt:MouseEvent):void{			if(cur<2){				cur++;				tidy();			}		}		private function onup(evt:MouseEvent):void{			if(cur>0){				cur--;				tidy();			}		}		private function tidy():void{			for(var i:int;i<9;i++){				arr[i].visible=false;			}			if(cur==0){				arr[0].visible=true;				arr[1].visible=true;				arr[2].visible=true;			}else if(cur==1){				arr[3].visible=true;				arr[4].visible=true;				arr[5].visible=true;			}else{				arr[6].visible=true;				arr[7].visible=true;				arr[8].visible=true;			}		}		private function onpiccomp(evt:Event):void{			ld.x=28;			ld.y=25;			ld.width=210;			ld.height=158;		}				public function show():void{			if(numChildren==0){				init();			}			if(!Global.main.contains(this))Global.main.addChildAt(this,Global.main.numChildren-1);					}		public function hide():void{			if(Global.main.contains(this))Global.main.removeChild(this);		}	}	}