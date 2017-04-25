package snow.mvc.interfaces
{
	
	public interface IObserver
	{

		function setNotifyMethod( notifyMethod:Function ):void;
		

		function setNotifyContext( notifyContext:Object ):void;
		

		function notifyObserver( notification:INotification ):void;
		
		function compareNotifyContext( object:Object ):Boolean;
	}
}