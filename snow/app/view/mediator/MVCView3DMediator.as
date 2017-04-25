package snow.app.view.mediator 
{
	import away3d.containers.View3D;
	
	import snow.app.core.App;
	import snow.app.core.View3DBase;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;

	/**
	 * ...
	 * @author HBin
	 */
	public class MVCView3DMediator extends View3DBase implements IView3DMediator,INotifier
	{
		public static const NAME:String = 'MVCView3DMediator';	
		private static var  index:int = 0;
		public var notification:Array = ["isInteractive"];
		public var handleNotificationFactory:Function = null;
		public var refreshSizeFactory:Function = null;
		public var drawFactory:Function = null;
		public var updataFactory:Function = null;
		public var onRemoveFactory:Function = null;
		public var onRenderFactory:Function = null;
		protected var _facade:IFacade;
		
		public function MVCView3DMediator(mediatorName:String=null,viewComponent:Object=null) 
		{
			super()
			this.mediatorName = (mediatorName != null) ? mediatorName : NAME+index;
			this.viewComponent = viewComponent;	
			index++;
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
		public function handleNotification( notification:INotification ):void
		{
			if (handleNotificationFactory != null) handleNotificationFactory(notification)
			if (notification.getName() == "isInteractive")
			{
				this.activation= notification.getBody();
			}
		}
		public function onRegister():void 
		{
			var app:App = this._facade as App;
			if (app.onRegister!= null) app.onRegister(this);
		}
		override public function dispose():void 
		{
			if (_facade)
			{
				_facade.removeMediator(mediatorName);
				_facade = null;
			}else
			{
				onRemove();
			}
			super.dispose();			
			handleNotificationFactory = null;
			refreshSizeFactory = null;
			drawFactory = null;
			updataFactory = null;
			onRemoveFactory = null;
			onRenderFactory = null;
		}
		public function onRemove():void
		{
			if(onRemoveFactory!=null)onRemoveFactory()
		}
		override protected function draw():void 
		{
			super.draw();
			if (drawFactory != null) drawFactory();
			if (refreshSizeFactory != null) refreshSizeFactory();
		}
		override public function updata():void 
		{
			if (updataFactory != null) updataFactory();
		}
		override public function onRender():void 
		{
			super.onRender();
			if (onRenderFactory != null) onRenderFactory();
		}		
		protected var mediatorName:String;
		protected var viewComponent:Object;			
		public function getView3D():View3D
		{
			return view3d;
		}
		
	}

}