package snow.app.manager 
{
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	/**
	 * 公共对象管理器
	 * 2013/9/10 10:29
	 * @author ...
	 */
	public class Manager 
	{
		public static var stage3DProxy:Stage3DProxy;
		public static var stage3DManager:Stage3DManager;
		public static var ANTIALIAS:int = 0;
		public static var COLOR:uint = 0xFFFFFF;
		public function Manager() 
		{
			
		}		
	}
}