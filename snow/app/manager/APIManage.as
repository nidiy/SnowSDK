package snow.app.manager 
{
	
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author tim
	 */
	public class APIManage 
	{
		private static var _instance:APIManage = null;		
		/**
		 * 获取实例
		 */
		static public function get instance():APIManage 
		{
			if (_instance == null)_instance = new APIManage();
			return _instance;
		}
		private var _callBacks:Dictionary;
		public function APIManage() 
		{
			_callBacks=new Dictionary()
		}
		/**
		 * 添加方法
		 * @param	name        方法名称
		 * @param	callback    执行的方法
		 */
		public function addCallback (name:String, callback:Function) : void
		{
			if (_callBacks[name] != null) delete _callBacks[name];
			_callBacks[name] = callback;
		}
		/**
		 * 执行方法
		 * @param	functionName  方法名称
		 * @param	callback      回调方法
		 * @param	...rest       传递给 functionName方法的参数
		 */
		public function call (functionName:String,callback:Function = null, ...rest) : void
		{
			var fun:Function = _callBacks[functionName];
			
			if (fun == null) return;
			
			var data:Object;
			
			trace("rest::" + rest);
			trace("rest::length" + fun.length);
			
			if (rest.length==0)
			{
				data=fun();
				
			}else if (rest.length == 1)
			{
				data=fun(rest[0]);
				
			}else if (rest.length == 2)
			{
				data=fun(rest[0],rest[1]);
				
			}else if (rest.length == 3)
			{
				data=fun(rest[0], rest[1], rest[2]);
				
			}else if (rest.length == 4)
			{
				data=fun(rest[0], rest[1], rest[2],rest[3]);
				
			}else if (rest.length == 5)
			{
				data=fun(rest[0], rest[1], rest[2], rest[3], rest[4]);
				
			}else if (rest.length == 6)
			{
				data=fun(rest[0], rest[1], rest[2], rest[3], rest[4],rest[5]);
				
			}else if (rest.length >= 7)
			{
				data=fun(rest[0], rest[1], rest[2], rest[3], rest[4], rest[5], rest[6]);
				
			}else
			{
				data=fun(rest);
			}
			if (callback != null) 
			{
				if (callback.length >= 1)
				{
					callback.call(null, data);
					
				}else
				{
					callback();
				}
			}
		}
		
	}

}