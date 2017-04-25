package snow.mvc.interfaces
{
	public interface IController
	{

		function registerCommand(notificationName:String,commandClassRef:Class):void;		
		function executeCommand(notification:INotification):void;
		function removeCommand(notificationName:String):void;
		function hasCommand(notificationName:String):Boolean;
		
		function get facade():IFacade 		
		function set facade(value:IFacade):void 
	}
}