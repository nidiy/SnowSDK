package snow.mvc.patterns.mediator
{
	import snow.mvc.interfaces.*;
	import snow.mvc.patterns.observer.*;
	import snow.mvc.interfaces.IMediator;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;
	import snow.mvc.patterns.facade.Facade;
	import snow.mvc.patterns.observer.Notifier;
	
	public class Mediator extends Notifier implements IMediator, INotifier
	{

		public static const NAME:String = 'Mediator';
		private static var _nameCount:Number = 0;
		
		public function Mediator( mediatorName:String=null, viewComponent:Object=null ) {
			this.mediatorName = (mediatorName != null)?mediatorName:NAME+_nameCount;
			this.viewComponent = viewComponent;	
			_nameCount++;
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
			return [ ];
		}
		public function handleNotification( notification:INotification ):void {}		
		public function onRegister( ):void {}
		public function onRemove( ):void {}
		protected var mediatorName:String;
		protected var viewComponent:Object;
	}
}