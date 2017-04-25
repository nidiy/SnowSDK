package snow.app.manager 
{
	import flash.display.StageAspectRatio;
	import flash.utils.Dictionary;
	import snow.app.core.AIRApp;
	import snow.app.core.AScriptWebApp;
	import snow.app.core.WebApp;

	/**
	 * ...
	 * @author Tim
	 */
	public class AppRegistry
	{
		public static const GAME:String = "game";
		public static const AIR_APP:String = "AIRApp";
		public static const WEB_APP:String = "WebApp";
	    private static var _instance:AppRegistry = null;		
		//待定处理方式
		private var classGroup:Array=[AIRApp,WebApp,AScriptWebApp];	
		public var registry:Dictionary;
		public function AppRegistry() 
		{
			registry = new Dictionary();
		}
		public function addRegistry(datas:Array):void
		{
			var length:int =datas.length;
			var id:String = "";
			for (var i:int = 0; i <length;i++) 
			{
				var item:Object = datas[i]
				item.type = item.type || 0;
				item.isGame = false;
				item.appClass = classGroup[item.type];
				id = item.id;
				registry[id] = item;
			}
		}
		public function addGame(id:String,gameClass:Class,aspectRatio:String=StageAspectRatio.ANY,fullScreen:Boolean=false):void
		{
			var item:Object = {};
		    item.id = id;
			item.isGame = true;
			item.appClass = gameClass;
			item.aspectRatio = aspectRatio;
			item.fullScreen = fullScreen;
			registry[id] =item;
		}
		public function getAtIDItem(id:String):Object
		{
			return registry[id];
		}		
		static public function get instance():AppRegistry 
		{
			if (!_instance)_instance = new AppRegistry();
			return _instance;
		}
	}
}