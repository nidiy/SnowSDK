package snow.logs 
{
	import snow.logs.pick.IDataPicker;
	import snow.utils.Handle;
	/**
	 * 日志管理器
	 * @author Tim
	 */
	public class LogManage 
	{
		//日志最大内存，超过此内存后将自动截断保存日志文件
		public static const MAXSIZE:uint = 20480;
		public static var instance:LogManage
		//初始化管理器
		public static function init(picker:IDataPicker):LogManage
		{
			if (instance) return instance;
			instance = new LogManage(picker);
			return instance;
		}
		private var logs:String = "";
		private var picker:IDataPicker
		public function LogManage(picker:IDataPicker) 
		{
			this.picker = picker;
		}
		/**
		 * 发送日志到服务器
		 */
		public function send():void
		{
			//this.picker.send();
		}
		/**
		 * 添加日志
		 * @param	code    日志代号
		 * @param	msg     日志内容
		 */
		public function addLog(code:uint,msg:String):void
		{
			var value:String = Handle.getTime_name() + "  " + code+"  " + msg+"\n";
		    this.picker.updata(value)	
			logs += value;
		}
		//获取当前日志
		public function getLogs():String
		{
			return logs;
		}
	}

}