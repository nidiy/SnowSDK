package snow.app.manager 
{
	import feathers.controls.MessagePrompt;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import snow.app.core.AIRApp;
	import snow.app.core.WebApp;
	
	import feathers.core.PopUpManager;
	import feathers.controls.Alert;
	
	import snow.app.core.App;
	import snow.app.event.BroadCenter;
	import snow.app.event.BroadEvent;
	import snow.http.HttpService;
	import snow.mvc.interfaces.IFacade;
	import flash.utils.setTimeout;
	
	//内置APP
	/**
	 * APP控制器&管理器
	 * 需增加测试模型，从而测试开发者的应用是否符合平台运行
	 * 
	 * 更新 2013年11月25日17
	 * 同时兼容Starling,away3D 及原生应用,外部swf
	 * v3.0 2015-01-16
	 */
	public class AppManage extends EventDispatcher
	{		
		public static const POPUP:String = "popup";
		public static const FULL_SCREEN:String = "fullScreen";	
		
		public static var instance:AppManage = null
		public static function init(_container:flash.display.Sprite):AppManage
		{
			if (instance) return instance;
			instance = new AppManage(_container);
			return instance
		}	
		public var appClassManage:Dictionary; 
		private static var backFunctionHandlers:Array = [];
		private static var backFunction:Function = null;		
		private var stage:Stage;		
		private var appClass:Class;
		private var currentAPP:AppLoader = null;		
		private var container:flash.display.Sprite		
		private var _appRectangle:Rectangle=null
		private var lockCount:uint = 0;		
		private var appRunList:Vector.<AppLoader> = new Vector.<AppLoader>;
		private var moduleRunList:Vector.<AppLoader> = new Vector.<AppLoader>;
		//限制模块同时运行最大容量，等于-1则无限制
		public var maxPopupnum:int = 10;		
		private var appEffect:APPEffectManage
		private var onOpenAppFactory:Function
		private var onCloseAllAppFactory:Function
		private var isInit:Boolean = false;
		private var appRegistry:AppRegistry;
		private var defaultAspectRatio:String=StageAspectRatio.PORTRAIT;
		private var defaultfullScreen:Boolean = false;
		private var currentAspectRatio:String = "";
		private var backKeyCount:int = 0;
		private var isExit:Boolean = false;
		public function AppManage(_container:flash.display.Sprite) 
		{
			super();	
			container = _container;			
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN,nativeStage_keyDownHandler);
			appEffect = new APPEffectManage();
			appEffect.isEffect = true;
		}
		public function addBackFunctions(call:Function):void
		{
			backFunctionHandlers.push(call);
		}
		public function setBackFunction(call:Function):void
		{
			backFunction = call;
		}
		public function initConfig(appClass:Class,stage:Stage,openFactory:Function, closeAllFactory:Function,aspectRatio:String=StageAspectRatio.PORTRAIT):void
		{
			if (isInit) return;
			isInit = true;
			this.stage = stage;
			this.defaultAspectRatio = this.currentAspectRatio=aspectRatio;
			this.appClass = appClass;
			this.appRegistry = AppRegistry.instance;
			this.onOpenAppFactory = openFactory;
			this.onCloseAllAppFactory = closeAllFactory;
		}
		private function nativeStage_keyDownHandler(event:KeyboardEvent):void 
		{
			if(event.isDefaultPrevented())
			{
				return;
			}
			if (PopUpManager.popUpCount>0&&event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				PopUpManager.removePopUpAtIndex(PopUpManager.popUpCount - 1);
				return;
			}
			if(backFunctionHandlers.length>0&&event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				var backFunctionHandler:Function = backFunctionHandlers.pop() as Function;
				if(backFunctionHandler!=null)backFunctionHandler();
				return;
			}
			if (backFunction != null&&event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				backFunction();
				backFunction = null;
				return;
			}
			if (event.keyCode == Keyboard.BACK&&currentAPP != null)
			{
				event.preventDefault();
				closeCurrentAPP(true)
				return;
			}
		}
		private function resetCount():void
		{
			isExit = false;
			backKeyCount = 0;
		}
		public function backHome():void 
		{
			if (currentAPP)
			{
				var appID:String = currentAPP.id;
				var index:int=getRunAppIndex(appID)
				appRunList.splice(index, 1);
				currentAPP.close()
				currentAPP = null;
			}
			closeAllApp();
		}
		/**
		 * 
		 * @param	appID若要打开多个请在主ID后加::然后加上附AppID号如 com.app.home::101 则基于com.app.home再打开一个APP
		 * @param	width   750
		 * @param	height  550
		 * @param	windType=AppLoader.POPUP
		 * @param	data    null
		 * @param	onComplete  null
		 */
		public function openApp(appID:String,data:Object=null,assetURL:String="",windType:String="fullScreen",onComplete:Function=null):AppLoader
		{
			trace("OpenApp_ID::" + appID);
			trace("windType::" + windType);
			var appIDGroup:Array =appID.split("::");
			var ID:String = appIDGroup[0];
			var appItem:Object = appRegistry.getAtIDItem(ID);			
			if (appItem == null) 
			{
				trace("该应用未注册");
				return null;
			}
		    var appURL:String = appItem.url;	
			var aspectRatio:String = appItem.aspectRatio;
			var fullScreen:Boolean = appItem.fullScreen;
			trace("fullScreen::"+fullScreen)
			var appLoder:AppLoader = getRunApp(appID)
			var index:int=getRunAppIndex(appID)
			if (currentAPP&&currentAPP==appLoder)
			{
				currentAPP.data = data;
				currentAPP.run();
				trace("已存在，直接运行！")
				return currentAPP;
			}
			if (windType == AppLoader.FULL_SCREEN) 
			{
				PopUpManager.removeAllPopUps(true);
				if (currentAPP) 
				{
					trace("stop::currentAPP::"+currentAPP.id)
					//currentAPP.pause();
					appEffect.stop(currentAPP);					
				}
			}
			if (appLoder == null)
			{
				appLoder = new AppLoader(container);
				if (appItem.scriptURL) appLoder.scriptURL = appItem.scriptURL;
				appLoder.completeFactory = onComplete;	
				appLoder.appClass = appItem.appClass;	
				appLoder.id = appID;
				appLoder.assetURL = assetURL;
				appLoder.appData = appItem;
				appLoder.data = data;
				appLoder.aspectRatio = aspectRatio;
				appLoder.fullScreen = fullScreen;
				appLoder.appURL = appURL;
				appLoder.windType = windType;
				appRunList.push(appLoder);
				currentAPP = appLoder;
				appLoder.start();
				//appLoder.run();
				if (fullScreen) 
				{
					trace("全屏")
					this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				else 
				{
					trace("不全屏")
					this.stage.displayState = StageDisplayState.NORMAL;
				}
				if (aspectRatio == StageAspectRatio.LANDSCAPE||aspectRatio==StageAspectRatio.PORTRAIT)
				{
					setAspectRatio(aspectRatio,appEffect.open,appLoder)				
				}else
				{
					appEffect.open(appLoder)
				}
				refreshAppSize();
				//appEffect.open(appLoder)
				
			}else
			{
				//已挂起
				appLoder.data = data;
	        	currentAPP = appLoder;
				if (fullScreen) this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				else this.stage.displayState = StageDisplayState.NORMAL;
			    if (aspectRatio == StageAspectRatio.LANDSCAPE||aspectRatio==StageAspectRatio.PORTRAIT)
				{
					setAspectRatio(aspectRatio,appEffect.open,appLoder)				
				}else
				{
					appEffect.open(appLoder)
				}
				//currentAPP.run()
				//appEffect.open(appLoder);
				appRunList.removeAt(index);
				appRunList.push(appLoder);
				refreshAppSize()
				
			}
			if (this.onOpenAppFactory != null)
			{
				this.onOpenAppFactory(windType);
			}
			BroadCenter.dispatcher.dispatchEvent(new BroadEvent(BroadEvent.APP_OPEN_COMPLETE, appItem))
			return currentAPP;
			
		}
		public function openAppAtData(appItem:Object,data:Object=null):AppLoader
		{		
		    var appURL:String = appItem.url;	
			var aspectRatio:String = appItem.aspectRatio;
			var fullScreen:Boolean = appItem.fullScreen;
			var appLoder:AppLoader = new AppLoader(container);
			if (appItem.scriptURL) appLoder.scriptURL = appItem.scriptURL;
			appLoder.appClass = appItem.appClass;	
			appLoder.id = appItem.id;
			appLoder.data = data;
			appLoder.aspectRatio = aspectRatio;
			appLoder.fullScreen = fullScreen;
			appLoder.appURL = appURL;
			appLoder.start();
			appLoder.run();
			return appLoder;
		}
		/**
		 * 关闭当前APP
		 */
		public function closeCurrentAPP(isPrompt:Boolean=false):void
		{
			if (currentAPP) closeApp(currentAPP.id,isPrompt);
		}
		/**
		 * 关闭所有APP
		 */
		public function closeAllApp():void
		{
			while (appRunList.length) 
			{
				appRunList[0].stop();
				appRunList[0].close();
				appRunList.shift();
			}
			currentAPP = null;
			if (defaultAspectRatio == StageAspectRatio.LANDSCAPE||defaultAspectRatio==StageAspectRatio.PORTRAIT)
			{
				setAspectRatio(defaultAspectRatio, onCloseAllAppFactory);
			}
			BroadCenter.dispatcher.dispatchEvent(new BroadEvent(BroadEvent.APP_ALL_CLOSE))
		}
		/**
		 * 关闭APP
		 * @param	appID  要关闭的应用ID
		 * @param	isPrompt  关闭前是否提示? 
		 */
		public function closeApp(appID:String,isPrompt:Boolean=false):void
		{
		
			var appLoder:AppLoader = getRunApp(appID)			
			if (isPrompt)
			{
				//提示是否关闭后再确认关闭
				trace("是否退出???")
			}	
			if (appLoder == null) return;
			var index:int = getRunAppIndex(appID)
            if (appLoder != null) 
			{
				if (appLoder.windType ==AppLoader.POPUP)
				{
					//appLoder.pause();
					appEffect.stop(appLoder)
					currentAPP = null;
					if (index > 0)
					    currentAPP = appRunList[index - 1];
					return;
					
				}else
				{
					//appLoder.close();
					appRunList.removeAt(index);
					appEffect.close(appLoder)
				}
			}
			appLoder = null;
			if (appRunList.length > 0)
			{
				for (var i:int =0; i <appRunList.length; i++) 
				{
					appLoder = appRunList[i];					
					if (appLoder.windType!=AppLoader.POPUP)
					{
						break;
					}
				}
				if (appLoder.windType == AppLoader.POPUP) 
				{
					currentAPP = null;
					backHome()
					return;
				}
				var aspectRatio:String = appLoder.aspectRatio;
				var fullScreen:Boolean = appLoder.fullScreen;
				var tempData:Object = { };
				tempData.appID = appLoder.id;
				tempData.data = appLoder.data;
				tempData.windType = appLoder.windType
				tempData.aspectRatio = appLoder.aspectRatio
				tempData.fullScreen = appLoder.fullScreen;
				currentAPP = appLoder;
				if (!currentAPP.isSupporter) currentAPP.start();
				refreshAppSize();
				if (fullScreen) this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				else this.stage.displayState = StageDisplayState.NORMAL;
				//appLoder.run();
				if (aspectRatio == StageAspectRatio.LANDSCAPE||aspectRatio==StageAspectRatio.PORTRAIT)
				{
					setAspectRatio(aspectRatio,appEffect.open,appLoder)	
					
				}else
				{
					appEffect.open(appLoder);
				}
				//appEffect.open(appLoder)
				BroadCenter.dispatcher.dispatchEvent(new BroadEvent(BroadEvent.APP_OPEN_COMPLETE, tempData))
				
			}else
			{
				currentAPP=null;
				backHome()
			}
		}
		protected function getRunApp(appID:String):AppLoader
		{
			var length:int=appRunList.length
			for (var i:int = 0; i <length; i++) 
			{
				if (appRunList[i].id == appID)
				{
					return appRunList[i]
				}
			}
			return null;
		}
		protected function getRunAppIndex(appID:String):int
		{
			var length:int=appRunList.length
			for (var i:int = 0; i <length; i++) 
			{
				if (appRunList[i].id == appID)
				{
					return i;
				}
			}
			return -1;
		}
		/**
		 * 渲染所有已打开的应用
		 */
		public function onRender():void
		{
			var length:int = appRunList.length;
			for (var i:int = 0; i <length; i++) 
			{
				appRunList[i].onRender();
			}
		}
		public function refreshAppSize():void
		{
			if (currentAPP&&currentAPP.app)
			{
				//currentAPP.app.x = appRectangle.x;
				//currentAPP.app.y = appRectangle.y;
				currentAPP.app.setSize(appRectangle.width,appRectangle.height);
			}
		}	
		public function get appRectangle():Rectangle 
		{
			return _appRectangle;
		}
		
		public function set appRectangle(value:Rectangle):void 
		{
			_appRectangle=value;
		}	
		private var timeID:uint=0;
		/**
		 * 设置屏幕横纵
		 * @param aspectRatio:String 请传入 flash.display.StageAspectRatio 中的枚举
		 * @param onOrientationChange:Function 屏幕横纵设置成功的回调函数，此函数必须接受 Event 对象作为其唯一的参数，并且不能返回任何结果，如下面的示例所示： function(event:flash.events.StageOrientationEvent):void
		 * @return 设备是否支持设置屏幕横纵 (flash.display.Stage.supportsOrientationChange)
		 */
		public function setAspectRatio(aspectRatio:String,callback:Function = null,params:AppLoader=null):void
		{
			trace("aspectRatio::"+aspectRatio)
			if(currentAspectRatio==aspectRatio)
			{
				if (callback != null) 
				{
					if(callback.length)callback(params);
					else callback();
				}
				return;
			}
			currentAspectRatio=aspectRatio;
			trace("supportsOrientationChange::"+Stage.supportsOrientationChange);
			if (Stage.supportsOrientationChange)
			{
				timeID=setTimeout(onOrientationChange,100)
				stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange);
				stage.setAspectRatio(aspectRatio);				
				trace("setAspectRatio")
				trace("timeID::"+timeID)
				
			}else{
				
				if (callback != null) 
				{
					if(callback.length)callback(params);
					else callback();
				}
				return;
			}			
			function onOrientationChange(e:Event=null):void
			{
				trace("onOrientationChange");
				stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE,onOrientationChange);
				trace("clear:timeID"+timeID);
				clearTimeout(timeID)				
				if (callback != null) 
				{
					refreshAppSize();
					trace("callback::"+callback.length);
					trace("params::"+params);
					if(callback.length)callback(params);
					else callback();
					//refreshAppSize()
				}
			}
		}
		
	}

}