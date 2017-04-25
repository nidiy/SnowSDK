package snow.app.core 
{
	import snow.utils.FileTool;
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Tim
	 */
	public class AppDownload 
	{
		private var fzip:FZip
		protected var onProgress:Function
		private var onComplete:Function
		public function AppDownload() 
		{
			fzip = new FZip()
			fzip.addEventListener(Event.COMPLETE, onZipComplete)
			fzip.addEventListener(FZipEvent.FILE_LOADED, onFileLoaded)
			fzip.addEventListener(ProgressEvent.PROGRESS, onZipProgress)
			
		}
		private function onZipProgress(e:ProgressEvent):void 
		{
			if (onProgress != null) onProgress(e.bytesLoaded / e.bytesTotal);
		}
		private function onFileLoaded(e:FZipEvent):void 
		{
			if (e.file.sizeCompressed > 0)
			{
			   FileTool.saveFile("airapp/"+e.file.filename,e.file.content)
			}
		}		
		private function onZipComplete(e:Event):void 
		{
			trace("升级完成")
			fzip.removeEventListener(Event.COMPLETE, onZipComplete)
			fzip.removeEventListener(FZipEvent.FILE_LOADED, onFileLoaded)
			fzip.removeEventListener(ProgressEvent.PROGRESS, onZipProgress)
			fzip.close();
			fzip = null;
			if (onComplete != null) onComplete();
		}
		public function load(data:Object,onComplete:Function = null,onProgress:Function = null):void
		{
			this.onComplete = onComplete;
			this.onProgress = onProgress;
			var url:String = data.url;
			trace("url::" + url);
			fzip.load(new URLRequest(url));
		}
	}
}