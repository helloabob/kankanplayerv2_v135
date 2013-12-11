package
{
	import com.debugTip.DebugTip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author Ron Tian
	 */
	public class RonSoundFX extends EventDispatcher
	{
		protected var _fxID:int;
		protected var _tw:int;
		protected var _th:int;
		protected var fxContainer:DisplayObjectContainer;
		protected var fxShape:Shape;
		protected var fxSprite:Sprite;
		protected var isStarted:Boolean;
		protected var mc:Number;
		protected var mf:Boolean;
		protected var md:Boolean;
		protected var mz:int=1;
		protected var tl:Array;
		protected var cs:Number=1;
		protected var cl:Array;
		protected var br:BlurFilter;
		protected var cm:ColorMatrixFilter;
		protected var bd:BitmapData;
		protected var bdbd:BitmapData;
		protected var rt:Rectangle;
		protected var pt:Point;
		protected var fn:Function;
		protected var ml:Array;
		protected var bn:int;
		protected var dy:Number;
		protected var dz:Number=0;
		protected var listVal:Array;
		protected var listDot:Array;
		protected var listBar:Array;
		protected var list256:Array;
		protected var list512:Array;


		public function RonSoundFX(fxContainer:DisplayObjectContainer, $tw:int=400, $th:int=300, $fxID:int=0)
		{
			this.fxContainer=fxContainer;
			fxShape=new Shape();
			this.fxContainer.addChild(fxShape);
			fxSprite=new Sprite();
			this.fxContainer.addChild(fxSprite);
			_tw=$tw;
			_th=$th;
			_fxID=$fxID;
			this.fxContainer.scrollRect=new Rectangle(0, 0, _tw, _th);
			fxInit();
			super();
		}

		public function start():void
		{
			
			stop();
			isStarted=true;
			this.dz=0;
			this.bn=this.tw * 0.125;
			if (this.bn > 512)
			{
				this.bn=512;
			}
			this.dy=this.th * 0.008;
			this.listVal=this.zero(this.bn);
			this.listDot=this.zero(this.bn);
			this.listBar=this.zero(this.bn);
			this.list256=this.zero(256);
			this.list512=this.zero(512);
			this.rt=new Rectangle(0, 0, this.tw, this.th);
			this.bd=new BitmapData(this.tw, this.th, true, 0);
			while (this.fxSprite.numChildren)
			{

				this.fxSprite.removeChildAt(0);
			}
			this.fxSprite.addChild(new Bitmap(this.bd));
			this.mc=0xa4eb0c;
			this.mf=true;
			this.md=true;
			DebugTip.instance.log("----sound fxid:"+fxID+"------");
			this.fn=ml[fxID];
			fxContainer.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function stop():void
		{
			isStarted=false;
			if (!fxContainer.hasEventListener(Event.ENTER_FRAME))
			{
				return;
			}
			this.cs=Math.floor(this.cl.length * Math.random());
			fxContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			this.fxShape.graphics.clear();
			this.clearF();
		}

		protected function onEnterFrameHandler(event:Event):void
		{
			if (fn != null)
			{
				fn();
			}
		}

		protected function fxInit():void
		{
			this.tl=[1, 2, 4];
			this.pt=new Point(0, 0);
			this.cm=new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.9, 0]);
			this.br=new BlurFilter(8, 8, 2);
			this.cl=this.gCL();
			this.ml=this.gML();
		}

		protected function rC():void
		{
			var _loc_1:*=Math.random();
			if (_loc_1 > 0.99)
			{
				this.mz=this.mz * -1;
				if (_loc_1 > 0.999)
				{
					this.tl.push(this.tl.shift());
				}
			}
			var _loc_2:*=Math.round(this.mz * _loc_1 * 5);
			this.cs=this.cs + _loc_2;
			if (this.cs < 0)
			{
				this.cs=this.cl.length - 1;
			}
			else if (this.cs >= this.cl.length)
			{
				this.cs=0;
			}
			this.mc=this.cl[this.cs];
		}

		protected function zero(param1:int):Array
		{
			var _loc_2:Array=[];
			var _loc_3:int=0;
			while (_loc_3 < param1)
			{

				_loc_2.push(0);
				_loc_3++;
			}
			return _loc_2;
		}

		protected function gML():Array
		{
			
			return [this.m01, this.m02, this.m03, this.m04, this.m05, this.m06, this.m07, this.m08, this.m09, this.m10];
		}

		protected function applyDisplace(param1:BitmapData):void
		{
			this.bdbd=param1.clone();
			var _loc_2:*=new DisplacementMapFilter(this.bdbd, this.pt, this.tl[0], this.tl[1], 10, 10, "clamp");
			param1.applyFilter(this.bdbd, param1.rect, this.pt, _loc_2);
		}

		protected function gCL():Array
		{
			var _loc_1:Array=[];
			var _loc_2:Array=[];
			var _loc_3:Array=[];
			var _loc_4:Array=[];
			var _loc_5:Array=[];
			var _loc_6:Array=[];
			var _loc_7:int=0;
			while (_loc_7 < 255)
			{

				_loc_1.push(16711680 + _loc_7 * 256);
				_loc_2.push((255 - _loc_7) * 65536 + 65280);
				_loc_3.push(65280 + _loc_7);
				_loc_4.push((255 - _loc_7) * 256 + 255);
				_loc_5.push(255 + _loc_7 * 65536);
				_loc_6.push(255 - _loc_7 + 16711680);
				_loc_7=_loc_7 + 3;
			}
			var _loc_8:Array=[];
			_loc_8=[].concat(_loc_1).concat(_loc_2).concat(_loc_3).concat(_loc_4).concat(_loc_5).concat(_loc_6);
			return _loc_8;
		}

		protected function gb(param1:Boolean=false):ByteArray
		{
			var b:ByteArray=new ByteArray();
			if (SoundMixer.areSoundsInaccessible())
			{
				//flash.external.ExternalInterface.call("alert","nonono");
				this.stop();
			}
			else
			{
				try
				{
					SoundMixer.computeSpectrum(b, param1);
						//flash.external.ExternalInterface.call("alert","yes");
				}
				catch (e:Error)
				{
					//flash.external.ExternalInterface.call("alert",e.toString()+"::"+e.errorID);
				}
			}
			return b;
		}

		protected function clearF():void
		{
			if (this.bd)
			{
				this.bd.fillRect(this.bd.rect, 0);
			}
		}

		protected function sF(param1:Boolean=true):void
		{
			if (this.mf)
			{
				this.bd.draw(this.fxShape);
				if (this.md)
				{
					this.rC();
					if (param1)
					{
						this.applyDisplace(this.bd);
					}
					else
					{
						this.bd.applyFilter(this.bd, this.rt, this.pt, this.cm);
					}
				}
				else
				{
					this.bd.applyFilter(this.bd, this.rt, this.pt, this.cm);
				}
				this.bd.applyFilter(this.bd, this.rt, this.pt, this.br);
			}
		}

		protected function lr(param1:ByteArray, param2:Boolean=false):ByteArray
		{
			var _loc_4:ByteArray=null;
			var _loc_5:Number=NaN;
			var _loc_6:Number=NaN;
			var _loc_7:Number=NaN;
			var _loc_3:*=new ByteArray();
			param1.position=0;
			if (param1.bytesAvailable)
			{
				_loc_4=new ByteArray();
				param1.position=1024;
				param1.readBytes(_loc_4);
				param1.position=0;
				while (_loc_4.bytesAvailable)
				{

					_loc_5=param1.readFloat();
					_loc_6=_loc_4.readFloat();
					if (param2 || _loc_5 > 0 && _loc_6 > 0)
					{
						_loc_7=_loc_5 > _loc_6 ? (_loc_5) : (_loc_6);
					}
					else if (_loc_5 < 0 && _loc_6 < 0)
					{
						_loc_7=_loc_5 < _loc_6 ? (_loc_5) : (_loc_6);
					}
					else
					{
						_loc_7=(_loc_5 + _loc_6) * 0.5;
					}
					_loc_3.writeFloat(_loc_7);
				}
				_loc_3.position=0;
			}
			return _loc_3;
		}

		protected function m01():void
		{
			var _loc_7:Number=0;
			var _loc_1:*=this.lr(this.gb(true), true);
			var _loc_2:*=this.tw * 0.00390625;
			var _loc_3:*=this.th * 0.666;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.beginFill(this.mc);
			var _loc_4:*=this.tw / this.bn;
			var _loc_5:*=Math.floor(252 / this.bn - 1) * 4;
			var _loc_6:int=0;
			while (_loc_6 < this.bn && _loc_1.bytesAvailable)
			{

				_loc_7=_loc_3 * _loc_1.readFloat();
				if (_loc_5)
				{
					_loc_1.position=_loc_1.position + _loc_5;
				}
				this.listVal[_loc_6]=this.listVal[_loc_6] * 1.1;
				this.listDot[_loc_6]=this.listDot[_loc_6] - this.listVal[_loc_6];
				if (this.listDot[_loc_6] < _loc_7)
				{
					this.listVal[_loc_6]=this.dy * 0.5;
					this.listDot[_loc_6]=_loc_7;
				}
				this.listBar[_loc_6]=this.listBar[_loc_6] - (this.listVal[_loc_6] + 2);
				if (this.listBar[_loc_6] < _loc_7)
				{
					this.listBar[_loc_6]=_loc_7;
				}
				this.fxShape.graphics.drawRect(_loc_4 * _loc_6, this.th, (_loc_4 - 1), -this.listBar[_loc_6]);
				this.fxShape.graphics.drawRect(_loc_4 * _loc_6, this.th - this.listDot[_loc_6] - 1, (_loc_4 - 1), 1);
				_loc_6++;
			}
			this.fxShape.graphics.endFill();
			this.sF(false);
		}

		protected function m02():void
		{
			var _loc_5:Number=NaN;
			var _loc_6:int=0;
			var _loc_1:*=this.lr(this.gb());
			var _loc_2:*=this.th * 0.5;
			var _loc_3:*=this.tw * 0.00390625;
			var _loc_4:*=_loc_2 * 0.8;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.lineStyle(1, this.mc);
			if (_loc_1.bytesAvailable)
			{
				_loc_5=_loc_4 * _loc_1.readFloat();
				this.fxShape.graphics.moveTo(0, _loc_2 + _loc_5);
				_loc_6=1;
				while (_loc_6 < 256)
				{

					_loc_5=_loc_4 * _loc_1.readFloat();
					this.fxShape.graphics.lineTo(_loc_6 * _loc_3, _loc_2 + _loc_5);
					_loc_6++;
				}
			}
			this.sF(false);
		}

		protected function m03():void
		{
			var _loc_4:int=0;
			var _loc_5:Number=NaN;
			var _loc_1:*=this.gb(true);
			var _loc_2:*=this.tw * 0.00195313;
			var _loc_3:*=this.th * 0.666;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.beginFill(this.mc);
			this.fxShape.graphics.moveTo(this.tw * 0.5, this.th);
			if (_loc_1.bytesAvailable)
			{
				_loc_4=255;
				while (_loc_4 > 0)
				{

					_loc_5=_loc_3 * _loc_1.readFloat();
					this.fxShape.graphics.lineTo(_loc_4 * _loc_2, this.th - _loc_5);
					_loc_4=_loc_4 - 1;
				}
				this.fxShape.graphics.lineTo(0, this.th);
				this.fxShape.graphics.moveTo(this.tw * 0.5, this.th);
				_loc_4=256;
				while (_loc_4 < 512)
				{

					_loc_5=_loc_3 * _loc_1.readFloat();
					this.fxShape.graphics.lineTo(_loc_4 * _loc_2, this.th - _loc_5);
					_loc_4++;
				}
			}
			this.fxShape.graphics.lineTo(this.tw, this.th);
			this.fxShape.graphics.endFill();
			this.sF(false);
		}

		protected function m04():void
		{
			var _loc_5:Number=NaN;
			var _loc_1:*=this.lr(this.gb(true), true);
			var _loc_2:*=this.tw * 0.00390625;
			var _loc_3:*=this.th * 0.666;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.lineStyle(1, this.mc);
			this.fxShape.graphics.beginFill(this.mc);
			this.fxShape.graphics.moveTo(0, this.th);
			var _loc_4:int=1;
			while (_loc_4 < 256 && _loc_1.bytesAvailable)
			{

				_loc_5=_loc_3 * _loc_1.readFloat();
				this.list256[_loc_4]=this.list256[_loc_4] - this.dy * 2;
				if (this.list256[_loc_4] < _loc_5)
				{
					this.list256[_loc_4]=_loc_5;
				}
				this.fxShape.graphics.lineTo(_loc_4 * _loc_2, this.th - this.list256[_loc_4]);
				_loc_4++;
			}
			this.fxShape.graphics.lineTo(this.tw, this.th);
			this.fxShape.graphics.endFill();
			this.sF(false);
		}

		protected function m05() : void
		{
			var _loc_6:Number = NaN;
			var _loc_1:* = this.gb(true);
			var _loc_2:* = this.th * 0.5;
			var _loc_3:* = this.tw * 0.00390625;
			var _loc_4:* = this.th * 0.4;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.beginFill(0xffcc00);//this.mc
			this.fxShape.graphics.moveTo(0, _loc_2);
			var _loc_5:int = 0;
			while (_loc_1.bytesAvailable)
			{
				
				_loc_6 = _loc_4 * _loc_1.readFloat();
				this.list512[_loc_5] = this.list512[_loc_5] - this.dy * 2;
				if(_loc_5==5){
					//DebugTip.instance.log("-----------------Ronsound loc6:"+_loc_6+"--------------");
				}
				
				if (this.list512[_loc_5] < _loc_6)
				{
					this.list512[_loc_5] = _loc_6;
				}
				if (_loc_5 >= 256)
				{
					if (_loc_5 == 256)
					{
						this.fxShape.graphics.lineTo(this.tw, _loc_2);
						this.fxShape.graphics.lineTo(0, _loc_2);
					}
					this.fxShape.graphics.lineTo((_loc_5 - 256) * _loc_3, _loc_2 - this.list512[_loc_5]);
				}
				else
				{
					this.fxShape.graphics.lineTo(_loc_5 * _loc_3, _loc_2 + this.list512[_loc_5]);
				}
				
				_loc_5++;
			}
			this.fxShape.graphics.lineTo(this.tw, _loc_2);
			this.fxShape.graphics.lineTo(0, _loc_2);
			this.sF(false);
			
		}


		protected function m06():void
		{
			var _loc_6:Number=NaN;
			var _loc_7:int=0;
			var _loc_8:Number=NaN;
			var _loc_9:Number=NaN;
			var _loc_10:Number=NaN;
			var _loc_1:*=this.lr(this.gb(true), true);
			var _loc_2:*=this.tw * 0.5;
			var _loc_3:*=this.th * 0.5;
			var _loc_4:*=this.th * 0.3;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.lineStyle(5, this.mc);
			this.fxShape.graphics.moveTo(_loc_2, _loc_3);
			var _loc_5:int=0;
			while (_loc_1.bytesAvailable)
			{

				_loc_6=_loc_4 * _loc_1.readFloat() + 5;
				this.list256[_loc_5]=this.list256[_loc_5] - this.dy;
				if (this.list256[_loc_5] < _loc_6)
				{
					this.list256[_loc_5]=_loc_6;
					this.list512[_loc_5]=Math.random() * 360;
				}
				_loc_6=this.list256[_loc_5];
				_loc_7=this.list512[_loc_5];
				_loc_8=_loc_7 * (Math.PI / 180);
				_loc_9=_loc_6 * Math.cos(_loc_8) + _loc_2;
				_loc_10=_loc_6 * Math.sin(_loc_8) + _loc_3;
				this.fxShape.graphics.moveTo(_loc_2, _loc_3);
				this.fxShape.graphics.lineTo(_loc_9, _loc_10);
				_loc_5++;
			}
			this.sF(false);
		}

		protected function m07():void
		{
			var _loc_4:int=0;
			var _loc_1:*=this.lr(this.gb(true), true);
			this.fxShape.graphics.clear();
			var _loc_2:int=20;
			var _loc_3:int=0;
			var _loc_5:*;
			var _loc_6:*;
			while (_loc_3 < 256 && _loc_1.bytesAvailable)
			{
				if (this.list256[_loc_3] < 1)
				{
					this.list256[_loc_3]=1;
					_loc_5=_loc_2 * _loc_1.readFloat();
					_loc_4=_loc_2 * _loc_1.readFloat();
					this.list256[(_loc_3 + 1)]=_loc_5;
					this.list256[_loc_3 + 2]=(this.tw - 2 * _loc_2) * Math.random() + _loc_2;
					_loc_4=_loc_4 * 0.5;
					if (_loc_4 < 3)
					{
						_loc_4=3;
					}
					this.list256[_loc_3 + 3]=_loc_4;
				}
				else
				{
					_loc_5=this.list256;
					var _loc_7:*=this.list256[_loc_3 + 1] - 1;
					_loc_5[_loc_3 + 1]=_loc_7;
					this.list256[_loc_3]=this.list256[_loc_3] + this.list256[(_loc_3 + 1)];
					if (this.list256[_loc_3 + 3] > 3)
					{
						this.list256[_loc_3 + 3]=this.list256[_loc_3 + 3] - 0.5;
					}
				}
				this.fxShape.graphics.beginFill(this.mc);
				this.fxShape.graphics.drawCircle(this.list256[_loc_3 + 2], this.th - this.list256[_loc_3], this.list256[_loc_3 + 3]);
				this.fxShape.graphics.endFill();
				_loc_3=_loc_3 + 8;
			}
			this.sF();
		}

		protected function m08():void
		{
			var _loc_4:Number=NaN;
			var _loc_1:*=this.lr(this.gb(true), true);
			var _loc_2:int=10;
			this.fxShape.graphics.clear();
			var _loc_3:int=0;
			while (_loc_3 < 256 && _loc_1.bytesAvailable)
			{

				_loc_4=_loc_2 * _loc_1.readFloat();
				if (this.list256[_loc_3] < 1)
				{
					this.list256[(_loc_3 + 1)]=(this.tw - 2 * _loc_2) * Math.random() + _loc_2;
					this.list256[_loc_3 + 2]=(this.th - 2 * _loc_2) * Math.random() + _loc_2;
					this.list256[_loc_3 + 3]=false;
				}
				if (this.list256[_loc_3] < _loc_4)
				{
					this.list256[_loc_3]=_loc_4;
				}
				this.list256[_loc_3]=this.list256[_loc_3] - 0.5;
				if (_loc_4 > 8 && _loc_3 || this.list256[_loc_3 + 3])
				{
					if (this.list256[_loc_3 + 3])
					{
						if (this.list256[_loc_3 + 4] > 0)
						{
							this.list256[_loc_3 + 4]=this.list256[_loc_3 + 4] - 0.05;
						}
						else
						{
							this.list256[_loc_3 + 3]=false;
						}
					}
					else
					{
						this.list256[_loc_3 + 4]=1;
						this.list256[_loc_3 + 3]=true;
					}
					this.fxShape.graphics.lineStyle(1, this.mc, this.list256[_loc_3 + 4]);
					this.fxShape.graphics.lineTo(this.list256[(_loc_3 + 1)], this.list256[_loc_3 + 2]);
				}
				this.fxShape.graphics.beginFill(this.mc);
				this.fxShape.graphics.drawCircle(this.list256[(_loc_3 + 1)], this.list256[_loc_3 + 2], this.list256[_loc_3]);
				this.fxShape.graphics.moveTo(this.list256[(_loc_3 + 1)], this.list256[_loc_3 + 2]);
				this.fxShape.graphics.endFill();
				_loc_3=_loc_3 + 8;
			}
			this.sF(false);
		}

		protected function m09():void
		{
			var _loc_4:Number=NaN;
			var _loc_12:Point=null;
			var _loc_14:Number=NaN;
			var _loc_15:int=0;
			var _loc_16:Number=NaN;
			var _loc_17:Number=NaN;
			var _loc_18:Number=NaN;
			var _loc_1:*=this.gb(true);
			var _loc_2:*=this.tw * 0.5;
			var _loc_3:*=this.th * 0.5;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.lineStyle(1, this.mc);
			var _loc_5:*=this.th * 0.3;
			var _loc_6:Array=[];
			var _loc_7:Number=0;
			var _loc_8:Number=0;
			var _loc_9:int=1;
			while (_loc_1.bytesAvailable)
			{

				_loc_14=_loc_1.readFloat();
				if (_loc_14 > 0)
				{
					_loc_4=_loc_14 * _loc_5 + 5;
					_loc_7=_loc_7 + _loc_4;
					_loc_8=_loc_7 / _loc_9;
					_loc_6.push(_loc_4 - _loc_8);
					_loc_9++;
				}
			}
			var _loc_10:int=0;
			var _loc_11:*=_loc_6.length;
			var _loc_13:int=0;
			while (_loc_10 < _loc_11)
			{

				_loc_4=Math.abs((_loc_6[_loc_10] - _loc_8) * 0.5) + _loc_8;
				this.list512[_loc_10]=this.list512[_loc_10] - this.dy;
				if (this.list512[_loc_10] < _loc_4)
				{
					this.list512[_loc_10]=_loc_4;
				}
				_loc_4=this.list512[_loc_10];
				_loc_15=Math.round(_loc_10 * 360 / _loc_11) + this.dz;
				_loc_16=_loc_15 * (Math.PI / 180);
				_loc_17=Math.round(_loc_4 * Math.cos(_loc_16)) + _loc_2;
				_loc_18=Math.round(_loc_4 * Math.sin(_loc_16)) + _loc_3;
				if (_loc_10 == 0)
				{
					this.fxShape.graphics.moveTo(_loc_2, _loc_3);
					_loc_12=new Point(_loc_17, _loc_18);
				}
				this.fxShape.graphics.lineTo(_loc_17, _loc_18);
				if (_loc_15 - _loc_13 > 8)
				{
					this.fxShape.graphics.lineTo(_loc_2, _loc_3);
					this.fxShape.graphics.moveTo(_loc_17, _loc_18);
					_loc_13=_loc_15;
				}
				_loc_10++;
			}
			if (_loc_12)
			{
				this.fxShape.graphics.lineTo(_loc_12.x, _loc_12.y);
			}
			dz++;
			this.sF(false);
		}

		protected function m10():void
		{
			var _loc_4:Number=NaN;
			var _loc_1:*=this.lr(this.gb(true), true);
			var _loc_2:int=20;
			this.fxShape.graphics.clear();
			this.fxShape.graphics.lineStyle(1, this.mc);
			var _loc_3:int=0;
			while (_loc_3 < 256 && _loc_1.bytesAvailable)
			{

				_loc_4=_loc_2 * _loc_1.readFloat();
				if (this.list256[_loc_3] < 1)
				{
					this.list256[(_loc_3 + 1)]=(this.tw - 2 * _loc_2) * Math.random() + _loc_2;
					this.list256[_loc_3 + 2]=(this.th - 2 * _loc_2) * Math.random() + _loc_2;
				}
				if (this.list256[_loc_3] < _loc_4)
				{
					this.list256[_loc_3]=_loc_4;
				}
				var _loc_5:*=this.list256;
				var _loc_6:*=_loc_3;
				var _loc_7:*=this.list256[_loc_3] - 1;
				_loc_5[_loc_6]=_loc_7;
				this.fxShape.graphics.drawCircle(this.list256[(_loc_3 + 1)], this.list256[_loc_3 + 2], this.list256[_loc_3]);
				_loc_3=_loc_3 + 8;
			}
			this.sF();
		}

		public function get fxID():int
		{
			return _fxID;
		}

		public function set fxID(value:int):void
		{
			_fxID=value;
			start();
		}

		public function get tw():int
		{
			return _tw;
		}

		public function set tw(value:int):void
		{
			_tw=value;
			sizeFX();
		}

		protected function sizeFX():void
		{
			this.fxContainer.scrollRect=new Rectangle(0, 0, _tw, _th);
			if (isStarted)
			{
				start();
			}
		}

		public function get th():int
		{
			return _th;
		}

		public function set th(value:int):void
		{
			_th=value;
			sizeFX();
		}

	}

}

