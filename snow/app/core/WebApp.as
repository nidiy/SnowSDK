package snow.app.core
{
	import es.xperiments.media.StageWebViewBridge;
	import es.xperiments.media.StageWebViewBridgeEvent;
	import es.xperiments.media.StageWebViewDisk;
	import es.xperiments.media.StageWebviewDiskEvent;
	import feathers.core.DefaultPopUpManager;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.events.Event;
	
	/**
	 * 这是一个专门装载网页应用的类
	 *
	 * @author
	 */
	public class WebApp extends App
	{
		private static var isInitialize:Boolean = false;
		public var webview:StageWebViewBridge
		public var onDeviceReady:Function = null;
		
		public function WebApp()
		{
			super();
		}
		
		override protected function initMilieu():void
		{
			super.initMilieu();
			if (StageWebViewDisk.stage==null)
			{
				StageWebViewDisk.addEventListener(StageWebviewDiskEvent.END_DISK_PARSING, endDiskParsingHandler);
				StageWebViewDisk.addEventListener(StageWebviewDiskEvent.START_DISK_PARSING, StartDiskParsingHandler);
				StageWebViewDisk.setDebugMode(false);
				StageWebViewDisk.initialize(this.stage);
			}
			webview = new StageWebViewBridge(this.x, this.y, this.width, this.height);
			webview.addCallback("___onDeviceReady", onDeviceReadyHandler);
			webview.addCallback("___onDomReady", onDomReadyHandler);
			webview.addCallback("___getFilePaths", getFilePathsHandler);
			webview.addCallback('closeApp', this.close);
			webview.addCallback('openApp', this.openApp);
			//注册接口方法	
			webview.addEventListener(StageWebViewBridgeEvent.ON_GET_SNAPSHOT, onGetSnapshotHandler);
			webview.addEventListener(flash.events.Event.COMPLETE, onWebViewComplete);
			webview.addEventListener(flash.events.Event.ADDED_TO_STAGE, onWebViewAddToStage);
		    var variables:URLVariables = null;
			if (_initData)
			{
				variables=new URLVariables();
				for (var key:String in _initData)
					variables[key]=_initData[key];
			}
			trace("WebApp::"+_appURL + "?" + variables)
			if (_appURL.indexOf("applink:/") != -1)
			{
				if (variables == null) webview.loadLocalURL(_appURL);
				else webview.loadLocalURL(_appURL + "?" + variables);
			}
			else
			{
				if (variables == null) webview.loadURL(_appURL);
				else webview.loadURL(_appURL + "?" + variables);
			}
			this.addChild(webview);
			draw();
			onAppComplete && onAppComplete();
		}		
		override public function play():void
		{
			super.play();
			if (webview) webview.visible = true;
		}		
		override public function pause():void
		{
			super.pause();
			if (webview) webview.visible = false;
		}
		
		override public function stop():void
		{
			super.stop();
			if (webview) webview.visible = false;
		}
		
		/**
		 * 双向连接建立并且JS开始工作
		 */
		protected function onDeviceReadyHandler():void
		{
			trace("双向连接建立并且JS开始工作");
			onDeviceReady && onDeviceReady();
		}
		
		/**
		 * DOMContentLoaded触发时
		 */
		protected function onDomReadyHandler(obj:Object = null):void
		{
			trace("DOMContentLoaded触发时" + obj);
		}
		
		/**
		 *从javascript上的document.DOMContentLoaded调用
		 *设置要在JScode中使用的fileDirectories路径和缓存扩展。
		 */
		protected function getFilePathsHandler():Object
		{
			trace("获取文件目录");
			return {
				rootPath: StageWebViewDisk.getRootPath(),
				sourcePath: StageWebViewDisk.getSourceRootPath(), 
				docsPath: File.documentsDirectory.url, 
				extensions: StageWebViewDisk.getCachedExtensions()
			};
		}
		
		protected function StartDiskParsingHandler(e:StageWebviewDiskEvent):void
		{
		
		}
		
		protected function endDiskParsingHandler(e:StageWebviewDiskEvent):void
		{
		
		}
		
		protected function onWebViewAddToStage(e:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onWebViewAddToStage);
			draw();
		}
		
		protected function onWebViewComplete(e:flash.events.Event):void
		{
			webview.removeEventListener(flash.events.Event.COMPLETE, onWebViewComplete);
			this.dispatchEvent(e.clone())
			trace("网页加载完成！")
			draw();
		}
		
		/**
		 * webview快照完成
		 * @param	e
		 */
		protected function onGetSnapshotHandler(e:StageWebViewBridgeEvent):void
		{
			trace("快照完成")
		}
		
		override public function dispose():void
		{
			if (webview)
			{
				if (this.contains(webview)) this.removeChild(webview);
				webview.dispose()
				webview = null
			}
			super.dispose();
		}		
		/**
		 * 生成快照
		 * @return
		 */
		override public function snapshot():BitmapData
		{
			webview.getSnapShot();
			return webview.bitmapData;
		}
		
		override protected function draw():void
		{
			super.draw()
			if (webview)
			{
				trace("webview::"+this.x)
				webview.x = this.x;
				webview.y = this.y;
				webview.setSize(this.width, this.height)
			}
		}
	}
}