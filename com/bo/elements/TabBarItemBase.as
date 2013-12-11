package com.bo.elements {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class TabBarItemBase extends Sprite{
		private var bg:Sprite=new DarkControlBarBg();
		private var bgselected:Sprite=new DarkControlBarBgSelected();
		private var itemicon:MovieClip;
		private var itemtype:int;
		public var initComplete:Boolean=false;
		public function TabBarItemBase(itemType:int,itemWidth:int,itemHeight:int) {
			// constructor code
			itemtype=itemType;
			if(itemType==TabBarItemBaseType.LargerSymbol){
				itemicon=new DarkLargerPlayerSymbol();
			}else{
				itemicon=new DarkSmallerPlayerSymbol();
			}
			itemicon.gotoAndStop(1);
			itemicon.x=itemWidth/2-itemicon.width/2;
			itemicon.y=itemHeight/2-itemicon.height/2-2;
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,itemWidth,itemHeight);
			this.graphics.endFill();
			
			this.addChild(bg);
			this.addChild(bgselected);
			this.addChild(itemicon);
			
			bgselected.visible=false;
			
			this.buttonMode=true;
			this.addEventListener(MouseEvent.CLICK,onItemDown);
			this.addEventListener(MouseEvent.ROLL_OVER,onItemOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onItemOut);
		}
		
		private function onItemDown(evt:MouseEvent):void{
			if(initComplete){
				if(ExternalInterface.available){ //bigFunc  smaFunc
					var res:String=ExternalInterface.call(itemtype==TabBarItemBaseType.LargerSymbol?"bigFunc":"smaFunc");
					if(res=="1"){
						changeState(true);
						this.dispatchEvent(new Event("onItemDown"));
					}
				}
			}
		}
		private function onItemOver(evt:MouseEvent):void{
			this.itemicon.gotoAndStop(2);
			if(this.itemtype==TabBarItemBaseType.SmallerSymbol){
				Global._toolTip.show("缩小",this.x);
			}else{
				Global._toolTip.show("展开",this.x);
			}
			
		}
		private function onItemOut(evt:MouseEvent):void{
			this.itemicon.gotoAndStop(1);
			Global._toolTip.hide();
			
		}
		public function changeState(isselected:Boolean):void{
			this.itemicon.gotoAndStop(1);
			if(isselected){
				bg.visible=false;
				bgselected.visible=true;
				this.removeEventListener(MouseEvent.CLICK,onItemDown);
				this.removeEventListener(MouseEvent.ROLL_OVER,onItemOver);
				this.removeEventListener(MouseEvent.ROLL_OUT,onItemOut);
			}else{
				bg.visible=true;
				bgselected.visible=false;
				this.addEventListener(MouseEvent.CLICK,onItemDown);
				this.addEventListener(MouseEvent.ROLL_OVER,onItemOver);
				this.addEventListener(MouseEvent.ROLL_OUT,onItemOut);
			}
		}
	}
}
