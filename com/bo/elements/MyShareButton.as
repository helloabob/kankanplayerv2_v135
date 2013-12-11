package com.bo.elements
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import com.bo.events.MyEvent;

	public class MyShareButton extends DarkbuttonBase{
		private var msp:MySharePanel;
		public function MyShareButton(){
			init("ShareIcon");
			buttonMode=true;
		}
		public function registerEventListener():void{
			addEventListener(MouseEvent.CLICK,onShareButtonClick);
			addEventListener(MouseEvent.ROLL_OVER,onOver);
			addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		public function onShareButtonClick(evt:MouseEvent):void{
			//Global.main.sharePanel.show();
			if(!this.buttonstatus){
				msp=new MySharePanel();
				msp.addEventListener(MyEvent.COMP,onMspComplete);
				msp.x=Global.appWidth/2-msp.width/2;
				msp.y=Global.appHeight/2-msp.height/2-20;
				Global.main.addChild(msp);
				Global.mps.mediaPlayer.pause();
			}else{
				Global.main.removeChild(msp);
				msp.removeEventListener(MyEvent.COMP,onMspComplete);
				msp=null;
				Global.mps.mediaPlayer.play();
			}
			changestate();
		}
		private function onMspComplete(evt:MyEvent):void{
			Global.main.removeChild(msp);
			msp.removeEventListener(MyEvent.COMP,onMspComplete);
			msp=null;
			Global.mps.mediaPlayer.play();
			changestate();
		}
		private function onOver(evt:MouseEvent):void{
			Global._toolTip.show("分享",this.x);
			//Global.main.showToolTip(x+width/2,"分享");		
		}
		private function onOut(evt:MouseEvent):void{
			Global._toolTip.hide();;
			//Global.main.hideToolTip();	
		}
	}
}