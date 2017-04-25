package snow.mvc.core
{
	import snow.mvc.interfaces.*;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.IMediator;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.IObserver;
	import snow.mvc.interfaces.IView;
	import snow.mvc.patterns.observer.Observer;

	public class View implements IView
	{
		protected static var instance	: IView;
		protected const SINGLETON_MSG	: String = "View Singleton already constructed!";
		public static function getInstance() : IView 
		{
			instance = new View( );
			return instance;
		}
		
		protected var _facade:IFacade
		protected var mediatorMap:Array;
		protected var observerMap:Array;
		public function View( )
		{
			mediatorMap = new Array();
			observerMap = new Array();	
			initializeView();	
		}
		protected function initializeView():void 
		{
			
		}
		public function registerObserver ( notificationName:String, observer:IObserver ):void
		{
			if( observerMap[notificationName] != null ){
				observerMap[notificationName].push(observer);
			} else {
				observerMap[notificationName] = [observer];	
			}
		}
		public function notifyObservers( notification:INotification ):void
		{
			if( observerMap[ notification.getName() ] != null ) {
				var observers:Array = observerMap[ notification.getName() ] as Array;
				for (var i:Number = 0; i < observers.length; i++) {
					var observer:IObserver = observers[ i ] as IObserver;
					observer.notifyObserver(notification);
				}
			}
		}
		public function registerMediator(mediator:IMediator):void
		{
			if (mediator.facade == null) mediator.facade = this.facade;
			mediatorMap[ mediator.getMediatorName() ] = mediator;
			var interests:Array = mediator.listNotificationInterests();
			if ( interests.length > 0) 
			{
				var observer:Observer = new Observer( mediator.handleNotification, mediator);
				for (var i:Number=0;  i<interests.length;i++){
					registerObserver(interests[i],observer);
				}		
			}
			mediator.onRegister();
		}
		public function retrieveMediator( mediatorName:String ) : IMediator
		{
			return mediatorMap[mediatorName];
		}
		public function removeMediator( mediatorName:String ) : IMediator
		{
			for ( var notificationName:String in observerMap ) {
				var observers:Array = observerMap[ notificationName ];
				var removalTargets:Array = new Array();
				for ( var i:int=0;  i< observers.length; i++ ) {
					if ( Observer(observers[i]).compareNotifyContext( retrieveMediator( mediatorName ) ) == true ) {
						removalTargets.push(i);
					}
				}
				var target:int;
				while ( removalTargets.length > 0 ) 
				{
					target = removalTargets.pop();
					observers.splice(target,1);
				}
				if ( observers.length == 0 ) {
					delete observerMap[ notificationName ];		
				}
			}			
			var mediator:IMediator = mediatorMap[ mediatorName ] as IMediator;
			delete mediatorMap[ mediatorName ];
			if (mediator) mediator.onRemove();
			return mediator;
		}
		public function hasMediator( mediatorName:String ) : Boolean
		{
			return mediatorMap[ mediatorName ] != null;
		}
		
		public function get facade():IFacade 
		{
			return _facade;
		}
		
		public function set facade(value:IFacade):void 
		{
			_facade = value;
		}
	}
}