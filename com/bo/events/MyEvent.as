﻿package com.bo.events{	import flash.events.Event;		public class MyEvent extends Event	{		public static const POSTEVENT:String="postevent";		public static const COMP:String="complete";		public static const PREADINIT:String="adinit";		public static const PREADPLAY:String="adplay";		public static const PREADCOMPLETE:String="adcomplete";		public static const PREADERROR:String="aderror";				public static const VXMLCOMPLETE:String="vxmlcomplete";		public static const VXMLERROR:String="vxmlerror";				public static const OMSXMLCOMPLETE:String="omsxmlcomplete";		public static const OMSXMLERROR:String="omsxmlerror";				public static const ADXMLERROR:String="adxmlerror";		public static const ADXMLCOMPLETE:String="adxmlcompete";				public static const SEEKMEDIA:String="myseekmedia";		public var obj:*;		public function MyEvent(type:String, src:*,bubbles:Boolean=false, cancelable:Boolean=false)		{			obj=src;			super(type, bubbles, cancelable);		}	}}