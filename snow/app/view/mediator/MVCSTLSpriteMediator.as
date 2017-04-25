package snow.app.view.mediator 
{
	import flash.geom.Point;
	
	import snow.app.core.App;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * ...
	 * @author HBin
	 */
	public class MVCSTLSpriteMediator extends Sprite implements IStarlingMediator,INotifier 
	{
		public static const NAME:String = 'MVCSTLSpriteMediator';
		private static var  index:int = 0;
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
		
		public function MVCSTLSpriteMediator(mediatorName:String=null, viewComponent:Object=null) 
		{
			super();
			this.mediatorName = (mediatorName != null) ? mediatorName : NAME+index;
			this.viewComponent = viewComponent;
			index++;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(TouchEvent.TOUCH, onTouchHandler);
		}
		
		protected var touchPointID:int = -1;
		private function onTouchHandler(event:TouchEvent):void 
		{
			var touch:Touch = event.getTouch(this, null, this.touchPointID);
			if (touch==null)
			{
				//可以交互
			    this.sendNotification("isInteractive", true);
				return;
			}
			if(touch.phase == TouchPhase.ENDED)
			{
				//可以交互
				this.sendNotification("isInteractive", true);
			}
			else
			{
				this.sendNotification("isInteractive",false);
				//不可以交互
			}
		}
		public function updata():void
		{
			if (updataFactory != null) updataFactory();
		}
		public function onRender():void
		{
			if (!_lock && onRenderFactory!=null)
			{
				onRenderFactory();
			}
		}
		public function sendNotification(notificationName:String,body:Object=null,type:String=null ):void 
		{
			facade.sendNotification(notificationName,body,type);
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
		public function get lock():Boolean 
		{
			return _lock;
		}		
		public function set lock(value:Boolean):void 
		{
			if (_lock == value) return;
			_lock = value;
			if (_lock)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
			}
			else
			{
				this.addEventListener(TouchEvent.TOUCH, onTouchHandler);
			}
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
			
			if (handleNotificationFactory!=null) handleNotificationFactory(notification);
		}
		public function onRegister():void
		{
			var app:App = this._facade as App;
			if (app.onRegister != null) app.onRegister(this);
		}
		public function onRemove():void
		{
			if (onRemoveFactory!=null) onRemoveFactory();
		}
		public function setSize(newWidth:Number, newHeigth:Number):void
		{
			return;
		}
		override public function dispose():void 
		{
			this.removeEventListener(TouchEvent.TOUCH, onTouchHandler);
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