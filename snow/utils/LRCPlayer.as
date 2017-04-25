package snow.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class LRCPlayer
	{
		/**
		 * 字幕加载器
		 */
		private var LRCarray:Array=new Array();
		public var LRC:String="";
		protected var loader:URLLoader
		public function LRCPlayer()
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onDataComplete)
		}		
		private function onDataComplete(e:Event):void 
		{
			var value:String = loader.data;
			LoadFinish(value);
		}
		public function loadLRC(url:String):void
		{
			loader.load(new URLRequest(url))
		}
		public function getLRC(now:Number):String
		{
			for (var i:int=1,j:int=LRCarray.length; i < j; i++)
			{
				if (now < LRCarray[i].timer)
				{

					if (LRC!=LRCarray[i - 1].lyric)
					{
						LRC = LRCarray[i - 1].lyric;
					}
					break;
				}
			}
			return LRC
		}
		public function LoadFinish(list:String):void
		{
			while(LRCarray.length>0)
			{
				LRCarray.pop();
			}
			var listarray:Array = new Array()
			listarray=list.split("\n");
			var reg:RegExp = /\[[0-5][0-9]:[0-5][0-9].[0-9][0-9]\]/g;
			for (var i:int=0; i < listarray.length; i++)
			{
				var info:String = listarray[i];
				var len:int = info.match(reg).length;
				var timeAry:Array = new Array()
				timeAry=info.match(reg);
				var lyric:String=info.substr(len*10);
				for (var k:int=0; k < timeAry.length; k++)
				{
					var obj:Object=new Object();
					var ctime:String = timeAry[k];
					var ntime:Number = Number(ctime.substr(1,2)) * 60 + Number(ctime.substr(4,5));
					obj.timer = ntime * 1000;
					obj.lyric = lyric;
					LRCarray.push(obj);
				}
			}
			LRCarray.sort(compare);
		}
		protected function compare(paraA:Object,paraB:Object):int
		{
			if (paraA.timer > paraB.timer)
			{
				return 1;
			}
			if (paraA.timer < paraB.timer)
			{
				return -1;
			}
			return 0;
		}
	}

}