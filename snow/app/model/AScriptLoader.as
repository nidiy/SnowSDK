package snow.app.model 
{
	import parser.Script;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 
	 */
	public class AScriptLoader 
	{
		protected var urls:Array = [];
		protected var urlloader:URLLoader;
		protected var completeFactory:Function = null;
		protected var _length:int = 0;
		public function AScriptLoader() 
		{
			urlloader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,onComplete)
		}		
		private function onComplete(e:Event):void 
		{
			var AsCode:String = e.target.data as String;
			Script.LoadFromString(AsCode)
			if (urls.length > 0)
			{
				var url:String = urls.shift() as String;
				load(url)
			}else
			{
				urlloader.removeEventListener(Event.COMPLETE, onComplete)
				urlloader = null;
				if(completeFactory!=null)completeFactory()
			}
		}
		public function enqueue(url:String):void
		{
			urls.push(url)
		}
		public function loadQnqueue(onComplete:Function):void
		{
			completeFactory = onComplete;
			var url:String = urls.shift() as String;
			load(url)
		}
		private function load(url:String):void
		{
			urlloader.load(new URLRequest(url))
		}		
		public function get length():int 
		{
			_length = urls.length;
			return _length;
		}
	}

}