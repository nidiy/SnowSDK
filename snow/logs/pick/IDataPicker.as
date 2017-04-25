package snow.logs.pick 
{
	
	/**
	 * A数据采集器接口
	 * @author Tim
	 */
	public interface IDataPicker 
	{
		
		function get serviceURL():String 		
		function set serviceURL(value:String):void 
		/**
		 * 发送当前日志到服务器
		 */
		function send():void
		/**
		 * 更新日志
		 * @param	value
		 */
		function updata(value:String):void
	}
	
	
}