package com.bo.elements{
	
	import com.bo.events.MyEvent;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	public class MyShotButton extends DarkbuttonBase{
		private var msp:MyShotPanel;
		public function MyShotButton(){
			init("ShotIcon");
			buttonMode=true;
			
		}
		public function registerEventListener():void{
			addEventListener(MouseEvent.CLICK,onShotButtonClick);
			addEventListener(MouseEvent.ROLL_OVER,onOver);
			addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		public function onShotButtonClick(evt:MouseEvent):void{
			if(!this.buttonstatus){
				//Global._smgbbplayer.sharePanel.show();
				msp=new MyShotPanel();
				msp.addEventListener(MyEvent.COMP,onMspComplete);
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
			Global._toolTip.show("截图",this.x);
			//Global.main.showToolTip(x+width/2,"截图");		
		}
		private function onOut(evt:MouseEvent):void{			
			Global._toolTip.hide();
			//Global.main.hideToolTip();	
		}
	}
}