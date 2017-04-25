package snow.logs.pick 
{
	import snow.logs.LogManage;
	import snow .proxy.UserInfo;
	import flash.net.URLRequestMethod;
	import ghostcat.operation.server.HttpServiceProxy;
	/**
	 * Web端数据采集器
	 * @author Tim
	 */
	public class WebPicker implements IDataPicker
	{
		
		private var _serviceURL:String = "";
		protected var cacheLogs:String = "";
		private var isSend:Boolean = false;
		private var logs:String = "";
		public function WebPicker() 
		{
			
		}
		/**
		 * 发送当前日志到服务器
		 */
		public function send():void
		{
			isSend = true;
//		    UserInfo.instance.logs = logs;
			var httpService:HttpServiceProxy = new HttpServiceProxy(_serviceURL);
			httpService.operate(URLRequestMethod.POST, UserInfo.instance,sendComplete,sendError);
		}
		private function sendError():void 
		{
			isSend = false;
		}		
		private function sendComplete():void 
		{
			isSend = false;
			logs = "";
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
			if (cacheLogs != "")
			{
				cacheLogs += value;
				value = cacheLogs;
				cacheLogs = "";
			}
			logs += value;
			if (logs.length >= LogManage.MAXSIZE)
			{
				send();
			}
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