package com.bo.elements
{
	import com.debugTip.DebugTip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class EndPanel extends Sprite
	{
		private var currentindex:int=0;
		private var order:Array=[0, 1, 3, 6, 4, 2, 5, 7, 8];

		public function EndPanel()
		{
			// constructor code
		}

		private function init():void
		{
			
			if(!Global.videodata.relation)return;
			
			DebugTip.instance.log("endpanel relation length"+Global.videodata.relation.length)
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, Global.appWidth, Global.appHeight - 32);
			graphics.endFill();
			
			buttonMode=true;
			for (var i:int=0; i < 3; i++)
			{
				for (var j:int=0; j < 3; j++)
				{
					/*var item:EndPanelItem=new EndPanelItem(198,148);
					item.x=1.5+(199.5*j);
					item.y=1.5+(149.5*i);*/
					//&& String(Global.videodata.relation[i * 3 + j].title).split(" ").join("")!=""
					if (i * 3 + j < Global.videodata.relation.length )
					{
						DebugTip.instance.log("endpanel title --------"+Global.videodata.relation[i * 3 + j].title);
						//Global.appWidth /3	Global.appHeight/3
						var item:EndPanelItem=new EndPanelItem(Global.appWidth/4,Global.appHeight/4);//152, 114
						var ox:int=Global.appWidth/4/6*2;  ////(Global.appWidth - 456) / 4 + 16;
						var oy:int=Global.appHeight/4/4;////(Global.appHeight - 32 - 342) / 4 + 12;
						var ow:int=Global.appWidth/4+Global.appWidth/4/6;//152 + (Global.appWidth - 456) / 4 - 16;
						var oh:int=Global.appHeight/4+Global.appHeight/4/6;//114 + (Global.appHeight - 32 - 342) / 4 - 12;
						item.x=ox + (ow * j);
						item.y=oy + (oh * i);
						//item.x=52+(172*j);
						//item.y=39+(129*i);
						currentindex=0;
						item.Title=Global.videodata.relation[i * 3 + j].title;
						//item.ImageURL="http://static.statickksmg.com/image/2012/03/22/9ea5debf7a1d8a9cdb97c9808f8c285e.jpg";
						//item.ImageURL=Global.videodata.relation[i*3+j].imageurl;
						item.Link=Global.videodata.relation[i * 3 + j].link;
						addChild(item);
					}
				}
			}
			loadimage();
			
			
		}
		private function loadimage():void
		{
			if (currentindex < 9)
			{
				var item:EndPanelItem=getChildAt(order[currentindex]) as EndPanelItem;
				item.addEventListener(Event.COMPLETE, onloadcomplete);
				item.ImageURL=Global.videodata.relation[order[currentindex]].imageurl;
			}
		}

		private function onloadcomplete(evt:Event):void
		{
			var item:EndPanelItem=getChildAt(order[currentindex]) as EndPanelItem;
			item.removeEventListener(Event.COMPLETE, onloadcomplete);
			if (currentindex < 8)
			{
				currentindex++;
				loadimage();
			}
			//setTimeout(loadimage,50);
		}

		public function show():void
		{
			if(Global.playerparameter.isRelation =="true"){
				if(numChildren==0){
					DebugTip.instance.log("pauseStep2");
					init();
				}
				if(!Global.main.contains(this)){
					DebugTip.instance.log("pauseStep3"+this.width+this.height);
					Global.main.addChildAt(this,Global.main.numChildren-1);
				}
			}
		}

		public function hide():void
		{
			if (Global.playerparameter.isRelation == "true")
			{
				if (Global.main.contains(this)){
					Global.main.removeChild(this);
				}
			}
		}
	}

}
