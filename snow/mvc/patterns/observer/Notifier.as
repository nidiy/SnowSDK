package snow.mvc.patterns.observer
{
	import snow.mvc.interfaces.*;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotifier;
	import snow.mvc.patterns.facade.Facade;
	
	public class Notifier implements INotifier
	{
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			facade.sendNotification( notificationName, body, type );
		}
		protected var _facade:IFacade		
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