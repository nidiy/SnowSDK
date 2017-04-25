package snow.http
{
	import flash.net.URLRequestMethod;

	/**
	 * Http对象池
	 *
	 */
	public class HttpService
	{
		private static var https:Vector.<Http>=null;

		public function HttpService()
		{

		}
		/**
		 * 请求JSON数据
		 * @param url 链接
		 * @param params 附加参数
		 * @param callback 回调函数
		 * @param method 请求方式
		 * @param timeout 超时限制
		 * @param maxRetrys 最大重试次数
		 */
		public static function requestJSON(url:String, params:Object, callback:Function, method:String=URLRequestMethod.GET, timeout:int=10000, maxRetrys:int=2):void
		{
			var jsonHttp:JSONHttp=new JSONHttp();
			jsonHttp.request(url, params, callback, method, timeout, maxRetrys);
		}
	}
}