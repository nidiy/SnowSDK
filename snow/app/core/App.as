package snow.app.core 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import snow.app.controller.AppController;
	import snow.app.core.Info;
	import snow.app.manager.AppManage;
	import snow.mvc.core.Controller;
	import snow.mvc.core.Model;
	import snow.mvc.core.View;
	import snow.mvc.interfaces.IController;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.IMediator;
	import snow.mvc.interfaces.IModel;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.IProxy;
	import snow.mvc.interfaces.IView;
	import snow.mvc.patterns.observer.Notification;
	
	import starling.events.Event;

	/**
	 * App基类
	 * @author Tim
	 */
	public class App extends AppSprite implements IApplication,IAppSprite
	{
		
		public static var CURRENT_APP_PATH:String = ""		
			
		public static const MID:String = "mid";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		
		
		public static const SWITCH_MOD_NULL:uint = 0;
		public static const SWITCH_MOD_1:uint = 1;
		public static const SWITCH_MOD_2:uint = 2;
		
		public var switchMod:uint = 0;
		
		protected static var instance:IFacade;		
		protected var appControllers:Vector.<AppController>
		protected var _controller:IController;
		protected var _model:IModel;
		protected var _view	:IView;		
		protected var _path:String;
		private var _assetURL:String="";
		protected var _index:int = 0;
		protected var _info:Info
		protected var _initData:Object = null;
		protected var _id:String = ""
		protected var _appURL:String
		
		public var windType:String
		public var onAppComplete:Function=null;
		public var onDataComplete:Function = null;
		public var onProgress:Function=null;
		public var onRegisterApp:Function = null;
		public var onRegister:Function = null;
		public var onCloseFactory:Function = null;
		
		public var onPauseFactory:Function = null;
		public var onPlayFactory:Function = null;
		public var onStopFactory:Function = null;
		public var onDisposeFactory:Function = null;
		public var startTime:Number = 0;
		public var compileTime:Number = 0;
		public function App() 
		{
			super()
			appControllers = new Vector.<AppController>
		}
		public function close():void
		{
			if(AppManage.instance)
			{
			    setTimeout(AppManage.instance.closeApp,70,id)
			}
			//AppManage.instance.closeApp(id);
			//if (onCloseFactory != null) onCloseFactory();
		}
	    public function set path(value:String):void
	    {
		   if (_path == value) return;
		   _path = value;
	    }
		public function get path():String
		{
			return _path
		}
	    public function set indexAt(value:int):void
		{
			if (_index == value) return;
			_index = value;
		}
		public function get indexAt():int
		{
			return _index
		}		
		override public function set activation(value:Boolean):void 
		{
			super.activation = value;
			for (var i:int = 0; i < appControllers.length; i++) 
			{
				appControllers[i].activation = value;
			}
		}
	    public function set info(value:Info):void
		{
			if (_info == value) return;
			_info = value;
		}
		public function get info():Info
		{
			return _info
		}
		public function pause():void
		{
			if (onPauseFactory != null) onPauseFactory();
		}
		public function stop():void
		{
			if (onStopFactory != null) onStopFactory();
		}
		public function play():void	
		{
			if (onPlayFactory != null) onPlayFactory();
		}
		protected function initializeFacade(  ):void {
			initializeModel();
			initializeView();
			initializeController();
		}
		public static function getInstance():IFacade {
			instance = new App( );
			return instance;
		}
		protected function initializeController():void {
			controller = Controller.getInstance();
			controller.facade = this;
		}
		protected function initializeModel():void {
			model = Model.getInstance();
			model.facade = this;
		}
		protected function initializeView():void {
			view = View.getInstance();
			view.facade = this;
		}
		/**
		 * 注册一个控制器
		 * @param	notificationName
		 * @param	commandClassRef
		 */
		public function registerCommand(notificationName:String,commandClassRef:Class ):void 
		{
			if (commandClassRef == null) return;
			controller.registerCommand(notificationName,commandClassRef);
		}
		public function removeCommand(notificationName:String ):void 
		{
			controller.removeCommand(notificationName );
		}
		public function hasCommand(notificationName:String ) : Boolean
		{
			return controller.hasCommand(notificationName);
		}
		public function registerProxy ( proxy:IProxy ):void	
		{
			model.registerProxy ( proxy );	
		}
		public function retrieveProxy ( proxyName:String ):IProxy 
		{
			return model.retrieveProxy ( proxyName );	
		}
		public function removeProxy ( proxyName:String ):IProxy 
		{
			var proxy:IProxy;
			if ( model != null) proxy = model.removeProxy ( proxyName );
			return proxy
		}
		public function hasProxy( proxyName:String ) : Boolean
		{
			return model.hasProxy( proxyName );
		}
		public function registerMediator( mediator:IMediator ):void 
		{
			if ( view != null ) view.registerMediator( mediator );
		}
		public function retrieveMediator( mediatorName:String ):IMediator 
		{
			return view.retrieveMediator( mediatorName ) as IMediator;
		}
		public function removeMediator( mediatorName:String ) : IMediator 
		{
			var mediator:IMediator;
			if ( view != null ) mediator = view.removeMediator( mediatorName );			
			return mediator;
		}
		public function hasMediator( mediatorName:String ) : Boolean
		{
			return view.hasMediator( mediatorName );
		}
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			notifyObservers( new Notification( notificationName, body, type ) );
		}
		public function notifyObservers ( notification:INotification ):void {
			if ( view != null ) view.notifyObservers( notification );
		}		
		public function get controller():IController 
		{
			return _controller;
		}		
		public function set controller(value:IController):void 
		{
			_controller = value;
		}		
		public function get model():IModel 
		{
			return _model;
		}		
		public function set model(value:IModel):void 
		{
			_model = value;
		}		
		public function get view():IView 
		{
			return _view;
		}		
		public function set view(value:IView):void 
		{
			_view = value;
		}
		
		public function get initData():Object 
		{
			return _initData;
		}
		
		public function set initData(value:Object):void 
		{
			_initData = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
			if (_info)_info.id = _id;
		}		
		public function get appURL():String 
		{
			return _appURL;
		}		
		public function set appURL(value:String):void 
		{
			_appURL = value;
		}
		public function addControll(value:AppController):void
		{
			appControllers.push(value)
			draw()
		}
		override public function onRender():void 
		{
			if (_lock) return;
			if (appControllers == null) return;
			for (var i:int = 0; i < appControllers.length; i++) 
			{
				appControllers[i].onRender();
			}
		}
		override public function set lock(value:Boolean):void 
		{
			_lock = value;
			for (var i:int = 0; i < appControllers.length; i++) 
			{
				appControllers[i].lock = _lock;
			}
		}	
		/**
		 * 资源路径 如 app-storage:/game/gameID/   应用专署目录下的资源
		 */
		public function get assetURL():String 
		{
			return _assetURL;
		}		
		public function set assetURL(value:String):void 
		{
			_assetURL = value;
		}
		public function refreshScale():void 
		{
			for (var i:int = 0; i < appControllers.length; i++) 
			{
				appControllers[i].refreshScale();
			}
		}
		override protected function draw():void 
		{
			super.draw();
			if(!_autoSize) return;
			for (var i:int = 0; i < appControllers.length; i++) 
			{
				var ctl:AppController = appControllers[i];
				ctl.x = this.x;
				ctl.y = this.y;
				trace("draw:",this.x,this.y)
				ctl.width = this.width;
				ctl.height = this.height;
			}
		}
		/**
		 * 截取当前APP的画面  
		 * @return BitmapData
		 */
		public function snapshot():BitmapData
		{
			if(this.stage3DProxy==null)
			{
				_bitmapData = new BitmapData(this.width, this.height, false, 0);
				return _bitmapData;
			}
			_bitmapData = new BitmapData(this.width, this.height, false, 0);
			this.stage3DProxy.context3D.clear();
			this.onRender();
			this.stage3DProxy.context3D.drawToBitmapData(_bitmapData);
			this.stage3DProxy.present();
			return _bitmapData;
		}
		override public function dispose():void 
		{
			_lock = true;
			if (onDisposeFactory != null)
			{
				onDisposeFactory();
			}
			while (appControllers.length) 
			{
				appControllers.pop().dispose();
			}
			appControllers.length = 0;
			appControllers = null;
			onAppComplete=null;
			onDataComplete = null;
			onProgress=null;
			onRegisterApp = null;
			onRegister = null;
			onCloseFactory = null;		
			onPauseFactory = null;
			onPlayFactory = null;
			onStopFactory = null;
			onDisposeFactory = null;
		    instance = null;	
			_controller = null;
			_model = null;
			_view=null;	
			super.dispose();
		}
		override protected function onInitStage(e:flash.events.Event):void 
		{
			super.onInitStage(e);
		}
		override protected function onRemovedStage(e:flash.events.Event):void 
		{
			super.onRemovedStage(e);
		}		
		//以下为对外接口		
		/**
		 * 打开应用
		 */
		public function openApp(appID:String,data:Object=null,assetUrl:String="",windType:String="fullScreen"):void
		{
			if (AppManage.instance) AppManage.instance.openApp(appID, data, assetUrl, windType);
		}
		/**
		 * 关闭应用
		 */
		public function closeApp(id:String):void
		{
			if(AppManage.instance)
			{
				setTimeout(AppManage.instance.closeApp,70,id)
			}
			//AppManage.instance.closeApp(id);
		}
		/**
		 * 新的窗口打开WebView
		 */
		public function openWeb(value:Object):void
		{
			stop()
		}		
		private function onWebClose(e:starling.events.Event):void 
		{
			play()
		}
		protected function onWebComplete(value:Object):void 
		{
			play()
		}
	}

}