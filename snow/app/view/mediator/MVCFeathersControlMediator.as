package snow.app.view.mediator 
{
	import flash.geom.Point;
	import starling.display.DisplayObjectContainer;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.core.DefaultPopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	
	import snow.app.core.App;
	import snow.app.manager.AppLoader;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.rendering.Painter;

	/**
	 * ...
	 * @author HBin
	 */
	public class MVCFeathersControlMediator extends Screen implements IStarlingMediator,INotifier 
	{
		public static const NAME:String = 'MVCFeathersControlMediator';
		private static var  index:int=0;
		public static var isInitSkin:Boolean = false;
		public var notification:Array = [];
		public var handleNotificationFactory:Function = null;
		public var refreshSizeFactory:Function = null;
		public var drawFactory:Function = null;
		public var updataFactory:Function = null;
		public var onRemoveFactory:Function = null;
		public var onRenderFactory:Function = null;
		protected var _facade:IFacade
		protected var _lock:Boolean = false;
		protected var _activation:Boolean = true;
		protected var _autoSize:Boolean = true;
		public function get autoSize():Boolean{return _autoSize;}
		public function set autoSize(value:Boolean):void{_autoSize = value;}
		
		public function MVCFeathersControlMediator(mediatorName:String=null, viewComponent:Object=null) 
		{
			super();
			this.mediatorName = (mediatorName != null)?mediatorName:NAME+index; 
			this.viewComponent = viewComponent;			
			index++;
			//DefaultPopUpManager.dispatcher.addEventListener(Event.OPEN,onPopUpManagerOpen)
			//DefaultPopUpManager.dispatcher.addEventListener(Event.CLOSE,onPopUpManagerClose)
		}
		override protected function feathersControl_addedToStageHandler(event:Event):void 
		{
			super.feathersControl_addedToStageHandler(event);
			if (this.stage != null) this.stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
			if (this.stage != null) this.stage.addEventListener(FeathersEventType.RESIZE, stageResizeHandler);
		}
		override protected function feathersControl_removedFromStageHandler(event:Event):void 
		{
			super.feathersControl_removedFromStageHandler(event);
			this.stage.removeEventListener(FeathersEventType.RESIZE,stageResizeHandler)
		}
		override protected function initialize():void 
		{
			super.initialize();
			this.width = this.stage.stageWidth;
			this.height = this.stage.stageHeight;
		}		
		private function stageResizeHandler(e:Event):void 
		{
			this.setSize(this.stage.stageWidth, this.stage.stageHeight);
		}
	    private static const HELPER_POINT:Point = new Point();
		protected var touchPointID:int = -1;
		private function onTouchHandler(event:TouchEvent):void 
		{
			var touch:Touch = event.getTouch(this, null, this.touchPointID);
			if(touch==null)
			{
				//可以交互
			    this.sendNotification("isInteractive", true);
				return;
			}else
			{
				this.sendNotification("isInteractive", false);
				return;
			}
		}
		public function updata():void
		{
			if (updataFactory != null) updataFactory();
		}
		public function onRender():void
		{
			if (!_lock)
			{
				if (onRenderFactory!=null)
				{
					onRenderFactory()
				}
			}
		}
		override protected function draw():void 
		{
			super.draw()
			if (drawFactory != null) drawFactory();
			if (this.isInvalid(INVALIDATION_FLAG_SIZE))
			{
				refreshSize();
			}
		}
		protected function refreshSize():void
		{
			if (refreshSizeFactory != null) refreshSizeFactory();
		}
		public function sendNotification( notificationName:String,body:Object=null,type:String=null ):void 
		{
			if (facade)
			    facade.sendNotification(notificationName, body, type);
		}	
		public function get facade():IFacade 
		{
			return _facade;
		}		
		public function set facade(value:IFacade):void 
		{
			if (_facade == value) return;
			_facade = value;
			var app:App = this._facade as App;
			if (app.onRegisterApp != null) app.onRegisterApp(this);
			
		}		
		private function onPopUpManagerClose(e:Event):void 
		{
			this.touchable = true;
			this.sendNotification("isInteractive", true);
			if (this.stage) this.stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
		}
		
		private function onPopUpManagerOpen(e:Event):void 
		{
			this.sendNotification("isInteractive", false);
			this.touchable = false;
			if (this.stage) this.stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
		}
		public function get lock():Boolean 
		{
			return _lock;
		}
		private var _pContainer:DisplayObjectContainer
		public function set lock(value:Boolean):void 
		{
			if (_lock == value) return;
			_lock = value;
			if (_lock)
			{
				_pContainer = this.parent;
				if (_pContainer)
				{
					_pContainer.removeChild(this);
				}
				//DefaultPopUpManager.dispatcher.removeEventListener(Event.OPEN,onPopUpManagerOpen)
			    //DefaultPopUpManager.dispatcher.removeEventListener(Event.CLOSE, onPopUpManagerClose)
				if (stage) stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler)
			}
			else
			{
				if (_pContainer)
				{
					_pContainer.addChild(this);
				}
				if (stage) this.stage.addEventListener(TouchEvent.TOUCH, onTouchHandler);
			    //DefaultPopUpManager.dispatcher.addEventListener(Event.OPEN,onPopUpManagerOpen)
			    //DefaultPopUpManager.dispatcher.addEventListener(Event.CLOSE, onPopUpManagerClose)
			}
			this.invalidate(INVALIDATION_FLAG_STATE)
		}
		public function get activation():Boolean 
		{
			return _activation;
		}
		
		public function set activation(value:Boolean):void 
		{
			if (_activation == value) return;
			_activation = value;
			this.touchable = _activation;
			this.invalidate(INVALIDATION_FLAG_STATE)
		}
		public function getMediatorName():String 
		{	
			return mediatorName;
		}
		public function setViewComponent( viewComponent:Object ):void 
		{
			this.viewComponent = viewComponent;
		}	
		public function getViewComponent():Object
		{	
			return viewComponent;
		}
		public function listNotificationInterests():Array 
		{
			return notification;
		}
		public function handleNotification(notification:INotification):void {	
			
			if(handleNotificationFactory!=null)handleNotificationFactory(notification)					
		}
		public function onRegister():void
		{
			var app:App = this._facade as App;
			if (app.windType == AppLoader.POPUP)
			{
				//trace("app.windType::"+app.windType);
				this.layout = new VerticalLayout()
				VerticalLayout(layout).horizontalAlign = HorizontalAlign.CENTER;
				VerticalLayout(layout).verticalAlign = VerticalAlign.MIDDLE;
				this.backgroundSkin = new Quad(10, 10, 0x000000)
				this.backgroundSkin.alpha = 0.3;
			}
			if (app.onRegister != null) app.onRegister(this);
		}
		public function onRemove():void
		{
			if(onRemoveFactory!=null)onRemoveFactory()
		}
		override public function dispose():void 
		{
			if (this.stage)
			{
				this.stage.removeEventListener(TouchEvent.TOUCH, onTouchHandler)
			}
		    this.removeEventListener(TouchEvent.TOUCH, onTouchHandler)	
			//DefaultPopUpManager.dispatcher.removeEventListener(Event.OPEN,onPopUpManagerOpen)
			//DefaultPopUpManager.dispatcher.removeEventListener(Event.CLOSE,onPopUpManagerClose)
			if (_facade)
			{
				_facade.removeMediator(mediatorName);
				_facade = null;
			}
			else
			{
				onRemove();
			}
			super.dispose();
			
		}
		protected var mediatorName:String;
		protected var viewComponent:Object;
		
		
		public function getStarling():Starling
		{
			return stage==null ? null : stage.starling;
		}
		
	}

}