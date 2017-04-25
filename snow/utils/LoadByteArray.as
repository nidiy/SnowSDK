package snow.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class LoadByteArray extends EventDispatcher 
	{
		protected var loadURL:URLLoader
		public var onCompleteData:Function = null;
		public function LoadByteArray() 
		{
			super()
			loadURL = new URLLoader();
			loadURL.dataFormat = URLLoaderDataFormat.BINARY;
			loadURL.addEventListener(Event.COMPLETE, onComplete)
			loadURL.addEventListener(IOErrorEvent.IO_ERROR,onIOError)
		}		
		private function onComplete(e:Event):void 
		{
			var bytarray:ByteArray = loadURL.data;
			if(onCompleteData!=null)onCompleteData(bytarray)
		}
		private function onIOError(e:IOErrorEvent):void 
		{
			if(onCompleteData!=null)onCompleteData(null)
		}
		public function load(url:String):void
		{
			loadURL.load(new URLRequest(url));
		}
		
	}

}