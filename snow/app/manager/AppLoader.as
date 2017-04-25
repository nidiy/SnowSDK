package snow.app.manager 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import snow.app.core.AScriptWebApp;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import snow.app.core.App;
	import snow.app.event.AppEvent;
	import snow.app.event.BroadCenter;
	import snow.app.event.BroadEvent;
	/**
	 * APP加载器
	 * @author HBinNet
	 */
	public class AppLoader extends EventDispatcher 
	{
		
		public static const POPUP:String = "popup";
		public static const FULL_SCREEN:String = "fullScreen";
		
		public var level:int = AppLevel.USER_LEVEL;	
		public var appData:Object = null;
		public var appURL:String;
		public var scriptURL:String;
		public var assetURL:String = "";
		public var aspectRatio:String;
		public var fullScreen:Boolean = false;
		public var app:App;		
		private var _id:String;
		public var completeFactory:Function = null;
		public var closeFactory:Function = null;
		public var bitmapData:BitmapData = null;
		public var windType:String = "fullScreen";
		public var isSupporter:Boolean = true;
		public var appClass:Class;
		public var maxWidth:Number = 500;
		public var maxHeight:Number = 400;
		
		protected var loader:Loader
		protected var _data:Object = null		
		protected var root:Sprite
		protected var lock:Boolean = true;
		public function AppLoader(root:Sprite) 
		{
			this.root = root;
		}
		/**
		 * 数据
		 */
		public function get data():Object 
		{
			return _data;
		}		
		public function set data(value:Object):void 
		{
			if (_data != null)
			{
				//_data = Handle.unionObject(_data, value)
				return;
			}
			_data = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
			if (app) app.id = _id;
		}
		/**
		 * 开始APP
		 */
		public function start():void
		{
			stop();
			app = new appClass();
			if (app is AScriptWebApp)
			{
				AScriptWebApp(app).scriptURL = scriptURL;
			}
			app.assetURL = assetURL;
			app.appURL = appURL
			app.windType = this.windType;
			app.id = this.id;
			app.initData = _data;
			app.addEventListener(AppEvent.APP_COMPLETE, onAppComplete)
		}
		private function onAppComplete(e:AppEvent):void 
		{
			if (completeFactory != null) completeFactory(this);
		}
		/**
		 * 运行APP
		 */
		public function run():void
		{
			if (app)
			{
				app.lock = false;
				app.activation = true
				app.mouseEnabled = true;
				app.initData = _data;
				app.updata()
				app.play()
				if (!root.contains(app))
				{
					root.addChild(app)				
				}				
			}
		}
		/**
		 * 停止APP
		 */
		public function stop():void
		{
			if (app!=null)
			{
				pause();
				app.removeEventListener(AppEvent.APP_COMPLETE,onAppComplete)
				app.dispose();
				app = null;
			}
		}
		/**
		 * 暂停APP
		 */
		public function pause():void
		{
			if (app!=null)
			{
				app.pause();
				app.lock = true
				app.activation = false
				app.mouseEnabled = false;
				var isContains:Boolean=root.contains(app)
				if (isContains) root.removeChild(app);
			}
		}
		/**;
		 * 关闭APP
		 */
		public function close():void
		{
			if (bitmapData)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
			stop();
			if (closeFactory != null) closeFactory();
			BroadCenter.dispatcher.dispatchEvent(new BroadEvent(BroadEvent.APP_CLOSE_COMPLETE, appData))
			
		}
		/**
		 * 获取截图
		 * @return
		 */
		public function snapshot():BitmapData
		{
			return app.snapshot();
		}
		public function onRender():void
		{
			if (app != null)
			{
				app.onRender();
			}
		}
		
	}

}