package snow.app.core
{
	import snow.utils.FileTool;
	import parser.Script;
	import snow.app.core.App;
	import snow.app.core.App;
	import snow.app.event.AppEvent;
	import snow.app.manager.AppRegistry;
	import snow.app.model.APPDataControl;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author
	 */
	public class AIRApp extends App
	{
		public var appdataControl:APPDataControl;
		protected var fileURL:String = "";
		public function AIRApp()
		{
			super();
		}	
		override protected function initMilieu():void
		{
			
			super.initMilieu();
			startTime = getTimer();
			this.initializeFacade();
			runApp();
		}
		public function runApp():void
		{
			if (fileURL == "") fileURL = "airapp/" + id + "/appConfig.xml";
			if (FileTool.existStorage(fileURL))
			{
				//专署目录中存在文件;
				fileURL = FileTool.getStorageDirectory(fileURL);
				
			}
			else if (!FileTool.existApp(fileURL))
			{
				//当专署目录中不存在文件时，判断是安装目录中是否正在
				updateApp();
				return;
			}
			this.onDataComplete = loadAppComplete
			appdataControl = new APPDataControl("APPDataControl",fileURL);
			this.registerProxy(appdataControl)
		}		
		protected function loadAppComplete():void
		{
			compileTime = getTimer();
			if (appdataControl.defaultClass != "") Script.New(appdataControl.defaultClass, this);
			if (onAppComplete != null)
			{
				onAppComplete();
			}			
			var item:Object = AppRegistry.instance.getAtIDItem(id);
			//判断与注册表的版本是否一致
			if (item && this.info)
			{
				if (item.version > this.info.version)
				{
					trace("正在更新……");
					updateApp();
				}
			}
			this.dispatchEvent(new AppEvent(AppEvent.APP_COMPLETE,info));
		}
		protected function updateApp():void
		{
			var item:Object = AppRegistry.instance.getAtIDItem(id);
			var appDownload:AppDownload = new AppDownload();
			appDownload.load(item);
		}
		override public function dispose():void
		{
			this.removeProxy("APPDataControl");
			appdataControl = null;
			super.dispose();
		}
	}
}