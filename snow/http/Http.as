package snow.http
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.trace.Trace;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * Http
	 *
	 */
	public class Http extends EventDispatcher
	{
		private var _idle:Boolean=true;
		private var _timeid:uint=0;
		private var _retrys:int=0; //重试次数
		private var _maxRetrys:int=0; //最大重试次数

		private var _url:String=null;
		private var _callback:Function=null;

		private var _loader:URLLoader=null;
		private var _request:URLRequest=null;

		public function Http()
		{
			_loader=new URLLoader();
			_request=new URLRequest();
		}

		/**
		 * 请求数据
		 * @param url 链接
		 * @param params 附加参数
		 * @param callback 回调函数
		 * @param method 请求方式
		 * @param timeout 超时限制
		 * @param maxRetrys 最大重试次数
		 */
		public function request(url:String, params:Object, callback:Function, method:String=URLRequestMethod.GET, timeout:int=10000,maxRetrys:int=2):void
		{
			_idle=false;
			_maxRetrys=maxRetrys;
			_url=url;
			_callback=callback;

			var variables:URLVariables=new URLVariables();
			if (params)
			{
				for (var key:String in params)
					variables[key]=params[key];
			}

			_request.url=_url;
			_request.data=variables;
			_request.method=method;

			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.load(_request);
			_timeid = setTimeout(onTimeout, timeout);
			trace("Http::request=>" + "method:" + method);
			trace("Http::request=>" +"url:" + _request.url + variables);
		}

		public function reset(errorCode:int, data:Object):void
		{
			_idle=true;
			_retrys=0;
			if(_callback!=null)
			{
				_callback(errorCode, data);
			}
			clearTimeout(_timeid);
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		private function onComplete(e:Event):void
		{
			reset(0, _loader.data);
		}

		private function onIOError(e:IOErrorEvent):void
		{
			_retrys++;
			if (_retrys >= _maxRetrys)
				reset(e.errorID, e.text);
			else
				_loader.load(_request);
		}

		private function onSecurityError(e:SecurityErrorEvent):void
		{
			reset(e.errorID, e.text);
		}

		private function onTimeout():void
		{
			reset(-1, "请求超时");
		}

		public function get idle():Boolean
		{
			return _idle;
		}
	}
}