package snow.app.manager 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import snow.app.core.AIRApp;
	import snow.app.core.WebApp;
	import snow.app.model.DataProvider;
	/**
	 * 系统APP层
	 * @author HBinNet
	 */
	public class SystemApp extends EventDispatcher 
	{
		private var appClassManage:Object = {			
			"WebApp":WebApp,
			"AIRApp":AIRApp
		}
		public var appRegistry:AppRegistry;
		public var defaultApps:Array = [];		
		protected var container:flash.display.Sprite		
		protected var appRunList:Vector.<AppLoader> = new Vector.<AppLoader>
		protected var appLength:int = 0;
		public var appRectangle:Rectangle = null;
		public function SystemApp(_container:flash.display.Sprite) 
		{
			this.container=_container
		}
		public function start():void
		{
			//没有挂起
			var appClass:Class = null;
			var appURL:String = "";
			var appLoder:AppLoader;
			var appData:Object;
			for (var i:int = 0; i < defaultApps.length; i++) 
			{
				appData = defaultApps[i];				
				var appID:String = appData.appID;
				var appIDGroup:Array = appID.split("::");
				var ID:String = appIDGroup[0];
				var appItem:Object = appRegistry.getAtIDItem(ID);
				if (appItem == null)
				{
					continue;
				}
				appClass = appClassManage[appItem.appClass] as Class;
				appLoder = new AppLoader(container)
				if (appData.data != null) appLoder.data = appData.data;
				appLoder.id = appID;
				appLoder.appURL=appItem.appURL;
				appLoder.appClass=appClass;
				appRunList.push(appLoder);
				appLoder.start();
			}
			appLength = defaultApps.length
			run()
		}
		public function run():void
		{
			for (var i:int = 0; i <appLength; i++) 
			{
				appRunList[i].run()
			}
		}
		public function stop():void
		{
			for (var i:int = 0; i <appLength; i++) 
			{
				appRunList[i].pause()
			}
		}
		public function onRender():void
		{
			for (var i:int = 0; i <appLength; i++) 
			{
				appRunList[i].onRender()
			}
		}
		public function refreshAppSize():void
		{
			for (var i:int = 0; i <appLength; i++) 
			{
				appRunList[i].app.x = appRectangle.x;
				appRunList[i].app.y = appRectangle.y;
				appRunList[i].app.setSize(appRectangle.width,appRectangle.height);
			}
		}
		
	}

}