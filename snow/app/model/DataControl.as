package snow.app.model 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import ghostcat.text.FilePath;
	import starling.core.Starling;
	import starling.utils.AssetManager;
	import snow.app.core.App;
	import snow.app.model.loader.ILoader;
	import snow.app.model.loader.LoaderControl;
	import snow.app.core.Info;
	import snow.app.event.DataLoaderEvent;
	import snow.utils.XMLUtil;
	import snow.mvc.patterns.proxy.Proxy;
	import flash.utils.getTimer;
	/**
	 * 数据控制器1.1
	 * 更改了视图及GUI控制器名称将原来的gui改为guiControl,view改为viewControl
	 * 2013/9/10 9:42
	 * @author 
	 */
	public class DataControl extends Proxy implements IDataControl 
	{
		public static var DATA_LOAD_COMPLETE:String="dataLoadComplete"
		
		public var PATH:String = "";		
		protected var _config:XML;
		protected var appConfigLoader:URLLoader;
		protected var _configURL:String = "";
		protected var scaleFactor:int= 2;
		protected var numConnections:uint = 8;
		protected var _assetManager:AssetManager;
		public var onDataComplete:Function;
		public function DataControl(name:String=null,data:Object=null)
		{
			super(name, data);
			_assetManager = new AssetManager(scaleFactor, false);
			_assetManager.numConnections = numConnections;
			_assetManager.verbose = false;
			appConfigLoader = new URLLoader();
			appConfigLoader.addEventListener(Event.COMPLETE, onConfigComplete);
		}
		private function onConfigComplete(e:Event):void 
		{
			appConfigLoader.removeEventListener(Event.COMPLETE,onConfigComplete)
			config = XML(appConfigLoader.data);
		}
		public function loadConfig(url:String):void
		{
			_configURL = url;
			if (_configURL.indexOf("http://") != -1)
			{
				var last:int = _configURL.lastIndexOf("/")
				if (last != -1)
				{
					PATH = _configURL.substr(0, last + 1);
				}
			}else
			{
				var filePath:FilePath = new FilePath(url)
				PATH = filePath.getPath();
			}
			appConfigLoader.load(new URLRequest(url));
		}		
		public function get config():XML 
		{
			return _config;
		}		
		public function set config(value:XML):void 
		{
			_config = value;
			if (_config.scaleFactor.toString() != "")
			{
				scaleFactor = Number(_config.scaleFactor);
				_assetManager.scaleFactor=scaleFactor
			}
			if (_config.numConnections.toString() != "")
			{
				numConnections = Number(_config.numConnections);
				_assetManager.numConnections=numConnections
			}
			loadAppData();
		}
		protected function loadAppData():void
		{
			loadAssets(_config.assets.children());
			loadData(_config.initialdata.children());
			if (_assetManager.numQueuedAssets > 0)
			{
				_assetManager.loadQueue(onDataProgress)
				
			}else
			{
				onDataProgress(1)
			}
		}		
		public function get assetManager():AssetManager 
		{
			return _assetManager;
		}
		
		public function set assetManager(value:AssetManager):void 
		{
			_assetManager = value;
		}
		public function loadAssets(value:XMLList):void
		{
		    var length:int = value.length();
			for (var i:int = 0; i < length; i++)
			{
				var item:Object = { };
				XMLUtil.attributesToObject(value[i], item)
				var url:String = item.url;
				if (url.indexOf("http://") ==-1)
				{
					
					item.url= this.PATH+item.url;
				}
				_assetManager.enqueueWithName(item.url, item.name);
			}
		}
		public function loadData(value:XMLList):void
		{
			var length:int = value.length();
			for (var i:int = 0; i < length; i++)
			{
				var item:Object = { };
				XMLUtil.attributesToObject(value[i], item)
				var url:String = item.url;
				if (url.indexOf("http://") ==-1)
				{
					
					item.url= this.PATH+item.url;
				}
				_assetManager.enqueueWithName(item.url, item.name);
			}
		}
		protected function onDataProgress(value:Number):void
		{
			if (value >= 1)
			{
				if (onDataComplete != null)
				{
					onDataComplete();
				}
				if (this.facade) this.sendNotification(DATA_LOAD_COMPLETE, this);
			}
		}
		override public function onRemove():void 
		{
			super.onRemove();
			appConfigLoader.removeEventListener(Event.COMPLETE, onConfigComplete);
			appConfigLoader = null;
			_assetManager.dispose();
			_assetManager = null;
			trace("清除数据！")
		}
		
	}

}