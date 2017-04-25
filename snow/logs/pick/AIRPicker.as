package snow.logs.pick 
{
	import snow.logs.LogManage;
	import snow.proxy.UserInfo;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequestMethod;
	import ghostcat.operation.server.HttpServiceProxy;
	import snow.utils.Handle;
	/**
	 * AIR端数据采集器
	 * @author Tim
	 */
	public class AIRPicker implements IDataPicker 
	{
		private var _serviceURL:String=""
		protected var fileName:String
		public function AIRPicker() 
		{
			fileName = getFileName();
		}
		protected var filenum:uint = 0;
		protected var isSend:Boolean = false;
		protected var cacheLogs:String = "";
		/**
		 * 发送当前日志到服务器
		 */
		public function send():void
		{
			isSend = true;
			var file:File = File.applicationStorageDirectory.resolvePath("logs");
			var filelist:Array = file.getDirectoryListing()
			filenum = filelist.length;
			if (filenum == 0) return;
			trace("共" + filenum + "个日志文件要发送");
			var tempLog:String = "";
			for (var i:int = 0; i <filenum; i++) 
			{
				var subfile:File = filelist[i] as File;
				var stream:FileStream = new FileStream();
				stream.open(subfile,FileMode.READ);
				tempLog += stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
			}
			trace("发送日志:" + tempLog);
//			UserInfo.instance.logs = tempLog;
			var httpService:HttpServiceProxy = new HttpServiceProxy(_serviceURL);
			httpService.operate(URLRequestMethod.POST, UserInfo.instance, sendComplete,sendError);
		}
		private function sendComplete(value:Object=null):void
		{
			trace("发送完成")
			isSend = false;
			if (cacheLogs != "") updata("");
		}
		private function sendError(value:Object=null):void
		{
			trace("发送错误")
			isSend = false;
			if (cacheLogs != "") updata("");
		}
		/**
		 * 更新日志
		 * @param	value
		 */
		public function updata(value:String):void
		{
			if (isSend)
			{
				cacheLogs += value;
				return;
			}
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			if (file.exists&&file.size >=LogManage.MAXSIZE)
			{
				//保存新的日志文件
				fileName = getFileName()
				file=File.applicationStorageDirectory.resolvePath(fileName);
			}
			if (cacheLogs != "")
			{
				cacheLogs += value;
				value = cacheLogs;
				cacheLogs = "";
			}
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.APPEND);
			fileStream.writeUTFBytes(value);
			fileStream.close();
		}
		/**
		 * 获取文件名称
		 * @return
		 */
		private function getFileName():String
		{
			return "logs/" + Handle.getTime_name() + ".log";
		}		
		public function get serviceURL():String 
		{
			return _serviceURL;
		}		
		public function set serviceURL(value:String):void 
		{
			_serviceURL = value;
		}
	}

}