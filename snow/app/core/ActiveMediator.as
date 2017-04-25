package snow.app.core 
{
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	/**
	 * ...
	 * @author YouJiMap
	 */
	public class ActiveMediator extends AppSprite implements IActiveMediator 
	{
		
		public static const NAME:String = 'ActiveMediator';
		
		
		protected var _facade:IFacade
		public function ActiveMediator(mediatorName:String=null,viewComponent:Object=null) 
		{
			super()
			this.mediatorName = (mediatorName != null)?mediatorName:NAME;
			this.viewComponent = viewComponent;	
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
			_facade = value;
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
			return [];
		}
		public function handleNotification( notification:INotification ):void {}		
		public function onRegister( ):void {}
		public function onRemove( ):void {}
		protected var mediatorName:String;
		protected var viewComponent:Object;
		
	}

}